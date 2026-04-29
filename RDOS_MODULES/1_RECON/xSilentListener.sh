#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE SILENT LISTENER v1.0                                         ║
# ║ TARGET: BLUETOOTH LOW ENERGY (BLE) & DEVICE PRESENCE                     ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# --- [ COLORS ] ---
R='\033[1;31m'
DR='\033[0;31m'
G='\033[1;30m'
W='\033[1;37m'
Y='\033[1;33m'
P='\033[1;35m'
C='\033[0;36m'
N='\033[0m'

# --- [ INIT ] ---
clear
echo -e "${R}"
echo "   █▀▀ █ █   █▀▀ █▄ █ ▀▀█▀▀"
echo "   ▀▀█ █ █   █▀▀ █ ▀█   █"
echo "   ▀▀▀ ▀ ▀▀▀ ▀▀▀ ▀  ▀   ▀"
echo -e "   ${G}:: THE SILENT LISTENER ::${N}"
echo ""

# Dependency Check
if ! command -v termux-bluetooth-scan &> /dev/null; then
    echo -e "${R}[ERROR]${N} Termux:API not found."
    echo -e "${W}Install 'Termux:API' app from PlayStore and run:${N}"
    echo -e "${Y}pkg install termux-api${N}"
    echo ""
    echo -e "${G}[ PRESS ENTER ]${N}"
    read
    exit 1
fi

echo -e "${W}ACTIVATE RADAR? (Y/n)${N}"
read -p ">> " choice

if [[ "$choice" == "n" ]]; then exit; fi

echo ""
echo -e "${G}INITIALIZING BLUETOOTH INTERFACE...${N}"
# Turn on BT if off (requires permission, might need manual toggle)
echo -e "${P}>>> SCANNING FOR SIGNALS (10s duration)...${N}"
echo -e "${G}Stand still for better triangulation.${N}"
echo ""

# Scan for 10 seconds, pipe to temporary file
# termux-bluetooth-scan returns JSON
termux-bluetooth-scan > .bt_scan_results &
SCAN_PID=$!

# Loading Animation while scanning
for i in {1..10}; do
    echo -ne "${R}  [RADAR]${N} SCANNING SECTOR $i... \r"
    sleep 1
done
echo -e "\n${Y}>>> SCAN COMPLETE. PARSING DATA...${N}"
echo ""

# Parse JSON manually (grep/sed hack for portability)
# We look for "name" and "address"
line
echo -e "${W}DETECTED ENTITIES IN RANGE:${N}"
line

if [ ! -s .bt_scan_results ]; then
    echo -e "${G}(NO SIGNALS DETECTED - CHECK PERMISSIONS)${N}"
else
    # Simple extraction loop
    # Reads the file, looks for name/mac pairs
    grep -E '"name":| "address":| "rssi":' .bt_scan_results | while read -r lineA; do
        read -r lineB
        read -r lineC
        
        # Clean up lines
        NAME=$(echo $lineA | cut -d '"' -f 4)
        MAC=$(echo $lineB | cut -d '"' -f 4)
        RSSI=$(echo $lineC | tr -dc '0-9-')
        
        # If name is empty/null, mark as UNKNOWN
        if [[ "$NAME" == "null" ]] || [[ -z "$NAME" ]]; then 
            NAME="${G}<UNKNOWN DEVICE>${N}"
        else
            NAME="${W}${NAME}${N}" # Highlight known names
        fi
        
        # RSSI Color Logic (Distance)
        # Closer to 0 is stronger (-40 is close, -90 is far)
        if [ "$RSSI" -gt -60 ]; then
            DIST="${R}VERY CLOSE${N}"
        elif [ "$RSSI" -gt -80 ]; then
            DIST="${Y}NEAR${N}"
        else
            DIST="${G}FAR${N}"
        fi

        echo -e "  ${P}::${N} $NAME"
        echo -e "     MAC: ${G}$MAC${N} | SIG: ${C}$RSSI dBm${N} ($DIST)"
        echo -e "${G}     ----------------------------------------${N}"
    done
fi

rm .bt_scan_results 2>/dev/null

echo ""
echo -e "${R}>>> SURVEILLANCE LOGGED.${N}"
echo -e "${G}[ PRESS ENTER ]${N}"
read

