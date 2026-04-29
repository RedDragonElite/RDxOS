#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: GHOST CRAWLER v1.0                                               ║
# ║ TARGET: HIDDEN DIRECTORIES / ADMIN PANELS                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

R='\033[1;31m'
G='\033[1;30m'
W='\033[1;37m'
Y='\033[1;33m'
N='\033[0m'

clear
echo -e "${R}>>> GHOST CRAWLER: WEB RECON <<<${N}"
echo -e "${W}TARGET URL (e.g. http://target.com):${N}"
read -p ">> " URL

# Remove trailing slash
URL=${URL%/}

echo -e "${G}LOADING WORDLIST...${N}"
# Common sensitive paths
PATHS=("admin" "login" "wp-admin" "dashboard" "config" ".env" "db" "backup" "phpmyadmin" "navicat" "shell" "upload")

echo -e "${Y}>>> STARTING SCAN ON: $URL${N}"
echo ""

for path in "${PATHS[@]}"; do
    FULL_URL="$URL/$path"
    # Silent curl request, check HTTP code
    CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$FULL_URL" --max-time 3)
    
    if [[ "$CODE" == "200" ]]; then
        echo -e "${R}[FOUND]${N} $FULL_URL ${W}(200 OK)${N}"
    elif [[ "$CODE" == "403" ]]; then
        echo -e "${Y}[FORBID]${N} $FULL_URL ${G}(403)${N}"
    elif [[ "$CODE" == "301" ]] || [[ "$CODE" == "302" ]]; then
        echo -e "${C}[REDIR]${N} $FULL_URL ${G}($CODE)${N}"
    else
        echo -e "${G}[....] $path ($CODE)${N}"
    fi
    sleep 0.1
done

echo ""
echo -e "${R}>>> CRAWL COMPLETE.${N}"
echo -e "${G}[ PRESS ENTER ]${N}"
read

