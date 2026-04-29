#!/data/data/com.termux/files/usr/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  SYSTEM INTELLIGENCE v2.1 — DEEP SCAN (FIXED)                               ║
# ║  AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽  |  rd-elite.com                               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

R='\033[1;31m'; DR='\033[0;31m'; G='\033[1;30m'; LG='\033[1;32m'
W='\033[1;37m'; Y='\033[1;33m';  C='\033[0;36m'; N='\033[0m'

div()  { echo -e "${G}──────────────────────────────────────────────────────${N}"; }
line() { echo -e "${DR}══════════════════════════════════════════════════════${N}"; }

print_row() {
    printf "  ${G}%-16s${N} ${W}%s${N}\n" "$1" "${2:-N/A}"
}

# Build progress bar — POSIX-safe, no local, no (( ))
make_bar() {
    local pct="${1:-0}"
    local filled=$(( pct / 5 ))
    [ "$filled" -gt 20 ] && filled=20
    local i=0
    BAR_STR=""
    while [ "$i" -lt 20 ]; do
        if [ "$i" -lt "$filled" ]; then
            BAR_STR="${BAR_STR}▓"
        else
            BAR_STR="${BAR_STR}░"
        fi
        i=$(( i + 1 ))
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# HEADER
# ══════════════════════════════════════════════════════════════════════════════
clear
echo -e "${R}"
echo "  ███████╗██╗   ██╗███████╗"
echo "  ██╔════╝╚██╗ ██╔╝██╔════╝"
echo "  ███████╗ ╚████╔╝ ███████╗"
echo "  ╚════██║  ╚██╔╝  ╚════██║"
echo "  ███████║   ██║   ███████║"
echo "  ╚══════╝   ╚═╝   ╚══════╝"
echo -e "${N}"
echo -e "${G}  SYSTEM INTELLIGENCE v2.1  |  DEEP SCAN${N}"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# DEVICE IDENTITY
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ DEVICE IDENTITY${N}"; div

_model=$(getprop ro.product.model 2>/dev/null);   [ -z "$_model" ]  && _model="N/A"
_brand=$(getprop ro.product.brand 2>/dev/null);   [ -z "$_brand" ]  && _brand="N/A"
_device=$(getprop ro.product.device 2>/dev/null); [ -z "$_device" ] && _device="N/A"
_android=$(getprop ro.build.version.release 2>/dev/null); [ -z "$_android" ] && _android="N/A"
_sdk=$(getprop ro.build.version.sdk 2>/dev/null); [ -z "$_sdk" ]    && _sdk="?"
_build=$(getprop ro.build.display.id 2>/dev/null | cut -c1-35);     [ -z "$_build" ]  && _build="N/A"

print_row "BRAND"   "$_brand"
print_row "MODEL"   "$_model"
print_row "DEVICE"  "$_device"
print_row "ANDROID" "$_android (API $_sdk)"
print_row "BUILD"   "$_build"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# CPU
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ CPU ARCHITECTURE${N}"; div

_arch=$(uname -m)
_cores=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || echo "?")

_chip=$(grep -m1 "Hardware" /proc/cpuinfo 2>/dev/null | cut -d: -f2 | xargs)
[ -z "$_chip" ] && _chip=$(grep -m1 "model name" /proc/cpuinfo 2>/dev/null | cut -d: -f2 | xargs)
[ -z "$_chip" ] && _chip=$(getprop ro.board.platform 2>/dev/null)
[ -z "$_chip" ] && _chip=$(getprop ro.hardware 2>/dev/null)
[ -z "$_chip" ] && _chip="N/A"

_freq_max="N/A"
_freq_cur="N/A"
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq ]; then
    _raw=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)
    [ -n "$_raw" ] && _freq_max="$(( _raw / 1000 )) MHz"
fi
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]; then
    _raw=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)
    [ -n "$_raw" ] && _freq_cur="$(( _raw / 1000 )) MHz"
fi
if [ "$_freq_max" = "N/A" ]; then
    _mhz=$(grep "cpu MHz" /proc/cpuinfo 2>/dev/null | head -1 | awk '{printf "%.0f", $4}')
    [ -n "$_mhz" ] && _freq_max="${_mhz} MHz (dynamic)"
fi

_gov="N/A"
[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ] && \
    _gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)

# CPU usage via /proc/stat diff (portable, no top)
_cpu_usage="N/A"
if [ -f /proc/stat ]; then
    _s1=$(grep "^cpu " /proc/stat)
    sleep 0.4
    _s2=$(grep "^cpu " /proc/stat)
    _idle1=$(echo "$_s1" | awk '{print $5}')
    _tot1=$(echo  "$_s1" | awk '{s=0;for(i=2;i<=NF;i++)s+=$i;print s}')
    _idle2=$(echo "$_s2" | awk '{print $5}')
    _tot2=$(echo  "$_s2" | awk '{s=0;for(i=2;i<=NF;i++)s+=$i;print s}')
    _dt=$(( _tot2  - _tot1  ))
    _di=$(( _idle2 - _idle1 ))
    [ "$_dt" -gt 0 ] && _cpu_usage="$(( (100 * (_dt - _di)) / _dt ))%"
fi

print_row "CHIP"     "$_chip"
print_row "ARCH"     "$_arch"
print_row "CORES"    "$_cores threads"
print_row "MAX FREQ" "$_freq_max"
print_row "CUR FREQ" "$_freq_cur"
print_row "GOVERNOR" "$_gov"
print_row "USAGE"    "$_cpu_usage"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# MEMORY
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ MEMORY MATRIX${N}"; div

if [ -f /proc/meminfo ]; then
    _mtotal=$(awk '/MemTotal/    {print $2}' /proc/meminfo); _mtotal=${_mtotal:-0}
    _mfree=$(awk  '/MemAvailable/{print $2}' /proc/meminfo); _mfree=${_mfree:-0}
    _mcache=$(awk '/^Cached:/    {print $2}' /proc/meminfo | head -1); _mcache=${_mcache:-0}
    _mbufs=$(awk  '/Buffers/     {print $2}' /proc/meminfo); _mbufs=${_mbufs:-0}
    _mswt=$(awk   '/SwapTotal/   {print $2}' /proc/meminfo); _mswt=${_mswt:-0}
    _mswf=$(awk   '/SwapFree/    {print $2}' /proc/meminfo); _mswf=${_mswf:-0}

    _mused=$(( _mtotal - _mfree ))
    _MT=$(( _mtotal / 1024 )); _MF=$(( _mfree  / 1024 )); _MU=$(( _mused  / 1024 ))
    _MC=$(( _mcache / 1024 )); _MB=$(( _mbufs  / 1024 ))
    _ST=$(( _mswt   / 1024 )); _SU=$(( (_mswt - _mswf) / 1024 ))

    _mpct=0
    [ "$_mtotal" -gt 0 ] && _mpct=$(( _mused * 100 / _mtotal ))

    make_bar "$_mpct"
    if   [ "$_mpct" -ge 85 ]; then BAR_C=$R
    elif [ "$_mpct" -ge 60 ]; then BAR_C=$Y
    else BAR_C=$LG; fi

    print_row "TOTAL"   "${_MT} MB"
    print_row "USED"    "${_MU} MB (${_mpct}%)"
    print_row "FREE"    "${_MF} MB"
    print_row "CACHE"   "${_MC} MB"
    print_row "BUFFERS" "${_MB} MB"
    echo ""
    echo -e "  ${G}USAGE   ${BAR_C}${BAR_STR}${N} ${W}${_mpct}%${N}"

    if [ "$_ST" -gt 0 ]; then
        echo ""
        print_row "SWAP TOTAL" "${_ST} MB"
        print_row "SWAP USED"  "${_SU} MB"
    fi
else
    print_row "STATUS" "UNREADABLE"
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# STORAGE
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ STORAGE SECTORS${N}"; div
printf "  ${G}%-22s %-8s %-8s %-8s %-5s${N}\n" "MOUNT" "SIZE" "USED" "FREE" "USE%"
div

_df_row() {
    [ -d "$2" ] && df -h "$2" 2>/dev/null | \
        awk -v lbl="$1" 'NR==2{printf "  %-22s %-8s %-8s %-8s %-5s\n",lbl,$2,$3,$4,$5}'
}
_df_row "INTERNAL (/data)"  /data
_df_row "SDCARD"            /storage/emulated/0
_df_row "TERMUX PREFIX"     "${PREFIX:-/data/data/com.termux/files/usr}"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# NETWORK
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ NETWORK STATE${N}"; div

print_row "HOSTNAME" "$(hostname 2>/dev/null || echo N/A)"

ip addr show 2>/dev/null | awk '/inet / && !/127\.0\.0\.1/{
    split($2,a,"/"); iface=$NF
    printf "  %-16s %s\n", iface, a[1]
}'

if pgrep -x "tor" >/dev/null 2>&1; then
    print_row "TOR" "ACTIVE — ghost mode"
else
    print_row "TOR" "INACTIVE"
fi

_ipcache="$HOME/.rdx_ip_cache"
if [ -f "$_ipcache" ]; then
    _pub=$(tr -d '\n' < "$_ipcache" 2>/dev/null)
    [ -n "$_pub" ] && [ "$_pub" != "..." ] && print_row "PUBLIC IP" "$_pub"
fi

if [ -f /proc/net/dev ]; then
    echo ""
    printf "  ${G}%-14s %-14s %-14s${N}\n" "IFACE" "RX (MB)" "TX (MB)"
    div
    awk 'NR>2{
        gsub(/:/,"",$1)
        if($1!="lo"&&$1!=""){
            printf "  %-14s %-14d %-14d\n",$1,int($2/1048576),int($10/1048576)
        }
    }' /proc/net/dev | head -6
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# KERNEL & SYSTEM
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ KERNEL & SYSTEM${N}"; div

_upraw=$(awk '{print int($1)}' /proc/uptime 2>/dev/null || echo 0)
_upd=$(( _upraw / 86400 ))
_uph=$(( (_upraw % 86400) / 3600 ))
_upm=$(( (_upraw % 3600)  / 60   ))

print_row "OS"        "$(uname -o 2>/dev/null || echo Android/Linux)"
print_row "KERNEL"    "$(uname -r)"
print_row "SHELL"     "$(basename "${SHELL:-bash}")"
print_row "UPTIME"    "${_upd}d ${_uph}h ${_upm}m"
print_row "LOAD AVG"  "$(awk '{print $1,$2,$3}' /proc/loadavg 2>/dev/null || echo N/A) (1m/5m/15m)"
print_row "PROCESSES" "$(ps -A 2>/dev/null | wc -l || echo N/A)"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# SECURITY
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ SECURITY STATE${N}"; div

_selinux=$(getenforce 2>/dev/null)
if [ -z "$_selinux" ] && [ -f /sys/fs/selinux/enforce ]; then
    _e=$(cat /sys/fs/selinux/enforce 2>/dev/null)
    [ "$_e" = "1" ] && _selinux="Enforcing" || _selinux="Permissive"
fi
[ -z "$_selinux" ] && _selinux="N/A"

_root="NO"; command -v su &>/dev/null && _root="AVAILABLE"
_enc=$(getprop ro.crypto.state 2>/dev/null);          [ -z "$_enc" ]  && _enc="N/A"
_etype=$(getprop ro.crypto.type 2>/dev/null);         [ -z "$_etype" ] && _etype="N/A"
_boot=$(getprop ro.boot.verifiedbootstate 2>/dev/null); [ -z "$_boot" ] && _boot="N/A"

print_row "SELINUX"    "$_selinux"
print_row "ROOT"       "$_root"
print_row "ENCRYPTION" "$_enc ($_etype)"
print_row "BOOT STATE" "$_boot"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# BATTERY
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ POWER SYSTEM${N}"; div

if command -v termux-battery-status &>/dev/null; then
    _braw=$(termux-battery-status 2>/dev/null)
    _bpct=$(echo    "$_braw" | grep -oP '"percentage":\s*\K\d+')
    _bstat=$(echo   "$_braw" | grep -oP '"status":\s*"\K[^"]+')
    _btemp=$(echo   "$_braw" | grep -oP '"temperature":\s*\K[\d.]+')
    _bhealth=$(echo "$_braw" | grep -oP '"health":\s*"\K[^"]+')
    _bplug=$(echo   "$_braw" | grep -oP '"plugged":\s*"\K[^"]+')

    print_row "CHARGE"  "${_bpct:+${_bpct}%}${_bpct:-N/A}"
    print_row "STATUS"  "${_bstat:-N/A}"
    print_row "TEMP"    "${_btemp:+${_btemp}°C}${_btemp:-N/A}"
    print_row "HEALTH"  "${_bhealth:-N/A}"
    print_row "PLUGGED" "${_bplug:-N/A}"

    if [ -n "$_bpct" ] && [ "$_bpct" -eq "$_bpct" ] 2>/dev/null; then
        make_bar "$_bpct"
        if   [ "$_bpct" -ge 60 ]; then _bc=$LG
        elif [ "$_bpct" -ge 30 ]; then _bc=$Y
        else _bc=$R; fi
        echo ""
        echo -e "  ${G}LEVEL   ${_bc}${BAR_STR}${N} ${W}${_bpct}%${N}"
    fi
else
    echo -e "  ${G}Install termux-api + Termux:API companion app${N}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# TOP PROCESSES
# ══════════════════════════════════════════════════════════════════════════════
line; echo -e "${R}  ◉ TOP PROCESSES${N}"; div
printf "  ${G}%-8s %-8s %s${N}\n" "PID" "MEM%" "COMMAND"
div
ps -A 2>/dev/null | awk 'NR>1 && $9!="ps" {print}' | \
    sort -t' ' -k3 -rn 2>/dev/null | head -8 | \
    awk '{printf "  %-8s %-8s %s\n", $1, $3, $9}' 2>/dev/null
echo ""

# ══════════════════════════════════════════════════════════════════════════════
# FOOTER
# ══════════════════════════════════════════════════════════════════════════════
line
echo -e "${LG}  ◉ DIAGNOSTIC COMPLETE — SYSTEM OPTIMAL${N}"
line
echo ""
echo -e "${G}  △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽  |  rd-elite.com${N}"
echo ""
echo -e "${G}  [r] Refresh  [x] Exit${N}"
echo ""
read -rp "  >> " _fin
case "$_fin" in
    r) exec "$0" ;;
    *) clear; exit 0 ;;
esac
