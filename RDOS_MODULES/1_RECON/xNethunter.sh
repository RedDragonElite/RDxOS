#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: NET HUNTER v1.0 [ORAPHIM EYE]                                    ║
# ║ TARGET: DEEP PACKET FORENSICS & OSINT                                    ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# --- [ COLORS & STYLING ] ---
R='\033[1;31m'   # Neon Red
DR='\033[0;31m'  # Blood Red
G='\033[1;30m'   # Stealth Grey
W='\033[1;37m'   # White
Y='\033[1;33m'   # Gold
P='\033[1;35m'   # Indigo
C='\033[0;36m'   # Cyan
N='\033[0m'      # Reset

# --- [ UTILS ] ---
line() { echo -e "${DR}════════════════════════════════════════════════════════════${N}"; }
half_line() { echo -e "${G}────────────────────────────────────────────────────────────${N}"; }

# Slow Type Effect
typewriter() {
    text="$1"
    delay="$2"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep $delay
    done
    echo ""
}

# Advanced Loading Bar
load_proc() {
    msg="$1"
    echo -ne "${R}[PROC]${N} $msg "
    for i in {1..20}; do
        echo -ne "${DR}█${N}"
        sleep 0.05
    done
    echo -e " ${Y}DONE${N}"
}

# --- [ MAIN INTERFACE ] ---
clear
echo -e "${R}"
echo "  █▄ █ █▀▀ ▀▀█▀▀   █ █ █ █ █▄ █ ▀▀█▀▀ █▀▀ █▀▀▄"
echo "  █ ▀█ █▀▀   █     █▀█ █ █ █ ▀█   █   █▀▀ █▄▄▀"
echo "  ▀  ▀ ▀▀▀   ▀     ▀ ▀ ▀▀▀ ▀  ▀   ▀   ▀▀▀ ▀  ▀▄"
echo -e "  ${P}:: DEEP NETWORK FORENSICS :: v1.0 ::${N}"
echo ""

# TARGET ACQUISITION
echo -e "${W}ENTER TARGET (IP/DOMAIN):${N}"
read -p ">> " TARGET

if [ -z "$TARGET" ]; then
    echo -e "${DR}[!] NO TARGET. ABORTING.${N}"
    exit 1
fi

# REPORT FILE
REPORT_FILE="$HOME/RDOS_MODULES/99_SYSTEM/HUNTER_REPORT_$(date +%s).txt"
touch "$REPORT_FILE"

# --- [ PHASE 1: INITIALIZATION ] ---
echo ""
echo -e "${G}:: INITIALIZING FORENSIC PROTOCOLS ::${N}"
head -c 100 /dev/urandom | hexdump -C | head -n 3 | while read line; do
    echo -e "${G}$line${N}"
    sleep 0.05
done

load_proc "RESOLVING HOST ADDRESS"
HOST_IP=$(dig +short $TARGET | head -n1)
if [ -z "$HOST_IP" ]; then HOST_IP="$TARGET"; fi

load_proc "ESTABLISHING ORAPHIM LINK"
echo -e "${Y}>>> TARGET LOCKED: ${HOST_IP}${N}"
echo ""

# --- [ PHASE 2: GEOLOCATION & ISP (OSINT) ] ---
line
echo -e "${P}[ PHASE 1 ] :: GEOLOCATION & IDENTITY${N}"
line

echo -ne "${W}FETCHING SATELLITE DATA...${N}"
# Fetch JSON from ip-api
GEO_RAW=$(curl -s "http://ip-api.com/json/$HOST_IP")
sleep 1
echo -e " ${Y}ACQUIRED.${N}"
echo ""

# Parse rudimentary JSON with grep/sed (dependency free)
COUNTRY=$(echo "$GEO_RAW" | grep -Po '"country":"\K[^"]*')
CITY=$(echo "$GEO_RAW" | grep -Po '"city":"\K[^"]*')
ISP=$(echo "$GEO_RAW" | grep -Po '"isp":"\K[^"]*')
ORG=$(echo "$GEO_RAW" | grep -Po '"org":"\K[^"]*')
LAT=$(echo "$GEO_RAW" | grep -Po '"lat":\K[^,]*')
LON=$(echo "$GEO_RAW" | grep -Po '"lon":\K[^,]*')
TZ=$(echo "$GEO_RAW" | grep -Po '"timezone":"\K[^"]*')

echo -e "${G}┌──────────────────────────────────────────────┐${N}"
echo -e "${G}│ ${R}TARGET PROFILE                               ${G}│${N}"
echo -e "${G}├──────────────────────────────────────────────┤${N}"
echo -e "${G}│ ${W}IP ADDR   :: ${Y}$HOST_IP${N}"
echo -e "${G}│ ${W}ISP/ORG   :: ${C}$ISP / $ORG${N}"
echo -e "${G}│ ${W}LOCATION  :: ${W}$CITY, $COUNTRY${N}"
echo -e "${G}│ ${W}COORDS    :: ${R}$LAT, $LON${N}"
echo -e "${G}│ ${W}TIMEZONE  :: ${G}$TZ${N}"
echo -e "${G}└──────────────────────────────────────────────┘${N}"

# Save to Report
echo "TARGET PROFILE" >> "$REPORT_FILE"
echo "IP: $HOST_IP" >> "$REPORT_FILE"
echo "ISP: $ISP" >> "$REPORT_FILE"
echo "LOC: $CITY, $COUNTRY" >> "$REPORT_FILE"
echo "--------------------------------" >> "$REPORT_FILE"

# --- [ PHASE 3: PORT AUTOPSY (NMAP) ] ---
echo ""
line
echo -e "${P}[ PHASE 2 ] :: PORT AUTOPSY (SERVICE DETECTION)${N}"
line

load_proc "SCANNIG OPEN VECTORS (FAST)"
echo -e "${G}Analyzing Service Headers...${N}"
# Fast scan with Service Version detection
# We filter output to look cool
nmap -Pn -F -sV --version-light "$HOST_IP" | grep -E "open|Filtered" | while read portline; do
    # Colorize output
    PORT=$(echo "$portline" | awk '{print $1}')
    STATE=$(echo "$portline" | awk '{print $2}')
    SERVICE=$(echo "$portline" | awk '{$1=""; $2=""; print $0}')
    
    if [[ "$STATE" == "open" ]]; then
        echo -e "  ${R}[OPEN]${N} ${Y}$PORT${N} ${G}::$SERVICE${N}"
        echo "PORT: $PORT ($SERVICE)" >> "$REPORT_FILE"
    else
        echo -e "  ${G}[FLTR] $PORT${N}"
    fi
    sleep 0.1
done
echo ""

# --- [ PHASE 4: DNS X-RAY ] ---
line
echo -e "${P}[ PHASE 3 ] :: DNS X-RAY (INFRASTRUCTURE)${N}"
line

load_proc "EXTRACTING DNS RECORDS"

echo -e "${W}MAIL SERVERS (MX):${N}"
dig +short MX "$TARGET" | while read mx; do
    echo -e "  ${C}--> $mx${N}"
    echo "MX: $mx" >> "$REPORT_FILE"
    sleep 0.1
done

echo -e "${W}NAME SERVERS (NS):${N}"
dig +short NS "$TARGET" | while read ns; do
    echo -e "  ${C}--> $ns${N}"
    echo "NS: $ns" >> "$REPORT_FILE"
    sleep 0.1
done

echo -e "${W}TEXT RECORDS (TXT/AUTH):${N}"
dig +short TXT "$TARGET" | head -n 5 | while read txt; do
    echo -e "  ${G}--> $txt${N}"
    echo "TXT: $txt" >> "$REPORT_FILE"
    sleep 0.1
done
echo ""

# --- [ PHASE 5: WHOIS CONTACT ] ---
line
echo -e "${P}[ PHASE 4 ] :: ADMIN CONTACTS${N}"
line
echo -ne "${W}EXTRACTING ABUSE CONTACTS...${N}"
sleep 1
EMAILS=$(whois "$HOST_IP" | grep -E -i "abuse|email|e-mail" | head -n 3 | awk '{print $2}')

if [ -z "$EMAILS" ]; then
    echo -e " ${G}HIDDEN / REDACTED${N}"
    echo "EMAIL: HIDDEN" >> "$REPORT_FILE"
else
    echo -e " ${R}FOUND${N}"
    for email in $EMAILS; do
        echo -e "  ${R}[!] $email${N}"
        echo "EMAIL: $email" >> "$REPORT_FILE"
    done
fi
echo ""

# --- [ DEBRIEF ] ---
half_line
echo -e "${Y}>>> FORENSIC SCAN COMPLETE.${N}"
echo -e "${W}EVIDENCE SAVED TO: ${G}$REPORT_FILE${N}"
half_line
echo ""
echo -e "${G}[ PRESS ENTER ]${N}"
read

