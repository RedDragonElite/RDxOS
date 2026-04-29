#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE BLACK BOX v1.1 [SYSTEM BACKUP]                               ║
# ║ TARGET: EXPORT TO ANDROID STORAGE (LOCAL ONLY)                           ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# --- [ COLORS ] ---
RUBY='\033[1;31m'
VENOM='\033[1;32m'
GOLD='\033[1;33m'
CYAN='\033[0;36m'
DARK='\033[1;30m'
WHITE='\033[1;37m'
NC='\033[0m'

# --- [ CONFIG ] ---
SOURCE_DIR="$HOME/RDOS_MODULES"
CORE_SCRIPT="$HOME/RDxOS.sh"
EXPORT_DIR="/sdcard/Download"
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_NAME="RDxOS_BACKUP_${DATE}.zip"
TEMP_DIR="$HOME/.rdx_temp_backup"

# --- [ UTILS ] ---
progress_bar() {
    echo -ne "${DARK}[${NC}"
    for i in {1..20}; do
        echo -ne "${VENOM}▓${NC}"
        # FIX: sleep instead of usleep for compatibility
        sleep 0.05
    done
    echo -e "${DARK}] ${VENOM}OK${NC}"
}

banner() {
    clear
    echo -e "${RUBY}"
    echo "  █▀▄ █▀▄ █▀▀ █▄▀ █ █ █▀ "
    echo "  █▀▄ █▄▀ █▄▄ █ █ █▄█ █▀ "
    echo "  ▀▀  ▀ ▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀  "
    echo -e "${NC}"
    echo -e "${WHITE}:: SYSTEM BACKUP UTILITY v1.1 ::${NC}"
    echo -e "${DARK}────────────────────────────────────────${NC}"
}

# --- [ MAIN ] ---
# Disable Proxychains for this session to avoid spam
unset LD_PRELOAD

banner

# 1. Check Storage Permission
if [ ! -d "/sdcard/Download" ]; then
    echo -e "${RUBY}[CRITICAL]${NC} NO STORAGE ACCESS DETECTED."
    echo -e "${WHITE}Please run 'termux-setup-storage' and grant permission.${NC}"
    echo ""
    read -p "[PRESS ENTER TO EXIT]"
    exit 1
fi

# 2. Prepare Temp Directory
echo -ne "${WHITE}PREPARING FILE STRUCTURE   ${NC}"
mkdir -p "$TEMP_DIR/RDxOS"
if [ -f "$CORE_SCRIPT" ]; then cp "$CORE_SCRIPT" "$TEMP_DIR/RDxOS/"; fi
if [ -d "$SOURCE_DIR" ]; then cp -r "$SOURCE_DIR" "$TEMP_DIR/RDxOS/"; fi
progress_bar

# 3. Compress
echo -ne "${WHITE}COMPRESSING DATA (ZIP)     ${NC}"
# Check if zip is installed
if ! command -v zip &> /dev/null; then
    echo -e "\n${GOLD}Installing 'zip' package...${NC}"
    pkg install zip -y > /dev/null 2>&1
fi

cd "$TEMP_DIR"
# Zip quietly (-q) and recursively (-r)
zip -r -q "$BACKUP_NAME" "RDxOS"
progress_bar

# 4. Export
echo -ne "${WHITE}EXPORTING TO DOWNLOADS     ${NC}"
if [ -f "$TEMP_DIR/$BACKUP_NAME" ]; then
    mv "$TEMP_DIR/$BACKUP_NAME" "$EXPORT_DIR/$BACKUP_NAME"
    STATUS=0
else
    STATUS=1
fi

if [ $STATUS -eq 0 ]; then
    progress_bar
    echo -e "${DARK}────────────────────────────────────────${NC}"
    echo -e "${VENOM}>>> BACKUP SUCCESSFUL.${NC}"
    echo -e "${WHITE}LOCATION: ${CYAN}$EXPORT_DIR/$BACKUP_NAME${NC}"
    FILE_SIZE=$(du -h "$EXPORT_DIR/$BACKUP_NAME" | cut -f1)
    echo -e "${WHITE}SIZE:     ${GOLD}$FILE_SIZE${NC}"
else
    echo -e "${RUBY}[FAIL]${NC}"
    echo -e "${RUBY}Could not move file. Check permissions.${NC}"
fi

# 5. Cleanup
echo -ne "${WHITE}CLEANING TEMPORARY FILES   ${NC}"
rm -rf "$TEMP_DIR"
progress_bar

echo ""
echo -e "${DARK}[ PRESS ENTER TO RETURN ]${NC}"
read

