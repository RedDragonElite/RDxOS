#!/data/data/com.termux/files/usr/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  RDxOS v1.1.1 — SOVEREIGN ECLIPSE                                            ║
# ║  ARCHITECT: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽  |  SYSTEM: ALIVE (777Hz)                      ║
# ║  rd-elite.com  |  BFS v6.66  |  RDxOS v1.1.1                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

export LANG="C.UTF-8"

# ══════════════════════════════════════════════════════════════════════════════
# [ PALETTE — RD-ELITE TERMINAL DESIGN SYSTEM ]
# ══════════════════════════════════════════════════════════════════════════════
RUBY='\033[1;31m'       # Bright Red     — primary accent
BLOOD='\033[0;31m'      # Dark Red       — borders, dim accent
VENOM='\033[1;32m'      # Bright Green   — success / matrix
MOLD='\033[0;32m'       # Dark Green     — secondary green
DARK='\033[1;30m'       # Grey           — decorative lines
GOLD='\033[1;33m'       # Gold           — warnings / highlights
CYAN='\033[0;36m'       # Cyan           — info / network
LCYAN='\033[1;36m'      # Bright Cyan    — bright info
PURPLE='\033[0;35m'     # Purple         — system / special
LPURPLE='\033[1;35m'    # Bright Purple  — highlighted special
WHITE='\033[1;37m'      # White          — primary text
DIM='\033[2m'           # Dimmed
BLINK='\033[5m'         # Blink
BOLD='\033[1m'
NC='\033[0m'            # Reset

# ══════════════════════════════════════════════════════════════════════════════
# [ SYSTEM CONFIG ]
# ══════════════════════════════════════════════════════════════════════════════
MOD_DIR="$HOME/RDOS_MODULES"
HUD_DIR="$HOME/RDOS_MODULES/99_SYSTEM/HUD"
CACHE="$HOME/.rdx_cache"
IP_CACHE="$HOME/.rdx_ip_cache"
HUD_STATE="$HOME/.rdx_hud_state"
AUTOSTART="$HOME/.rdx_autostart"
GLOBAL_TARGET="127.0.0.1"
RDOS_VERSION="1.1.1"
CODENAME="SOVEREIGN ECLIPSE"

# Create dirs
mkdir -p "$MOD_DIR/1_RECON" "$MOD_DIR/2_ASSAULT" "$MOD_DIR/3_DEFENSE"
mkdir -p "$MOD_DIR/4_PSY-OPS" "$MOD_DIR/99_SYSTEM" "$HUD_DIR"
touch "$HUD_STATE" 2>/dev/null

# Runes
RUNES=("ᚠ" "ᚢ" "ᚦ" "ᚨ" "ᚱ" "ᚲ" "ᚷ" "ᚹ" "ᚺ" "ᚾ" "ᛁ" "ᛃ" "ᛇ" "ᛈ" "ᛉ" "ᛋ" "ᛏ" "ᛒ" "ᛖ" "ᛗ" "ᛚ" "ᛜ" "ᛞ" "ᛟ")

# ══════════════════════════════════════════════════════════════════════════════
# [ UTILS ]
# ══════════════════════════════════════════════════════════════════════════════
line()    { echo -e "${BLOOD}══════════════════════════════════════════════════${NC}"; }
div()     { echo -e "${DARK}──────────────────────────────────────────────────${NC}"; }
thin()    { echo -e "${DARK}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${NC}"; }
pause()   { echo ""; echo -e "${DARK}  ▸ ${DIM}PRESS ENTER TO CONTINUE${NC}"; read -r; }
nl()      { echo ""; }
rune_random() { echo "${RUNES[$((RANDOM % 24))]}"; }

# ══════════════════════════════════════════════════════════════════════════════
# [ MATRIX BOOT SEQUENCE ]
# ══════════════════════════════════════════════════════════════════════════════
matrix_rain() {
    clear
    local rows cols
    rows=$(tput lines 2>/dev/null || echo 30)
    cols=$(tput cols 2>/dev/null || echo 80)
    
    for i in {1..20}; do
        local r=$((RANDOM % 24))
        local rune="${RUNES[$r]}"
        if [ $((RANDOM % 3)) -eq 0 ]; then C=$RUBY
        elif [ $((RANDOM % 3)) -eq 1 ]; then C=$VENOM
        else C=$BLOOD; fi
        
        echo -e "${C}${rune}  ${BLOOD}$(rune_random)    ${VENOM}$(rune_random)   ${DARK}$(rune_random)  ${RUBY}$(rune_random)${NC}"
        echo -e "  ${VENOM}$(rune_random) ${RUBY}$(rune_random)  ${DARK}$(rune_random)  ${BLOOD}$(rune_random) ${VENOM}$(rune_random)${NC}"
        usleep 50000
    done
    clear
}

# ══════════════════════════════════════════════════════════════════════════════
# [ HARDWARE SENSORS ]
# ══════════════════════════════════════════════════════════════════════════════
get_battery() {
    if command -v termux-battery-status &>/dev/null; then
        local BAT_RAW BAT_PCT BAT_STAT BAT_TEMP
        BAT_RAW=$(termux-battery-status 2>/dev/null)
        BAT_PCT=$(echo "$BAT_RAW" | grep -oP '"percentage": \K\d+')
        BAT_STAT=$(echo "$BAT_RAW" | grep -oP '"status": "\K[^"]+')
        BAT_TEMP=$(echo "$BAT_RAW" | grep -oP '"temperature": \K[\d.]+')
        
        [ -z "$BAT_PCT" ] && { echo -e "${DARK}N/A${NC}"; return; }
        
        local ICON=""
        [[ "$BAT_STAT" == "CHARGING" ]] && ICON="⚡"
        [[ "$BAT_STAT" == "FULL" ]] && ICON="✓"
        
        if [ "$BAT_PCT" -ge 60 ]; then
            echo -e "${VENOM}${ICON}${BAT_PCT}%${NC}${DARK}[${BAT_TEMP}°C]${NC}"
        elif [ "$BAT_PCT" -ge 30 ]; then
            echo -e "${GOLD}${ICON}${BAT_PCT}%${NC}${DARK}[${BAT_TEMP}°C]${NC}"
        else
            echo -e "${RUBY}${BLINK}${ICON}${BAT_PCT}%${NC}${DARK}[${BAT_TEMP}°C]${NC}"
        fi
    else
        echo -e "${DARK}N/A${NC}"
    fi
}

get_cpu_usage() {
    local cpu_idle cpu_use
    cpu_idle=$(top -bn1 2>/dev/null | grep "Cpu" | awk '{print $8}' | tr -d '%')
    if [ -n "$cpu_idle" ]; then
        cpu_use=$(echo "100 - $cpu_idle" | bc 2>/dev/null || echo "?")
        if (( $(echo "$cpu_use > 80" | bc -l 2>/dev/null || echo 0) )); then
            echo -e "${RUBY}${cpu_use}%${NC}"
        elif (( $(echo "$cpu_use > 50" | bc -l 2>/dev/null || echo 0) )); then
            echo -e "${GOLD}${cpu_use}%${NC}"
        else
            echo -e "${VENOM}${cpu_use}%${NC}"
        fi
    else
        echo -e "${DARK}N/A${NC}"
    fi
}

get_ram_info() {
    if [ -f /proc/meminfo ]; then
        local total free used pct
        total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
        free=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
        used=$(( (total - free) / 1024 ))
        total_mb=$((total / 1024))
        pct=$(( (total - free) * 100 / total ))
        
        if [ "$pct" -ge 85 ]; then
            echo -e "${RUBY}${used}/${total_mb}MB (${pct}%)${NC}"
        elif [ "$pct" -ge 60 ]; then
            echo -e "${GOLD}${used}/${total_mb}MB (${pct}%)${NC}"
        else
            echo -e "${VENOM}${used}/${total_mb}MB (${pct}%)${NC}"
        fi
    else
        echo -e "${DARK}N/A${NC}"
    fi
}

get_uptime() {
    local up
    up=$(uptime -p 2>/dev/null | sed 's/up //')
    [ -z "$up" ] && up=$(cat /proc/uptime 2>/dev/null | awk '{printf "%dh %dm", $1/3600, ($1%3600)/60}')
    echo -e "${CYAN}${up}${NC}"
}

get_storage() {
    local used avail
    used=$(df -h /data 2>/dev/null | awk 'NR==2 {print $3}')
    avail=$(df -h /data 2>/dev/null | awk 'NR==2 {print $4}')
    [ -z "$used" ] && { echo -e "${DARK}N/A${NC}"; return; }
    echo -e "${WHITE}${used}${DARK}/${NC}${VENOM}${avail}${NC}"
}

get_process_count() {
    local cnt
    cnt=$(ps aux 2>/dev/null | wc -l)
    echo -e "${CYAN}$((cnt - 1))${NC}"
}

get_net_state() {
    local iface rx_bytes tx_bytes
    iface=$(cat /proc/net/route 2>/dev/null | awk 'NR>1 && $2=="00000000" {print $1; exit}')
    if [ -n "$iface" ] && [ -f "/proc/net/dev" ]; then
        rx_bytes=$(grep "$iface" /proc/net/dev 2>/dev/null | awk '{print $2}')
        tx_bytes=$(grep "$iface" /proc/net/dev 2>/dev/null | awk '{print $10}')
        local rx_mb=$(( ${rx_bytes:-0} / 1048576 ))
        local tx_mb=$(( ${tx_bytes:-0} / 1048576 ))
        echo -e "${VENOM}↓${rx_mb}MB${NC} ${RUBY}↑${tx_mb}MB${NC}"
    else
        echo -e "${DARK}N/A${NC}"
    fi
}

get_kernel() {
    uname -r | cut -d'-' -f1-2
}

get_android_ver() {
    getprop ro.build.version.release 2>/dev/null || echo "N/A"
}

# ══════════════════════════════════════════════════════════════════════════════
# [ AUTO-DEPLOY ]
# ══════════════════════════════════════════════════════════════════════════════
check_system() {
    local PKGS=("tor" "proxychains-ng" "nmap" "curl" "whois" "netcat-openbsd" "nano" "termux-api" "python" "git" "wget" "zip")
    local MISSING=()
    
    for pkg in "${PKGS[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            [[ "$pkg" == "python" ]] && command -v python3 &>/dev/null && continue
            [[ "$pkg" == "proxychains-ng" ]] && command -v proxychains4 &>/dev/null && continue
            MISSING+=("$pkg")
        fi
    done
    
    if [ ${#MISSING[@]} -gt 0 ]; then
        echo -e "${RUBY}:: MISSING PACKAGES DETECTED — INITIATING REPAIR ::${NC}"
        echo -e "${DARK}   Need: ${MISSING[*]}${NC}"
        sleep 1
        pkg update -y >/dev/null 2>&1
        for pkg in "${MISSING[@]}"; do
            echo -ne "${DARK}   Installing $pkg...${NC}"
            pkg install "$pkg" -y >/dev/null 2>&1 && echo -e "${VENOM} OK${NC}" || echo -e "${RUBY} FAIL${NC}"
        done
        python3 -c "import requests" &>/dev/null || pip install requests beautifulsoup4 >/dev/null 2>&1
        sleep 1
    fi
}

# ══════════════════════════════════════════════════════════════════════════════
# [ IMMERSIVE BOOT ]
# ══════════════════════════════════════════════════════════════════════════════
boot_sequence() {
    check_system
    matrix_rain
    
    clear
    echo ""
    echo -e "${BLOOD}  ██████╗ ██████╗ ██╗  ██╗ ██████╗ ███████╗ ${NC}"
    echo -e "${RUBY}  ██╔══██╗██╔══██╗╚██╗██╔╝██╔═══██╗██╔════╝ ${NC}"
    echo -e "${RUBY}  ██████╔╝██║  ██║ ╚███╔╝ ██║   ██║███████╗ ${NC}"
    echo -e "${BLOOD}  ██╔══██╗██║  ██║ ██╔██╗ ██║   ██║╚════██║ ${NC}"
    echo -e "${DARK}  ██║  ██║██████╔╝██╔╝ ██╗╚██████╔╝███████║ ${NC}"
    echo -e "${DARK}  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝ ${NC}"
    echo ""
    echo -e "${DARK}  v${RDOS_VERSION} :: ${CODENAME}${NC}"
    echo -e "${DARK}  rd-elite.com  |  BFS v6.66  |  RDxOS v1.1.1${NC}"
    echo ""
    
    sleep 0.3
    echo -ne "${BLOOD}  [${NC}"
    for i in {1..30}; do
        echo -ne "${RUBY}█${NC}"
        usleep 40000
    done
    echo -e "${BLOOD}] ${VENOM}BOOT OK${NC}"
    echo ""
    
    echo -ne "${DARK}  FINGERPRINT SCAN ............ ${NC}"
    sleep 0.4
    echo -e "${VENOM}VERIFIED${NC}"
    
    echo -ne "${DARK}  PINEAL SYNC [777Hz] ......... ${NC}"
    sleep 0.3
    echo -e "${VENOM}CONNECTED${NC}"
    
    echo -ne "${DARK}  SHADOW PROTOCOL ............. ${NC}"
    sleep 0.3
    if pgrep -x "tor" >/dev/null; then echo -e "${VENOM}ACTIVE${NC}"; else echo -e "${RUBY}STANDBY${NC}"; fi
    
    # Run autostart scripts if any
    if [ -f "$AUTOSTART" ] && [ -s "$AUTOSTART" ]; then
        echo ""
        echo -e "${GOLD}  AUTOSTART PROTOCOLS DETECTED...${NC}"
        while IFS= read -r script; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                echo -ne "${DARK}  ↳ Running $(basename "$script")... ${NC}"
                bash "$script" >/dev/null 2>&1 &
                echo -e "${VENOM}OK${NC}"
            fi
        done < "$AUTOSTART"
    fi
    
    sleep 0.5
    clear
}

# ══════════════════════════════════════════════════════════════════════════════
# [ HUD PANEL SYSTEM ]
# ══════════════════════════════════════════════════════════════════════════════
load_hud_panels() {
    local panels=()
    for f in "$HUD_DIR"/*.sh; do
        [ -f "$f" ] && [ -x "$f" ] && panels+=("$f")
    done

    if [ ${#panels[@]} -gt 0 ]; then
        echo -e "${DARK}╔══════════════════════════════════════════════════╗${NC}"
        _brow "${PURPLE}◈ CUSTOM HUD PANELS${NC}"
        echo -e "${DARK}╠══════════════════════════════════════════════════╣${NC}"
        for panel in "${panels[@]}"; do
            while IFS= read -r pline; do
                _brow "$pline"
            done < <(bash "$panel" 2>/dev/null | head -3)
        done
        echo -e "${DARK}╚══════════════════════════════════════════════════╝${NC}"
        echo ""
    fi
}

manage_hud_panels() {
    while true; do
        clear
        echo -e "${RUBY}◈ HUD PANEL MANAGER${NC}"
        div
        echo -e "${DARK}HUD panels are scripts that inject live data into the main HUD.${NC}"
        echo -e "${DARK}Location: ${CYAN}$HUD_DIR${NC}"
        echo ""
        
        # List existing panels
        local i=1
        local panels=()
        for f in "$HUD_DIR"/*.sh; do
            if [ -f "$f" ]; then
                local status="${RUBY}OFF${NC}"
                [ -x "$f" ] && status="${VENOM}ON${NC}"
                echo -e "${GOLD}[$i]${NC} $(basename "$f") [$status]"
                panels+=("$f")
                ((i++))
            fi
        done
        
        [ ${#panels[@]} -eq 0 ] && echo -e "${DARK}   (no panels installed)${NC}"
        
        echo ""
        echo -e "${RUBY}[n]${NC} Create new HUD panel"
        echo -e "${RUBY}[t]${NC} Toggle panel on/off"
        echo -e "${RUBY}[e]${NC} Edit panel"
        echo -e "${RUBY}[d]${NC} Delete panel"
        echo -e "${DARK}[b]${NC} Back"
        echo ""
        read -rp ">> " hchoice
        
        case $hchoice in
            n)
                echo -e "${VENOM}Panel name (e.g. crypto_price.sh):${NC}"
                read -r pname
                [[ "$pname" != *.sh ]] && pname="${pname}.sh"
                cat > "$HUD_DIR/$pname" << 'PANEL_TEMPLATE'
#!/bin/bash
# Custom HUD Panel — Edit this script to display live data
# Output should be max 3 lines, kept short for the HUD
echo -e "\033[1;33m MY PANEL \033[0m | data goes here"
PANEL_TEMPLATE
                chmod +x "$HUD_DIR/$pname"
                nano "$HUD_DIR/$pname"
                ;;
            t)
                [ ${#panels[@]} -eq 0 ] && continue
                read -rp "Panel # to toggle: " tidx
                if [[ "$tidx" =~ ^[0-9]+$ ]] && [ "$tidx" -le ${#panels[@]} ]; then
                    local tf="${panels[$((tidx-1))]}"
                    if [ -x "$tf" ]; then chmod -x "$tf"; echo -e "${RUBY}Panel disabled.${NC}"
                    else chmod +x "$tf"; echo -e "${VENOM}Panel enabled.${NC}"; fi
                    sleep 1
                fi
                ;;
            e)
                [ ${#panels[@]} -eq 0 ] && continue
                read -rp "Panel # to edit: " eidx
                if [[ "$eidx" =~ ^[0-9]+$ ]] && [ "$eidx" -le ${#panels[@]} ]; then
                    nano "${panels[$((eidx-1))]}"
                fi
                ;;
            d)
                [ ${#panels[@]} -eq 0 ] && continue
                read -rp "Panel # to delete: " didx
                if [[ "$didx" =~ ^[0-9]+$ ]] && [ "$didx" -le ${#panels[@]} ]; then
                    rm "${panels[$((didx-1))]}"
                    echo -e "${RUBY}Deleted.${NC}"; sleep 1
                fi
                ;;
            b) return ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# [ AUTOSTART MANAGER ]
# ══════════════════════════════════════════════════════════════════════════════
manage_autostart() {
    while true; do
        clear
        echo -e "${RUBY}◈ AUTOSTART PROTOCOLS${NC}"
        div
        echo -e "${DARK}Scripts listed here run silently on boot.${NC}"
        echo ""
        
        local i=1
        local entries=()
        if [ -f "$AUTOSTART" ]; then
            while IFS= read -r line; do
                [ -z "$line" ] && continue
                local exists="${RUBY}MISSING${NC}"
                [ -f "$line" ] && exists="${VENOM}OK${NC}"
                echo -e "${GOLD}[$i]${NC} $(basename "$line") [${exists}]"
                echo -e "    ${DARK}$line${NC}"
                entries+=("$line")
                ((i++))
            done < "$AUTOSTART"
        fi
        
        [ ${#entries[@]} -eq 0 ] && echo -e "${DARK}   (no autostart entries)${NC}"
        echo ""
        echo -e "${RUBY}[a]${NC} Add script to autostart"
        echo -e "${RUBY}[r]${NC} Remove entry"
        echo -e "${DARK}[b]${NC} Back"
        echo ""
        read -rp ">> " achoice
        
        case $achoice in
            a)
                echo -e "${VENOM}Full path to script:${NC}"
                read -r apath
                if [ -f "$apath" ]; then
                    echo "$apath" >> "$AUTOSTART"
                    echo -e "${VENOM}Added.${NC}"; sleep 1
                else
                    echo -e "${RUBY}File not found.${NC}"; sleep 1
                fi
                ;;
            r)
                [ ${#entries[@]} -eq 0 ] && continue
                read -rp "Entry # to remove: " ridx
                if [[ "$ridx" =~ ^[0-9]+$ ]] && [ "$ridx" -le ${#entries[@]} ]; then
                    local to_remove="${entries[$((ridx-1))]}"
                    grep -v "^${to_remove}$" "$AUTOSTART" > "${AUTOSTART}.tmp" && mv "${AUTOSTART}.tmp" "$AUTOSTART"
                    echo -e "${RUBY}Removed.${NC}"; sleep 1
                fi
                ;;
            b) return ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# [ MAIN HUD — THE BEAST ]
# ══════════════════════════════════════════════════════════════════════════════

# Box rendering — pixel-perfect alignment regardless of ANSI codes
# Uses wc -m (character count, not byte count) after stripping escape sequences
_HUD_IW=50  # inner visible width between "║ " and " ║"

_vlen() {
    # Strip ANSI escapes, then count Unicode characters (not bytes)
    printf '%s' "$(echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g')" | wc -m
}

_brow() {
    local content="$1"
    local clen=$(_vlen "$content")
    local pad=$(( _HUD_IW - clen ))
    [ "$pad" -lt 0 ] && pad=0
    printf "${BLOOD}║${NC} %b%*s${BLOOD} ║${NC}\n" "$content" "$pad" ""
}

_bdiv() { echo -e "${BLOOD}╠══════════════════════════════════════════════════╣${NC}"; }
_btop() { echo -e "${BLOOD}╔══════════════════════════════════════════════════╗${NC}"; }
_bbot() { echo -e "${BLOOD}╚══════════════════════════════════════════════════╝${NC}"; }

draw_hud() {
    clear

    # ── Network & Security State
    if pgrep -x "tor" >/dev/null; then
        SEC_TXT="${VENOM}◈ GHOST MODE${NC}"
        IP_PUB="${VENOM}◉ ONION ROUTED${NC}"
        ACCESS_LVL="${VENOM}GOD [Lvl 9]${NC}"
    else
        SEC_TXT="${RUBY}⚠ EXPOSED${NC}"

        # Non-blocking IP fetch, refresh every 5 min
        local now cache_age=999
        now=$(date +%s)
        [ -f "$IP_CACHE" ] && cache_age=$(( now - $(stat -c %Y "$IP_CACHE" 2>/dev/null || echo 0) ))
        if [ "$cache_age" -gt 300 ]; then
            printf '...' > "$IP_CACHE"
            ( curl -s --max-time 3 ifconfig.me > "$IP_CACHE" 2>/dev/null & )
        fi
        RAW_IP=$(tr -d '\n' < "$IP_CACHE" 2>/dev/null)
        IP_PUB="${RUBY}${RAW_IP:-RESOLVING...}${NC}"
        ACCESS_LVL="${GOLD}USER [Lvl 3]${NC}"
    fi

    # ── LAN IP
    IP_LAN=$(ip addr show 2>/dev/null \
        | awk '/inet / && !/127\.0\.0\.1/{print $2}' \
        | cut -d'/' -f1 | head -1)
    [ -z "$IP_LAN" ] && IP_LAN="OFFLINE"

    # ── Network I/O (RX/TX from /proc/net/dev)
    local iface rx_b tx_b rx_mb tx_mb
    iface=$(awk 'NR>1 && $2=="00000000"{print $1;exit}' /proc/net/route 2>/dev/null)
    if [ -n "$iface" ]; then
        rx_b=$(awk -v i="$iface:" '$1==i{print $2}' /proc/net/dev 2>/dev/null)
        tx_b=$(awk -v i="$iface:" '$1==i{print $10}' /proc/net/dev 2>/dev/null)
        rx_mb=$(( ${rx_b:-0} / 1048576 ))
        tx_mb=$(( ${tx_b:-0} / 1048576 ))
        NET_IO="${VENOM}↓${rx_mb}MB${NC} ${RUBY}↑${tx_mb}MB${NC}"
    else
        NET_IO="${DARK}N/A${NC}"
    fi

    # ── Hardware
    CORES=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo)
    ARCH=$(uname -m)
    RAM_INFO=$(get_ram_info)
    STORAGE=$(get_storage)
    BATTERY=$(get_battery)

    # ── System
    KVER=$(get_kernel)
    ANDVER=$(get_android_ver)
    UPTIME_STR=$(uptime -p 2>/dev/null | sed 's/up //' \
        || awk '{printf "%dd %dh %dm", $1/86400, ($1%86400)/3600, ($1%3600)/60}' /proc/uptime)
    PROCS=$(get_process_count)

    # ══ RENDER HUD ══
    _btop
    _brow "${BLOOD}◈ RD-ELITE${NC} ${DARK}::${NC} ${WHITE}RDxOS v${RDOS_VERSION}${NC} ${DARK}:: ${CODENAME}${NC}"
    _bdiv
    _brow "${DARK}USER  ${NC}${RUBY}△${NC} ${WHITE}ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ${NC} ${RUBY}▽${NC}"
    _brow "${DARK}RANK  ${NC}${ACCESS_LVL}"
    _bdiv
    _brow "${DARK}◉ NETWORK${NC}"
    _brow "  ${DARK}STATE ${NC}${SEC_TXT}"
    _brow "  ${DARK}WAN   ${NC}${IP_PUB}"
    _brow "  ${DARK}LAN   ${NC}${CYAN}${IP_LAN}${NC}"
    _brow "  ${DARK}I/O   ${NC}${NET_IO}"
    _bdiv
    _brow "${DARK}◉ HARDWARE${NC}"
    _brow "  ${DARK}CPU   ${NC}${WHITE}${ARCH} × ${CORES} cores${NC}"
    _brow "  ${DARK}RAM   ${NC}${RAM_INFO}"
    _brow "  ${DARK}DISK  ${NC}${STORAGE}"
    _brow "  ${DARK}PWR   ${NC}${BATTERY}"
    _bdiv
    _brow "${DARK}◉ SYSTEM${NC}"
    _brow "  ${DARK}KERNEL ${NC}${GOLD}${KVER}${NC}"
    _brow "  ${DARK}ANDROID ${NC}${WHITE}${ANDVER}${NC}  ${DARK}UP${NC} ${CYAN}${UPTIME_STR}${NC}"
    _brow "  ${DARK}PROCS ${NC}${CYAN}${PROCS}${NC}  ${DARK}TARGET ${NC}${RUBY}${GLOBAL_TARGET}${NC}"
    _bbot
    echo ""

    # Load active HUD panels
    load_hud_panels
}

# ══════════════════════════════════════════════════════════════════════════════
# [ MODULE ENGINE ]
# ══════════════════════════════════════════════════════════════════════════════
run_module() {
    local file=$1
    echo ""
    echo -e "${RUBY}◈ EXECUTING: ${WHITE}$(basename "$file")${NC}"
    div
    
    local WRAP=""
    if pgrep -x "tor" >/dev/null && command -v proxychains4 >/dev/null; then
        WRAP="proxychains4 -q"
        echo -e "${VENOM}  ↳ Routing via TOR...${NC}"
    fi
    
    echo ""
    if [[ "$file" == *".py" ]]; then
        python3 "$file"
    else
        $WRAP bash "$file"
    fi
    pause
}

browse_sector() {
    local sector=$1 sname=$2
    while true; do
        draw_hud
        echo -e "${WHITE}◈ SECTOR: ${RUBY}${sname}${NC}"
        div
        
        local i=1
        local scripts=()
        for f in "$MOD_DIR/$sector"/*.sh "$MOD_DIR/$sector"/*.py; do
            if [ -f "$f" ]; then
                local fsize ext icon
                fsize=$(du -h "$f" | cut -f1)
                ext="${f##*.}"
                [[ "$ext" == "py" ]] && icon="${GOLD}[PY]${NC}" || icon="${VENOM}[SH]${NC}"
                echo -e "  ${RUBY}[$i]${NC} ${icon} ${WHITE}$(basename "$f")${NC} ${DARK}(${fsize})${NC}"
                scripts+=("$f")
                ((i++))
            fi
        done
        
        if [ ${#scripts[@]} -eq 0 ]; then
            echo -e "${DARK}   ◉ VOID — No modules in this sector${NC}"
        fi
        
        div
        echo -e "${DARK}[f]${NC} Forge new weapon  ${DARK}[b]${NC} Return"
        echo ""
        read -rp "${RUBY}◈ SELECT${NC} >> " sel
        
        case $sel in
            b) return ;;
            f) forge_tool "$sector" ;;
            *)
                if [[ "$sel" =~ ^[0-9]+$ ]] && [ "$sel" -le ${#scripts[@]} ]; then
                    run_module "${scripts[$((sel-1))]}"
                fi
                ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# [ TOR CONTROL ]
# ══════════════════════════════════════════════════════════════════════════════
toggle_tor() {
    if pgrep -x "tor" >/dev/null; then
        echo ""
        echo -e "${RUBY}◈ SEVERING GHOST PROTOCOL...${NC}"
        pkill -x tor
        sleep 1
        echo -e "${RUBY}  ↳ TOR terminated. Identity exposed.${NC}"
    else
        echo ""
        echo -e "${VENOM}◈ INITIATING GHOST PROTOCOL...${NC}"
        (nohup tor >/dev/null 2>&1 &)
        echo -ne "${DARK}  Establishing circuits"
        for i in {1..5}; do echo -ne "."; sleep 0.8; done
        echo ""
        if pgrep -x "tor" >/dev/null; then
            echo -e "${VENOM}  ↳ TOR online. Identity concealed.${NC}"
        else
            echo -e "${RUBY}  ↳ TOR failed to start.${NC}"
        fi
    fi
    sleep 1.5
}

# ══════════════════════════════════════════════════════════════════════════════
# [ FORGE TOOL ]
# ══════════════════════════════════════════════════════════════════════════════
forge_tool() {
    local preset_sector="${1:-}"
    clear
    echo -e "${RUBY}◈ THE FORGE — WEAPON CREATION${NC}"
    div
    
    if [ -z "$preset_sector" ]; then
        echo -e "${GOLD}SELECT SECTOR:${NC}"
        echo -e "  ${RUBY}[1]${NC} RECON   ${RUBY}[2]${NC} ASSAULT   ${RUBY}[3]${NC} DEFENSE"
        echo -e "  ${RUBY}[4]${NC} PSY-OPS ${RUBY}[5]${NC} SYSTEM"
        echo ""
        read -rp ">> " c
        case $c in
            1) preset_sector="1_RECON" ;; 2) preset_sector="2_ASSAULT" ;;
            3) preset_sector="3_DEFENSE" ;; 4) preset_sector="4_PSY-OPS" ;;
            *) preset_sector="99_SYSTEM" ;;
        esac
    fi
    
    echo ""
    echo -e "${GOLD}WEAPON TYPE:${NC}"
    echo -e "  ${RUBY}[1]${NC} Bash Script (.sh)"
    echo -e "  ${RUBY}[2]${NC} Python Script (.py)"
    echo ""
    read -rp ">> " type_choice
    
    echo ""
    read -rp "${GOLD}NAME >> ${NC}" wname
    [ -z "$wname" ] && return
    
    local ext=".sh"
    local shebang="#!/data/data/com.termux/files/usr/bin/bash"
    [[ "$type_choice" == "2" ]] && ext=".py" && shebang="#!/usr/bin/env python3"
    
    local wpath="$MOD_DIR/$preset_sector/${wname}${ext}"
    
    # Template
    if [[ "$ext" == ".sh" ]]; then
        cat > "$wpath" << FORGE_TEMPLATE
${shebang}
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: ${wname^^}                                                       ║
# ║ SECTOR: ${preset_sector}                                                 ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽                                              ║
# ╚══════════════════════════════════════════════════════════════════════════╝

R='\033[1;31m'; G='\033[1;30m'; W='\033[1;37m'; V='\033[1;32m'; N='\033[0m'

clear
echo -e "\${R}◈ ${wname^^}\${N}"
echo -e "\${G}══════════════════════════════════════════\${N}"
echo ""

# YOUR CODE HERE

echo ""
echo -e "\${G}[ PRESS ENTER ]\${N}"
read
FORGE_TEMPLATE
    else
        cat > "$wpath" << FORGE_PY_TEMPLATE
${shebang}
# ══════════════════════════════════════════════════════════
#  MODULE: ${wname}  |  SECTOR: ${preset_sector}
#  AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽
# ══════════════════════════════════════════════════════════

# YOUR CODE HERE

FORGE_PY_TEMPLATE
    fi
    
    chmod +x "$wpath"
    echo -e "${VENOM}  ↳ Weapon forged: ${wpath}${NC}"
    sleep 0.5
    nano "$wpath"
}

# ══════════════════════════════════════════════════════════════════════════════
# [ TARGET SELECTOR ]
# ══════════════════════════════════════════════════════════════════════════════
set_target() {
    clear
    echo -e "${RUBY}◈ TARGET ACQUISITION${NC}"
    div
    echo -e "${DARK}Current target: ${RUBY}${GLOBAL_TARGET}${NC}"
    echo ""
    echo -e "${GOLD}Enter new target (IP or domain):${NC}"
    read -rp ">> " new_target
    [ -n "$new_target" ] && GLOBAL_TARGET="$new_target"
    echo -e "${VENOM}  ↳ Target locked: ${RUBY}${GLOBAL_TARGET}${NC}"
    sleep 1
}

# ══════════════════════════════════════════════════════════════════════════════
# [ SYSTEM SETTINGS ]
# ══════════════════════════════════════════════════════════════════════════════
system_settings() {
    while true; do
        clear
        echo -e "${RUBY}◈ SYSTEM CONTROL${NC}"
        div
        echo ""
        echo -e "${RUBY}[1]${NC} HUD Panel Manager"
        echo -e "${RUBY}[2]${NC} Autostart Manager"
        echo -e "${RUBY}[3]${NC} Install/Update packages"
        echo -e "${RUBY}[4]${NC} Reload environment"
        echo -e "${RUBY}[5]${NC} Clear all caches"
        echo -e "${RUBY}[6]${NC} About / Version info"
        echo -e "${DARK}[b]${NC} Back"
        echo ""
        read -rp ">> " schoice
        
        case $schoice in
            1) manage_hud_panels ;;
            2) manage_autostart ;;
            3) 
                echo -e "${GOLD}Updating packages...${NC}"
                pkg update -y && pkg upgrade -y
                pause
                ;;
            4)
                source ~/.bashrc 2>/dev/null || source ~/.profile 2>/dev/null
                echo -e "${VENOM}Environment reloaded.${NC}"; sleep 1
                ;;
            5)
                rm -f "$CACHE" "$IP_CACHE" ~/.rdx_*_cache 2>/dev/null
                echo -e "${VENOM}Caches cleared.${NC}"; sleep 1
                ;;
            6)
                clear
                echo -e "${RUBY}◈ RDxOS v${RDOS_VERSION} — ${CODENAME}${NC}"
                div
                echo -e "${DARK}AUTHOR     ${NC}${WHITE}△ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽${NC}"
                echo -e "${DARK}SITE       ${NC}${CYAN}rd-elite.com${NC}"
                echo -e "${DARK}ENGINE     ${NC}${WHITE}RDWE v2.4.1  |  BFS v6.66${NC}"
                echo -e "${DARK}PLATFORM   ${NC}${WHITE}Termux  |  Android${NC}"
                echo -e "${DARK}KERNEL     ${NC}${GOLD}$(uname -r)${NC}"
                echo -e "${DARK}BUILT ON   ${NC}${WHITE}PHP 8.1+  |  IIS  |  MariaDB${NC}"
                pause
                ;;
            b) return ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# [ MAIN LOOP ]
# ══════════════════════════════════════════════════════════════════════════════
[[ "$1" != "noboot" ]] && boot_sequence

while true; do
    draw_hud
    
    _btop
    _brow "${WHITE}◈ CONTROL GRID${NC}"
    _bdiv
    _brow "${RUBY}[1]${NC} RECON              ${DARK}│${NC} ${RUBY}[2]${NC} ASSAULT"
    _brow "${VENOM}[3]${NC} DEFENSE             ${DARK}│${NC} ${VENOM}[4]${NC} PSY-OPS"
    _brow "${GOLD}[5]${NC} SYSTEM TOOLS       ${DARK}│${NC} ${PURPLE}[6]${NC} CONTROL PANEL"
    _bdiv
    _brow "${CYAN}[0]${NC} TOR  ${DARK}│${NC} ${WHITE}[t]${NC} TARGET  ${DARK}│${NC} ${WHITE}[f]${NC} FORGE  ${DARK}│${NC} ${WHITE}[x]${NC} EXIT"
    _bbot
    echo ""
    
    echo -ne "${RUBY}root@RDxOS${NC}${DARK}:${NC}${VENOM}~${NC}${DARK}$${NC} "
    read -r opt
    
    case $opt in
        1) browse_sector "1_RECON" "RECON" ;;
        2) browse_sector "2_ASSAULT" "ASSAULT" ;;
        3) browse_sector "3_DEFENSE" "DEFENSE" ;;
        4) browse_sector "4_PSY-OPS" "PSY-OPS" ;;
        5) browse_sector "99_SYSTEM" "SYSTEM TOOLS" ;;
        6) system_settings ;;
        0) toggle_tor ;;
        t) set_target ;;
        f) forge_tool ;;
        x)
            clear
            matrix_rain
            echo -e "${RUBY}  SEVERING ALL CONNECTIONS...${NC}"
            sleep 0.5
            echo -e "${DARK}  777${NC}"
            sleep 0.5
            exit 0
            ;;
    esac
done
