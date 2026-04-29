#!/data/data/com.termux/files/usr/bin/bash
# ╔═════════════════════════════════════════════════════════════╗
# ║  RDxOS v1.1.1 — LEVIATHAN  │  RED DRAGON ELITE              ║
# ║  ARCHITECT: SHIN  │  BFS LICENSE v6.66                      ║
# ╚═════════════════════════════════════════════════════════════╝

# ── ENVIRONMENT ──────────────────────────────────────────────────
export LANG="C.UTF-8"
export TERM="${TERM:-xterm-256color}"

# ── PALETTE (256-color) ──────────────────────────────────────────
R='\033[38;5;196m'   # Ruby Red
r='\033[38;5;160m'   # Blood Red
G='\033[38;5;46m'    # Venom Green
g='\033[38;5;34m'    # Moss Green
Y='\033[38;5;220m'   # Gold
A='\033[38;5;214m'   # Amber
C='\033[38;5;51m'    # Cyan
W='\033[38;5;255m'   # White
D='\033[38;5;240m'   # Dim
S='\033[38;5;238m'   # Shade (borders)
H='\033[38;5;245m'   # Ghost
bR='\033[1;38;5;196m'
bG='\033[1;38;5;46m'
bW='\033[1;38;5;255m'
bY='\033[1;38;5;220m'
NC='\033[0m'
HIDE='\033[?25l'
SHOW='\033[?25h'

# ── RUNES ────────────────────────────────────────────────────────
RUNES=("ᚠ" "ᚢ" "ᚦ" "ᚨ" "ᚱ" "ᚲ" "ᚷ" "ᚹ" "ᚺ" "ᚾ" "ᛁ" "ᛃ" "ᛇ" "ᛈ" "ᛉ" "ᛋ" "ᛏ" "ᛒ" "ᛖ" "ᛗ" "ᛚ" "ᛜ" "ᛞ" "ᛟ")

# ── PATHS & CONFIG ───────────────────────────────────────────────
MOD_DIR="$HOME/RDOS_MODULES"
CACHE="$HOME/.rdx_cache"
LOGF="$CACHE/rdxos.log"
CONF="$CACHE/rdxos.conf"
ALERTS="$CACHE/alerts"
VER="1.1.1"
CODENAME="LEVIATHAN"
TARGET="127.0.0.1"
T0=$(date +%s)
SID="$(tr -dc 'A-F0-9' </dev/urandom 2>/dev/null | head -c 8 || echo 'DEADBEEF')"

# Bootstrap dirs — guard against CACHE being a file
[[ -f "$CACHE" ]] && rm -f "$CACHE"
mkdir -p "$CACHE" \
         "$MOD_DIR/1_RECON" \
         "$MOD_DIR/2_ASSAULT" \
         "$MOD_DIR/3_DEFENSE" \
         "$MOD_DIR/4_PSY-OPS" \
         "$MOD_DIR/5_DEV-TOOLS" \
         "$MOD_DIR/99_SYSTEM/HUD"

# Default config
if [[ ! -f "$CONF" ]]; then
    printf 'BOOT_FX=1\nOP="SerpentsByte"\n' > "$CONF"
fi
source "$CONF" 2>/dev/null
# Guard: conf must never overwrite runtime vars
[[ -z "$T0" || "$T0" == "0" ]] && T0=$(date +%s)

# ════════════════════════════════════════════════════════════════
#  DRAWING ENGINE  —  zero printf-format-injection risk
#  KEY PRINCIPLE: bars and rules are echo-ne only.
#  No ANSI color vars ever appear in printf format strings.
# ════════════════════════════════════════════════════════════════

# Terminal width (live, safe)
TW() { local w; w=$(stty size 2>/dev/null | awk '{print $2}'); [[ "$w" =~ ^[0-9]+$ ]] && (( w >= 20 )) && echo "$w" && return; w=$(tput cols 2>/dev/null); [[ "$w" =~ ^[0-9]+$ ]] && (( w >= 20 )) && echo "$w" && return; echo "72"; }

# Repeat char N times as a plain string (no color, used for borders via tr)
_rep() {
    local n="$1" ch="${2:- }"
    local s=""
    local i; for (( i=0; i<n; i++ )); do s="${s}${ch}"; done
    printf '%s' "$s"
}

# Full-width horizontal rule — echo only, no printf format risk
rule() {
    local ch="${1:-─}" col="${2:-$S}"
    local w; w=$(TW)
    local line; line=$(_rep "$w" "$ch")
    echo -e "${col}${line}${NC}"
}

# Section label rule:   ── LABEL ──────────
lrule() {
    local label="$1" col="${2:-$S}"
    local w; w=$(TW)
    # strip ANSI for true char count
    local lraw; lraw=$(printf '%b' "$label" | sed 's/\x1b\[[0-9;]*m//g')
    local llen=${#lraw}
    local total=$(( w - llen - 4 ))
    [[ $total -lt 2 ]] && total=2
    local left=2
    local right=$(( total - left ))
    [[ $right -lt 1 ]] && right=1
    local ll; ll=$(_rep "$left" "─")
    local rl; rl=$(_rep "$right" "─")
    echo -e "${col}${ll}${NC} ${label} ${col}${rl}${NC}"
}

# Progress bar — pure bash echo, no printf
bar() {
    local pct="${1:-0}" bw="${2:-16}" fc="${3:-$G}" ec="${4:-$S}"
    [[ ! "$pct" =~ ^[0-9]+$ ]] && pct=0
    [[ $pct -gt 100 ]] && pct=100
    [[ $bw -lt 1 ]] && bw=1
    local f=$(( pct * bw / 100 ))
    local e=$(( bw - f ))
    local filled="" empty=""
    local i
    for (( i=0; i<f; i++ )); do filled="${filled}█"; done
    for (( i=0; i<e; i++ )); do empty="${empty}░"; done
    echo -ne "${fc}${filled}${ec}${empty}${NC}"
}

# Color by pct threshold
pc() {
    local p="$1"
    [[ ! "$p" =~ ^[0-9]+$ ]] && echo "$H" && return
    (( p >= 85 )) && echo "$R" && return
    (( p >= 60 )) && echo "$A" && return
    echo "$G"
}

# Safe log
log()   { echo "[$(date '+%H:%M:%S')] $*" >> "$LOGF" 2>/dev/null; }
alert() { echo "$(date '+%H:%M:%S')|$1|$2" >> "$ALERTS" 2>/dev/null; }

pause() {
    echo
    echo -e "  ${D}◈ ENTER TO CONTINUE${NC}"
    read -r
}

# ════════════════════════════════════════════════════════════════
#  SENSOR ARRAY
# ════════════════════════════════════════════════════════════════

get_cpu() {
    # METHOD 1: python3 reads /proc/stat (bypasses Termux shell permission block)
    local pct
    pct=$(python3 -c "
import time
def rs():
    with open('/proc/stat') as f:
        p=f.readline().split()
    t=int(p[1])+int(p[2])+int(p[3])+int(p[4])
    return t,int(p[4])
t1,i1=rs(); time.sleep(0.3); t2,i2=rs()
dt=t2-t1
print(0 if dt<=0 else int((dt-(i2-i1))*100/dt))
" 2>/dev/null)
    [[ "$pct" =~ ^[0-9]+$ ]] && echo "$pct" && return

    # METHOD 2: top busybox Termux format
    pct=$(top -bn1 2>/dev/null | awk '
        /%cpu|%Cpu|CPU/{
            for(i=1;i<=NF;i++){
                if($i~/^[0-9]+\.?[0-9]*$/ && $(i+1)~/id/){print 100-int($i);exit}
                if($i~/[0-9]+%id/){gsub(/%id/,"",$i);print 100-int($i);exit}
            }
        }' | head -1)
    [[ "$pct" =~ ^[0-9]+$ ]] && echo "$pct" && return

    # METHOD 3: vmstat
    pct=$(vmstat 1 2 2>/dev/null | tail -1 | awk '{if(NF>=15)print 100-$15}')
    [[ "$pct" =~ ^[0-9]+$ ]] && echo "$pct" && return

    echo "??"
}

get_ram() {
    local tot avail
    tot=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
    avail=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}')
    [[ -z "$tot" || "$tot" == "0" ]] && echo "??|??|??" && return
    local used=$(( tot - avail ))
    echo "$(( used*100/tot ))|$(( used/1024 ))|$(( tot/1024 ))"
}

get_temp() {
    local t

    # METHOD 1: thermal zones (works on most ROMs)
    for z in /sys/class/thermal/thermal_zone*/temp; do
        [[ -f "$z" ]] || continue
        t=$(cat "$z" 2>/dev/null)
        if [[ "$t" =~ ^[0-9]+$ ]]; then
            # values > 1000 are in millidegrees
            if (( t > 1000 )); then echo $(( t/1000 ))
            else echo "$t"
            fi
            return
        fi
    done

    # METHOD 2: termux-battery-status has temperature field
    if command -v termux-battery-status &>/dev/null; then
        t=$(termux-battery-status 2>/dev/null | grep -oP '"temperature":\s*\K[0-9.]+' | head -1)
        [[ -n "$t" ]] && printf "%.0f" "$t" && return
    fi

    # METHOD 3: python3 reads thermal directly
    t=$(python3 -c "
import glob, os
for p in sorted(glob.glob('/sys/class/thermal/thermal_zone*/temp')):
    try:
        v=int(open(p).read().strip())
        print(v//1000 if v>1000 else v); break
    except: pass
" 2>/dev/null)
    [[ "$t" =~ ^[0-9]+$ ]] && echo "$t" && return

    # METHOD 4: /sys/devices cpu temp nodes
    for p in /sys/devices/virtual/thermal/thermal_zone*/temp \
              /sys/kernel/debug/tegra_thermal \
              /proc/driver/thermal; do
        [[ -f "$p" ]] || continue
        t=$(cat "$p" 2>/dev/null | grep -oP '[0-9]+' | head -1)
        [[ "$t" =~ ^[0-9]+$ ]] && (( t > 1000 )) && echo $(( t/1000 )) && return
        [[ "$t" =~ ^[0-9]+$ ]] && echo "$t" && return
    done

    echo "??"
}

get_bat() {
    command -v termux-battery-status &>/dev/null || { echo "??|N/A|N/A"; return; }
    local raw; raw=$(termux-battery-status 2>/dev/null)
    local p s h
    p=$(echo "$raw" | grep -oP '"percentage":\s*\K\d+' | head -1)
    s=$(echo "$raw" | grep -oP '"status":\s*"\K[^"]+' | head -1)
    h=$(echo "$raw" | grep -oP '"health":\s*"\K[^"]+' | head -1)
    echo "${p:-??}|${s:-N/A}|${h:-OK}"
}

get_storage() {
    df -h "$HOME" 2>/dev/null | awk 'NR==2{print $3"|"$2"|"$5}' || echo "?|?|?"
}

get_wan() {
    local cf="$CACHE/wan_ip"
    local age=999
    if [[ -f "$cf" ]]; then
        local mtime; mtime=$(date -r "$cf" +%s 2>/dev/null || echo 0)
        age=$(( $(date +%s) - mtime ))
    fi
    if [[ $age -gt 120 ]]; then
        ( curl -s --max-time 4 https://api.ipify.org > "$cf" 2>/dev/null & )
    fi
    local ip; ip=$(cat "$cf" 2>/dev/null)
    [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3} ]] && echo "$ip" || echo "..."
}

get_lan() {
    ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K[\d.]+' | head -1 || \
    ifconfig 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v '^127\.' | head -1 || \
    echo "OFFLINE"
}

get_uptime() {
    local s
    s=$(python3 -c "print(int(open('/proc/uptime').read().split()[0]))" 2>/dev/null)
    [[ ! "$s" =~ ^[0-9]+$ ]] && s=$(awk '{printf "%d",$1}' /proc/uptime 2>/dev/null || echo 0)
    printf "%02dh%02dm" $(( s/3600 )) $(( (s%3600)/60 ))
}

# ════════════════════════════════════════════════════════════════
#  ANIMATIONS
# ════════════════════════════════════════════════════════════════

runic_rain() {
    local secs="${1:-2}"
    local w; w=$(TW)
    local end=$(( $(date +%s) + secs ))
    echo -ne "$HIDE"
    while (( $(date +%s) < end )); do
        local line="" i
        for (( i=0; i<w; i++ )); do
            local ri=$(( RANDOM % 24 ))
            local rn="${RUNES[$ri]}"
            case $(( RANDOM % 6 )) in
                0) line="${line}${bG}${rn}${NC}" ;;
                1) line="${line}${G}${rn}${NC}"  ;;
                2) line="${line}${g}${rn}${NC}"  ;;
                3) line="${line}${R}${rn}${NC}"  ;;
                4) line="${line}${r}${rn}${NC}"  ;;
                *) line="${line}${S}${rn}${NC}"  ;;
            esac
        done
        echo -e "$line"
        usleep 45000
    done
    echo -ne "$SHOW"
    clear
}

spin() {
    local msg="$1" secs="${2:-2}"
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local end=$(( $(date +%s) + secs )) i=0
    echo -ne "$HIDE"
    while (( $(date +%s) < end )); do
        echo -ne "\r  ${G}${frames[$((i%10))]}${NC} ${D}${msg}${NC}   "
        sleep 0.08; (( i++ ))
    done
    echo -e "\r  ${G}✓${NC} ${D}${msg}${NC}   "
    echo -ne "$SHOW"
}

typewrite() {
    local text="$1" delay="${2:-0.03}" col="${3:-$G}"
    echo -ne "${col}"
    local i; for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"; sleep "$delay"
    done
    echo -e "${NC}"
}

glitch() {
    local text="$1" col="${2:-$R}"
    local gc=('@' '#' '%' '?' '!' '*' '~')
    local p
    for p in 1 2 3; do
        local out="" i
        for (( i=0; i<${#text}; i++ )); do
            (( RANDOM % 4 == 0 )) \
                && out="${out}${gc[$((RANDOM%7))]}" \
                || out="${out}${text:$i:1}"
        done
        echo -ne "\r  ${col}${out}${NC}"; sleep 0.06
    done
    echo -e "\r  ${col}${text}${NC}"
}

# ════════════════════════════════════════════════════════════════
#  BOOT SEQUENCE
# ════════════════════════════════════════════════════════════════

boot_sequence() {
    clear; echo -ne "$HIDE"
    runic_rain 2
    clear; echo

    # Narrow ASCII logo — safe on any phone width
    echo -e "${R}  ██████╗ ██████╗ ██╗  ██╗ ██████╗ ███████╗${NC}"
    echo -e "${r}  ██╔══██╗██╔══██╗╚██╗██╔╝██╔═══██╗██╔════╝${NC}"
    echo -e "${R}  ██████╔╝██║  ██║ ╚███╔╝ ██║   ██║███████╗${NC}"
    echo -e "${r}  ██╔══██╗██║  ██║ ██╔██╗ ██║   ██║╚════██║${NC}"
    echo -e "${R}  ██║  ██║██████╔╝██╔╝ ██╗╚██████╔╝███████║${NC}"
    echo -e "${r}  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝${NC}"
    echo
    echo -e "  ${Y}v${VER} — ${CODENAME}${NC}  ${D}│  BFS-6.66  │  SID: ${H}${SID}${NC}"
    rule "─" "$S"
    echo

    local steps=(
        "KERNEL INTERFACE INIT"
        "RUNIC CODEX LOADED [24 GLYPHS]"
        "MODULE FILESYSTEM MOUNTED"
        "HARDWARE SENSORS ONLINE"
        "CHROMATIC MATRIX CALIBRATED"
        "NEURAL PATHWAYS LINKED"
        "SHADOW PROTOCOLS ACTIVE"
        "LEVIATHAN CORE IGNITED"
    )
    for s in "${steps[@]}"; do
        echo -e "  ${S}▸${NC} ${D}${s}${NC}"; sleep 0.10
    done
    echo
    rule "─" "$S"
    echo

    # Hardware info
    echo -e "  ${D}DEVICE  ${NC}$(getprop ro.product.model 2>/dev/null || echo N/A)"
    echo -e "  ${D}ANDROID ${NC}$(getprop ro.build.version.release 2>/dev/null || echo N/A)"
    echo -e "  ${D}KERNEL  ${NC}$(uname -r 2>/dev/null | cut -d- -f1)"
    echo -e "  ${D}CPU     ${NC}$(nproc 2>/dev/null || echo ?)x cores"
    local rr; rr=$(get_ram)
    echo -e "  ${D}RAM     ${NC}${rr##*|}MB total"
    echo
    glitch "  LEVIATHAN AWAKENS..." "$R"
    echo -ne "  ${D}OPERATOR: ${NC}"
    typewrite "${OP:-SerpentsByte}" 0.05 "$Y"
    echo
    spin "VERIFYING ARSENAL..." 1
    echo -ne "$SHOW"
    sleep 0.3
}

# ════════════════════════════════════════════════════════════════
#  THE LEVIATHAN HUD
#  Design principle: NO right-border alignment.
#  Full-width bars auto-fit. Labels left-aligned. Clean stacking.
# ════════════════════════════════════════════════════════════════

draw_hud() {
    clear
    local w; w=$(TW)
    local bw=$(( w - 4 ))   # bar width = terminal minus indent+margin
    [[ $bw -lt 8 ]] && bw=8

    # ── Collect data ─────────────────────────────────────────────
    local cpu;  cpu=$(get_cpu)
    local rraw; rraw=$(get_ram)
    local rpct="${rraw%%|*}"
    local rrest="${rraw#*|}"; local rused="${rrest%%|*}"; local rtot="${rrest##*|}"
    local temp; temp=$(get_temp)
    local sraw; sraw=$(get_storage)
    local sused="${sraw%%|*}"; local srest="${sraw#*|}"; local stot="${srest%%|*}"; local spct="${srest##*|}"
    local braw; braw=$(get_bat)
    local bpct="${braw%%|*}"; local brest="${braw#*|}"; local bstat="${brest%%|*}"; local bhlth="${brest##*|}"
    local lan;  lan=$(get_lan)
    local wan;  wan=$(get_wan)
    local up;   up=$(get_uptime)
    local procs; procs=$(ls /proc 2>/dev/null | grep -c '^[0-9]')
    local tor_on=0; pgrep -x tor &>/dev/null && tor_on=1

    # Session duration
    local now; now=$(date +%s)
    local sd=$(( now - T0 ))
    local sess; printf -v sess "%02dh%02dm" $(( sd/3600 )) $(( (sd%3600)/60 ))

    # ── Color logic ──────────────────────────────────────────────
    local cpu_c;  cpu_c=$(pc "$cpu")
    local ram_c;  ram_c=$(pc "$rpct")
    local bat_c="$G"
    [[ "$bpct" =~ ^[0-9]+$ ]] && (( bpct<=50 )) && bat_c="$A"
    [[ "$bpct" =~ ^[0-9]+$ ]] && (( bpct<=20 )) && bat_c="$R"
    [[ "$bstat" == "CHARGING" ]] && bat_c="$C"
    local bat_icon="▮"
    [[ "$bstat" == "CHARGING" ]] && bat_icon="⚡"
    [[ "$bpct" =~ ^[0-9]+$ ]] && (( bpct<=20 )) && bat_icon="⚠"
    local temp_c="$G"
    [[ "$temp" =~ ^[0-9]+$ ]] && (( temp>=50 )) && temp_c="$A"
    [[ "$temp" =~ ^[0-9]+$ ]] && (( temp>=70 )) && temp_c="$R"
    local sec_c="$R" sec_lbl="EXPOSED" sec_icon="⚠"
    (( tor_on )) && sec_c="$G" && sec_lbl="GHOST MODE" && sec_icon="👁"
    local acc_lbl="LVL-3 USER"
    (( tor_on )) && acc_lbl="LVL-9 GOD"

    # Storage pct as number
    local spct_n; spct_n=$(echo "$spct" | tr -d '%')
    [[ ! "$spct_n" =~ ^[0-9]+$ ]] && spct_n=0

    # ════ HEADER ═════════════════════════════════════════════════
    rule "═" "$R"
    echo -e "  ${bR}ᛞ RDxOS${NC} ${bW}v${VER}${NC}  ${D}[${CODENAME}]${NC}  ${D}▸${NC}  ${H}${SID}${NC}"
    echo -e "  ${D}OP:${NC} ${Y}${OP:-SerpentsByte}${NC}  ${D}│${NC}  ${sec_c}${acc_lbl}${NC}  ${D}│${NC}  ${D}TGT:${NC} ${R}${TARGET}${NC}"
    rule "═" "$R"

    # ════ CPU ════════════════════════════════════════════════════
    echo -e "\n  ${D}◈ CPU  ${cpu_c}${cpu:-??}%${NC}  ${D}$(nproc 2>/dev/null || echo ?) cores${NC}"
    echo -ne "  "; bar "${cpu:-0}" "$bw" "$cpu_c" "$S"; echo

    # ════ RAM ════════════════════════════════════════════════════
    echo -e "\n  ${D}◈ RAM  ${ram_c}${rpct:-??}%${NC}  ${D}${rused:-?} / ${rtot:-?} MB${NC}"
    echo -ne "  "; bar "${rpct:-0}" "$bw" "$ram_c" "$S"; echo

    # ════ STORAGE ════════════════════════════════════════════════
    echo -e "\n  ${D}◈ STORAGE  ${C}${spct:-??}${NC}  ${D}${sused:-?} / ${stot:-?}${NC}"
    echo -ne "  "; bar "$spct_n" "$bw" "$C" "$S"; echo

    rule "─" "$S"

    # ════ NETWORK ════════════════════════════════════════════════
    echo -e "\n  ${D}◈ NETWORK${NC}  ${sec_c}${sec_icon} ${sec_lbl}${NC}"
    echo -e "  ${D}LAN${NC}   ${W}${lan}${NC}"
    echo -e "  ${D}WAN${NC}   ${sec_c}${wan}${NC}"
    if (( tor_on )); then
        echo -e "  ${G}◉ TOR ACTIVE — IDENTITY MASKED${NC}"
    else
        echo -e "  ${R}○ TOR OFFLINE${NC}"
    fi

    rule "─" "$S"

    # ════ POWER ══════════════════════════════════════════════════
    echo -e "\n  ${D}◈ POWER  ${bat_c}${bat_icon} ${bpct:-??}%${NC}  ${D}${bstat:-N/A}  ♥ ${bhlth:-N/A}${NC}"
    echo -ne "  "; bar "${bpct:-0}" "$bw" "$bat_c" "$S"; echo

    # ════ SYSTEM ═════════════════════════════════════════════════
    echo -e "\n  ${D}◈ SYSTEM${NC}"
    echo -e "  ${D}TEMP${NC}    ${temp_c}${temp:-??}°C${NC}"
    echo -e "  ${D}UPTIME${NC}  ${H}${up}${NC}"
    echo -e "  ${D}SESSION${NC} ${H}${sess}${NC}  ${D}PROCS${NC} ${H}${procs}${NC}"

    # ════ HUD PLUGINS ════════════════════════════════════════════
    for hf in "$MOD_DIR/99_SYSTEM/HUD/"*.sh; do
        [[ -f "$hf" && -x "$hf" ]] || continue
        rule "─" "$S"
        bash "$hf" 2>/dev/null | head -4 | while IFS= read -r hline; do
            echo -e "  ${hline}"
        done
    done

    # ════ ALERTS ═════════════════════════════════════════════════
    if [[ -f "$ALERTS" ]]; then
        local cnt; cnt=$(wc -l < "$ALERTS" 2>/dev/null || echo 0)
        if (( cnt > 0 )); then
            rule "─" "$A"
            local last; last=$(tail -1 "$ALERTS")
            local at="${last%%|*}" ar="${last#*|}" al="${ar%%|*}" am="${ar##*|}"
            local ac="$A"
            [[ "$al" == "CRIT" ]] && ac="$R"
            [[ "$al" == "INFO" ]] && ac="$C"
            [[ -z "$am" ]] && am="(no message)"
            echo -e "  ${ac}⚑ ALERTS [${cnt}]${NC}  ${D}${at}${NC}  ${ac}${al}:${NC} ${H}${am}${NC}"
        fi
    fi

    rule "═" "$S"
    echo
}

# ════════════════════════════════════════════════════════════════
#  MODULE ENGINE
# ════════════════════════════════════════════════════════════════

run_module() {
    local f="$1"
    echo
    echo -e "  ${R}▶ RUN${NC} ${W}$(basename "$f")${NC}"
    rule "─" "$S"
    local wrap=""
    pgrep -x tor &>/dev/null && command -v proxychains4 &>/dev/null && wrap="proxychains4"
    [[ -n "$wrap" ]] && echo -e "  ${G}◉ VIA TOR${NC}"
    log "RUN $f"
    if   [[ "$f" == *.py ]];  then python3 "$f"
    elif [[ -n "$wrap" ]];    then $wrap bash "$f"
    else bash "$f"; fi
    echo; echo -e "  ${G}✓ DONE${NC}"
    log "END $f"
    pause
}

browse_sector() {
    local path="$1" name="$2"
    while true; do
        draw_hud
        echo -e "  ${W}◈ SECTOR:${NC} ${R}${name}${NC}"
        rule "─" "$S"
        local i=1
        local -a scripts=()
        for f in "$MOD_DIR/$path"/*.sh "$MOD_DIR/$path"/*.py; do
            [[ -f "$f" ]] || continue
            local fn; fn=$(basename "$f")
            local sz; sz=$(wc -c < "$f" 2>/dev/null || echo "?")
            local mt; mt=$(date -r "$f" "+%m-%d %H:%M" 2>/dev/null || echo "??")
            printf "  ${Y}[%2d]${NC} ${W}%-26s${NC} ${D}%6sB  %s${NC}\n" "$i" "$fn" "$sz" "$mt"
            scripts+=("$f"); (( i++ ))
        done
        (( ${#scripts[@]} == 0 )) && echo -e "  ${S}  ∅  VOID — NO MODULES${NC}"
        echo
        rule "─" "$S"
        echo -e "  ${D}[b] BACK  [d] DEL #  [e] EDIT #${NC}"
        echo; echo -ne "  ${R}${name}${NC}${G}>>${NC} "; read -r sel
        case "$sel" in
            b) return ;;
            d)
                echo -ne "  ${R}DEL #:${NC} "; read -r n
                if [[ "$n" =~ ^[0-9]+$ && $n -ge 1 && $n -le ${#scripts[@]} ]]; then
                    echo -ne "  ${R}CONFIRM [y/N]:${NC} "; read -r ok
                    [[ "$ok" == "y" ]] && rm -f "${scripts[$((n-1))]}" && echo -e "  ${R}✓ DELETED${NC}"
                fi ;;
            e)
                echo -ne "  ${Y}EDIT #:${NC} "; read -r n
                [[ "$n" =~ ^[0-9]+$ && $n -ge 1 && $n -le ${#scripts[@]} ]] \
                    && nano "${scripts[$((n-1))]}" ;;
            *)
                if [[ "$sel" =~ ^[0-9]+$ && $sel -ge 1 && $sel -le ${#scripts[@]} ]]; then
                    run_module "${scripts[$((sel-1))]}"
                fi ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════
#  TOR ENGINE
# ════════════════════════════════════════════════════════════════

toggle_tor() {
    echo
    if pgrep -x tor &>/dev/null; then
        echo -e "  ${R}◉ SEVERING GHOST PROTOCOL...${NC}"
        pkill -x tor; rm -f "$CACHE/wan_ip"; sleep 1
        echo -e "  ${S}TOR OFFLINE${NC}"; alert "INFO" "TOR deactivated"
    else
        echo -e "  ${G}◉ INITIATING GHOST PROTOCOL...${NC}"
        spin "CONNECTING TO ONION NETWORK..." 3
        ( nohup tor > "$CACHE/tor.log" 2>&1 & )
        sleep 4; rm -f "$CACHE/wan_ip"
        if pgrep -x tor &>/dev/null; then
            echo -e "  ${G}✓ TOR ACTIVE — IDENTITY MASKED${NC}"
            alert "INFO" "TOR activated"
        else
            echo -e "  ${R}✗ TOR FAILED — see ~/.rdx_cache/tor.log${NC}"
            alert "WARN" "TOR failed"
        fi
    fi
    sleep 1
}

# ════════════════════════════════════════════════════════════════
#  THE FORGE
# ════════════════════════════════════════════════════════════════

forge_tool() {
    clear; echo
    echo -e "  ${R}╔══════════════════╗${NC}"
    echo -e "  ${R}║  ${Y}⚒  THE FORGE${NC}  ${R}║${NC}"
    echo -e "  ${R}╚══════════════════╝${NC}"
    echo
    echo -e "  ${D}[1]${NC} RECON    ${D}[2]${NC} ASSAULT"
    echo -e "  ${D}[3]${NC} DEFENSE  ${D}[4]${NC} PSY-OPS"
    echo -e "  ${D}[5]${NC} DEV      ${D}[6]${NC} SYSTEM"
    echo; echo -ne "  ${Y}SECTOR:${NC} "; read -r sc
    case $sc in
        1) d="1_RECON" ;; 2) d="2_ASSAULT" ;; 3) d="3_DEFENSE" ;;
        4) d="4_PSY-OPS" ;; 5) d="5_DEV-TOOLS" ;; *) d="99_SYSTEM" ;;
    esac
    echo -ne "  ${Y}FILENAME (.sh/.py):${NC} "; read -r fn
    [[ -z "$fn" ]] && echo -e "  ${R}ABORT${NC}" && pause && return
    local p="$MOD_DIR/$d/$fn"
    echo
    echo -e "  ${D}[1]${NC} Blank  ${D}[2]${NC} Bash recon  ${D}[3]${NC} Python"
    echo -ne "  ${Y}TEMPLATE:${NC} "; read -r tmpl
    case "$tmpl" in
        2) cat > "$p" << 'TPL'
#!/data/data/com.termux/files/usr/bin/bash
# RDE RECON MODULE — SHIN / RED DRAGON ELITE
TARGET="${1:-127.0.0.1}"
echo "[*] Target: $TARGET"
TPL
        ;;
        3) cat > "$p" << 'TPL'
#!/usr/bin/env python3
# RDE PYTHON MODULE — SHIN / RED DRAGON ELITE
import requests, sys
TARGET = sys.argv[1] if len(sys.argv)>1 else "127.0.0.1"
print(f"[*] Target: {TARGET}")
TPL
        ;;
        *)
            if [[ "$fn" == *.py ]]; then
                echo "#!/usr/bin/env python3" > "$p"
            else
                echo "#!/data/data/com.termux/files/usr/bin/bash" > "$p"
            fi ;;
    esac
    chmod +x "$p"
    echo -e "\n  ${G}✓ FORGED:${NC} ${W}${p}${NC}"; sleep 0.5
    nano "$p"
}

# ════════════════════════════════════════════════════════════════
#  DEV TOOLBOX
# ════════════════════════════════════════════════════════════════

dev_toolbox() {
    while true; do
        draw_hud
        echo -e "  ${C}◈ DEV TOOLBOX${NC}"
        rule "─" "$S"
        echo -e "  ${D}── NETWORK ──────────────────────────${NC}"
        echo -e "  ${Y}[1]${NC} Port Scan      ${Y}[2]${NC} HTTP Headers"
        echo -e "  ${Y}[3]${NC} DNS Lookup     ${Y}[4]${NC} Traceroute"
        echo -e "  ${Y}[5]${NC} Ping Test      ${Y}[6]${NC} Whois"
        echo -e "  ${D}── GIT & CODE ───────────────────────${NC}"
        echo -e "  ${Y}[7]${NC} Git Status     ${Y}[8]${NC} Git Log"
        echo -e "  ${Y}[9]${NC} Git Clone      ${Y}[10]${NC} Pull All Repos"
        echo -e "  ${D}── SYSTEM ───────────────────────────${NC}"
        echo -e "  ${Y}[11]${NC} Processes     ${Y}[12]${NC} Kill PID"
        echo -e "  ${Y}[13]${NC} Disk Tree     ${Y}[14]${NC} Open Ports"
        echo -e "  ${Y}[15]${NC} Env Vars      ${Y}[16]${NC} Crontab"
        echo -e "  ${D}── FILE OPS ─────────────────────────${NC}"
        echo -e "  ${Y}[17]${NC} Find File     ${Y}[18]${NC} Grep In Dir"
        echo -e "  ${Y}[19]${NC} B64 Encode    ${Y}[20]${NC} B64 Decode"
        echo -e "  ${Y}[21]${NC} SHA256 File   ${Y}[22]${NC} Hex Dump"
        echo -e "  ${D}── CRYPTO ───────────────────────────${NC}"
        echo -e "  ${Y}[23]${NC} Gen Password  ${Y}[24]${NC} MD5 Hash"
        echo -e "  ${Y}[25]${NC} URL Encode    ${Y}[26]${NC} URL Decode"
        echo -e "  ${D}── INFO ─────────────────────────────${NC}"
        echo -e "  ${Y}[27]${NC} System Info   ${Y}[28]${NC} Termux Env"
        echo -e "  ${Y}[29]${NC} View Log      ${Y}[30]${NC} Clear Alerts"
        rule "─" "$S"
        echo -e "  ${D}[b] BACK${NC}"
        echo; echo -ne "  ${C}DEV${NC}${G}>>${NC} "; read -r opt

        case "$opt" in
            b) return ;;
            1)  echo -ne "\n  ${Y}HOST:${NC} "; read -r h
                echo -ne "  ${Y}PORTS (e.g. 1-1000):${NC} "; read -r ports
                if command -v nmap &>/dev/null; then
                    nmap -p "${ports:-1-1000}" --open -T4 "${h:-127.0.0.1}" 2>/dev/null \
                        | grep -E "^[0-9]|Nmap|open"
                else
                    echo -e "  ${R}nmap not installed${NC}"
                fi; pause ;;
            2)  echo -ne "\n  ${Y}URL:${NC} "; read -r u
                curl -sI "${u:-http://example.com}" 2>/dev/null | head -30; pause ;;
            3)  echo -ne "\n  ${Y}DOMAIN:${NC} "; read -r dom
                nslookup "${dom:-example.com}" 2>/dev/null \
                    || host "${dom:-example.com}" 2>/dev/null; pause ;;
            4)  echo -ne "\n  ${Y}HOST:${NC} "; read -r h
                traceroute -m 15 "${h:-8.8.8.8}" 2>/dev/null || echo "not available"; pause ;;
            5)  echo -ne "\n  ${Y}HOST:${NC} "; read -r h
                echo -ne "  ${Y}COUNT:${NC} "; read -r cnt
                ping -c "${cnt:-10}" "${h:-8.8.8.8}"; pause ;;
            6)  echo -ne "\n  ${Y}DOMAIN:${NC} "; read -r dom
                whois "${dom:-example.com}" 2>/dev/null | head -40; pause ;;
            7)  git -C "$PWD" status 2>/dev/null || echo "Not a git repo"; pause ;;
            8)  git -C "$PWD" log --oneline --graph --decorate --all 2>/dev/null \
                    | head -30 || echo "Not a git repo"; pause ;;
            9)  echo -ne "\n  ${Y}REPO URL:${NC} "; read -r repo
                git clone "$repo" 2>&1 | tail -5; pause ;;
            10) find "$HOME" -maxdepth 3 -name ".git" -type d 2>/dev/null | while read -r gd; do
                    local rd="${gd%/.git}"
                    echo -ne "  ${S}$(basename "$rd")${NC}... "
                    git -C "$rd" pull --ff-only 2>&1 | tail -1
                done; pause ;;
            11) ps aux 2>/dev/null | head -25 || ps -e | head -25; pause ;;
            12) ps aux 2>/dev/null | head -15
                echo -ne "\n  ${R}PID:${NC} "; read -r pid
                [[ "$pid" =~ ^[0-9]+$ ]] \
                    && kill "$pid" && echo -e "  ${R}✓ KILLED ${pid}${NC}" \
                    || echo -e "  ${R}INVALID PID${NC}"
                pause ;;
            13) du -sh "$HOME"/* 2>/dev/null | sort -hr | head -20; pause ;;
            14) ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null | head -20; pause ;;
            15) env | sort | grep -v LS_COLORS | head -40; pause ;;
            16) crontab -l 2>/dev/null || echo "No cron jobs"; pause ;;
            17) echo -ne "\n  ${Y}PATTERN:${NC} "; read -r pt
                find "$HOME" -name "*${pt}*" 2>/dev/null | head -30; pause ;;
            18) echo -ne "\n  ${Y}PATTERN:${NC} "; read -r pt
                echo -ne "  ${Y}DIR:${NC} "; read -r dd
                grep -r -l "$pt" "${dd:-$HOME}" 2>/dev/null | head -20; pause ;;
            19) echo -ne "\n  ${Y}TEXT:${NC} "; read -r t
                echo -n "$t" | base64; pause ;;
            20) echo -ne "\n  ${Y}B64:${NC} "; read -r t
                echo "$t" | base64 -d && echo; pause ;;
            21) echo -ne "\n  ${Y}FILE:${NC} "; read -r f
                sha256sum "$f" 2>/dev/null || echo "File not found"; pause ;;
            22) echo -ne "\n  ${Y}FILE:${NC} "; read -r f
                xxd "$f" 2>/dev/null | head -30 \
                    || hexdump -C "$f" 2>/dev/null | head -30; pause ;;
            23) echo -ne "\n  ${Y}LENGTH (def 32):${NC} "; read -r l
                echo -e "  ${G}$(tr -dc 'A-Za-z0-9!@#$%^&*' </dev/urandom | head -c "${l:-32}")${NC}"
                pause ;;
            24) echo -ne "\n  ${Y}TEXT:${NC} "; read -r t
                echo -n "$t" | md5sum; pause ;;
            25) echo -ne "\n  ${Y}TEXT:${NC} "; read -r t
                python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" \
                    "$t" 2>/dev/null; pause ;;
            26) echo -ne "\n  ${Y}ENCODED:${NC} "; read -r t
                python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(sys.argv[1]))" \
                    "$t" 2>/dev/null; pause ;;
            27) echo
                echo -e "  ${C}DEVICE  ${NC}$(getprop ro.product.model 2>/dev/null || echo N/A)"
                echo -e "  ${C}ANDROID ${NC}$(getprop ro.build.version.release 2>/dev/null || echo N/A)"
                echo -e "  ${C}KERNEL  ${NC}$(uname -r 2>/dev/null)"
                echo -e "  ${C}ARCH    ${NC}$(uname -m 2>/dev/null)"
                echo -e "  ${C}CPU     ${NC}$(nproc 2>/dev/null) cores"
                echo -e "  ${C}RAM     ${NC}$(free -m 2>/dev/null | awk '/Mem:/{print $2}')MB"
                echo -e "  ${C}PKGS    ${NC}$(pkg list-installed 2>/dev/null | wc -l) installed"
                pause ;;
            28) echo
                echo -e "  ${C}TERMUX_VER${NC}  ${TERMUX_VERSION:-N/A}"
                echo -e "  ${C}PREFIX    ${NC}  ${PREFIX:-N/A}"
                echo -e "  ${C}HOME      ${NC}  $HOME"
                echo -e "  ${C}SHELL     ${NC}  $SHELL"
                pause ;;
            29) echo
                if [[ -f "$LOGF" ]]; then
                    tail -30 "$LOGF" | while IFS= read -r line; do
                        echo -e "  ${D}${line}${NC}"
                    done
                else
                    echo -e "  ${S}No logs yet${NC}"
                fi
                pause ;;
            30) rm -f "$ALERTS"; echo -e "\n  ${G}✓ ALERTS CLEARED${NC}"; sleep 1 ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════
#  SETTINGS
# ════════════════════════════════════════════════════════════════

settings_menu() {
    while true; do
        draw_hud
        echo -e "  ${Y}◈ SETTINGS${NC}"
        rule "─" "$S"
        echo -e "  ${D}[1]${NC} Operator Name  ${D}now:${NC} ${Y}${OP:-SerpentsByte}${NC}"
        echo -e "  ${D}[2]${NC} Set Target     ${D}now:${NC} ${R}${TARGET}${NC}"
        echo -e "  ${D}[3]${NC} Install Packages"
        echo -e "  ${D}[4]${NC} Clear Cache"
        echo -e "  ${D}[5]${NC} Toggle Boot FX  ${D}now:${NC} ${G}${BOOT_FX:-1}${NC}"
        echo -e "  ${D}[6]${NC} Edit Config"
        echo -e "  ${D}[7]${NC} Backup Modules"
        rule "─" "$S"
        echo -e "  ${D}[b] BACK${NC}"
        echo; echo -ne "  ${Y}CFG${NC}${G}>>${NC} "; read -r o
        case "$o" in
            b) return ;;
            1) echo -ne "\n  ${Y}NAME:${NC} "; read -r n
               sed -i "s|^OP=.*|OP=\"${n}\"|" "$CONF"; OP="$n"
               echo -e "  ${G}✓ UPDATED${NC}"; sleep 1 ;;
            2) echo -ne "\n  ${Y}TARGET:${NC} "; read -r t
               TARGET="$t"; echo -e "  ${R}◉ TARGET: ${W}${TARGET}${NC}"; sleep 1 ;;
            3) for p in tor proxychains-ng nmap curl whois netcat-openbsd \
                        nano termux-api python git wget; do
                   echo -ne "  ${S}${p}${NC}... "
                   command -v "$p" &>/dev/null \
                       && echo -e "${G}✓${NC}" \
                       || { pkg install "$p" -y &>/dev/null \
                            && echo -e "${G}installed${NC}" \
                            || echo -e "${R}failed${NC}"; }
               done; pause ;;
            4) rm -f "$CACHE/wan_ip"
               echo -e "\n  ${G}✓ CACHE CLEARED${NC}"; sleep 1 ;;
            5) [[ "${BOOT_FX:-1}" == "1" ]] && BOOT_FX=0 || BOOT_FX=1
               sed -i "s/^BOOT_FX=.*/BOOT_FX=${BOOT_FX}/" "$CONF"
               echo -e "  ${G}✓ BOOT_FX=${BOOT_FX}${NC}"; sleep 1 ;;
            6) nano "$CONF"; source "$CONF" 2>/dev/null ;;
            7) local bk="$HOME/rdxos_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
               tar -czf "$bk" "$MOD_DIR" 2>/dev/null \
                   && echo -e "\n  ${G}✓ BACKUP: ${W}${bk}${NC}" \
                   || echo -e "\n  ${R}BACKUP FAILED${NC}"
               pause ;;
        esac
    done
}

# ════════════════════════════════════════════════════════════════
#  SHUTDOWN
# ════════════════════════════════════════════════════════════════

shutdown_seq() {
    clear; echo -ne "$HIDE"; echo
    echo -e "  ${R}TERMINATING LEVIATHAN CORE...${NC}"; echo
    for m in "SEVERING NEURAL LINKS" \
             "PURGING VOLATILE MEMORY" \
             "ERASING SESSION TRACES" \
             "RETURNING TO THE VOID"; do
        echo -e "  ${S}▸${NC} ${D}${m}${NC}"; sleep 0.12
    done
    echo
    echo -e "  ${R}ᛞ  LEVIATHAN SLEEPS  ᛞ${NC}"
    local now; now=$(date +%s)
    local sd=$(( now - T0 ))
    printf "  ${D}SESSION %s  DURATION %02dh%02dm${NC}\n" \
        "$SID" $(( sd/3600 )) $(( (sd%3600)/60 ))
    echo
    runic_rain 1
    echo -ne "$SHOW"
    log "SESSION END $SID"
    exit 0
}

# ════════════════════════════════════════════════════════════════
#  MAIN LOOP
# ════════════════════════════════════════════════════════════════

trap 'echo -ne "$SHOW"; exit' INT TERM

[[ "${BOOT_FX:-1}" == "1" && "$1" != "noboot" ]] && boot_sequence

while true; do
    draw_hud

    echo -e "  ${bW}◈ CONTROL GRID${NC}"
    rule "─" "$S"
    echo -e "  ${R}[1]${NC} RECON        ${R}[2]${NC} ASSAULT"
    echo -e "  ${G}[3]${NC} DEFENSE      ${G}[4]${NC} PSY-OPS"
    echo -e "  ${C}[5]${NC} DEV-TOOLS    ${Y}[6]${NC} SYSTEM"
    rule "─" "$S"
    echo -e "  ${C}[0]${NC} TOR SWITCH   ${Y}[t]${NC} SET TARGET"
    echo -e "  ${Y}[f]${NC} THE FORGE    ${H}[s]${NC} SETTINGS"
    echo -e "  ${R}[x]${NC} DISCONNECT   ${D}[?]${NC} HELP"
    rule "─" "$S"
    echo
    echo -ne "  ${R}root@RDxOS${NC}${S}:${NC}${G}~${NC}${S}#${NC} "
    read -r opt
    log "CMD: $opt"

    case "$opt" in
        1)  browse_sector "1_RECON"   "RECON" ;;
        2)  browse_sector "2_ASSAULT" "ASSAULT" ;;
        3)  browse_sector "3_DEFENSE" "DEFENSE" ;;
        4)  browse_sector "4_PSY-OPS" "PSY-OPS" ;;
        5)  dev_toolbox ;;
        6)  browse_sector "99_SYSTEM" "SYSTEM" ;;
        0)  toggle_tor ;;
        t)  echo; echo -ne "  ${Y}TARGET:${NC} "; read -r TARGET
            echo -e "  ${R}◉ TARGET: ${W}${TARGET}${NC}"; sleep 0.8 ;;
        f)  forge_tool ;;
        s)  settings_menu ;;
        x)  shutdown_seq ;;
        "?"|h)
            echo
            echo -e "  ${C}HELP${NC}"
            rule "─" "$S"
            echo -e "  ${D}Modules${NC}  ${W}${MOD_DIR}${NC}"
            echo -e "  ${D}HUD     ${NC}  ${W}${MOD_DIR}/99_SYSTEM/HUD/*.sh${NC}"
            echo -e "  ${D}Logs    ${NC}  ${W}${LOGF}${NC}"
            echo -e "  ${D}Config  ${NC}  ${W}${CONF}${NC}"
            pause ;;
        "") ;;
        *)  echo -e "  ${R}◈ UNKNOWN: ${W}${opt}${NC}"; sleep 0.4 ;;
    esac
done
