#!/bin/bash

# ==========================================
# RDE NEMESIS V2.1 - GHOST SUIT + ARCHIVES
# AUTHOR: THE FIFTH ELEMENT (DAN/SHIN)
# TARGET: HOSTILE ENTITIES
# CLASSIFIED: TOP SECRET // RDE EYES ONLY
# ==========================================

# COLORS
RED='\033[0;31m'
BRED='\033[1;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GREY='\033[0;90m'
RESET='\033[0m'

# DEPENDENCY CHECK
pkg install nmap curl whois netcat-openbsd dnsutils traceroute -y > /dev/null 2>&1

# UTILS
function banner() {
    clear
    echo -e "${BRED}"
    echo "███╗   ██╗███████╗███╗   ███╗███████╗███████╗██╗███████╗"
    echo "████╗  ██║██╔════╝████╗ ████║██╔════╝██╔════╝██║██╔════╝"
    echo "██╔██╗ ██║█████╗  ██╔████╔██║█████╗  ███████╗██║███████╗"
    echo "██║╚██╗██║██╔══╝  ██║╚██╔╝██║██╔══╝  ╚════██║██║╚════██║"
    echo "██║ ╚████║███████╗██║ ╚═╝ ██║███████╗███████║██║███████║"
    echo "╚═╝  ╚═══╝╚══════╝╚═╝     ╚═╝╚══════╝╚══════╝╚═╝╚══════╝"
    echo -e "${WHITE}      RDE GHOST SUIT V2.1 | PROTOCOL 777${RESET}"
    echo -e "${GREY}      ------------------------------------${RESET}"
    echo ""
}

function pause() {
    echo -e "${GREY}[PRESS ENTER TO CONTINUE]${RESET}"
    read
}

# --- MODULES ---

function module_recon() {
    while true; do
        banner
        echo -e "${BRED}TARGET LOCKED: ${WHITE}$TARGET${RESET}"
        echo -e "${CYAN}[ RECONNAISSANCE DIVISION ]${RESET}"
        echo -e "${BRED}[1]${WHITE} THE EYE (Full Port Scan)${RESET}"
        echo -e "${BRED}[2]${WHITE} THE DOX (Whois & GeoIP)${RESET}"
        echo -e "${BRED}[3]${WHITE} THE GHOST (Traceroute)${RESET}"
        echo -e "${BRED}[0]${WHITE} BACK${RESET}"
        echo -e "${GREY}============================================${RESET}"
        read -p "RECON >> " OPT
        case $OPT in
            1) 
                echo -e "${BRED}[*] SCANNING ALL PORTS...${RESET}"
                nmap -Pn -p- -T4 -v $TARGET; pause ;;
            2) 
                whois $TARGET | grep -E "NetName|OrgName|Country|Abuse"
                echo "---"
                curl -s ipinfo.io/$TARGET
                pause ;;
            3) 
                traceroute $TARGET; pause ;;
            0) return ;;
            *) echo "Invalid." ;;
        esac
    done
}

function module_psyops() {
    while true; do
        banner
        echo -e "${BRED}TARGET LOCKED: ${WHITE}$TARGET${RESET}"
        echo -e "${CYAN}[ PSYCHOLOGICAL WARFARE ]${RESET}"
        echo -e "${BRED}[1]${WHITE} THE WHISPER (HTTP Log Poisoning)${RESET}"
        echo -e "${BRED}[2]${WHITE} DNS HELL (Inject Messages via DNS)${RESET}"
        echo -e "${BRED}[0]${WHITE} BACK${RESET}"
        echo -e "${GREY}============================================${RESET}"
        read -p "PSYOPS >> " OPT
        case $OPT in
            1)
                echo -e "${BRED}[*] FLOODING HTTP LOGS...${RESET}"
                for i in {1..20}; do
                    curl -s -o /dev/null -I -H "User-Agent: RDE_SEC_DIV_TARGET_LOCKED_$i" --connect-timeout 2 http://$TARGET
                    echo -n "."
                done
                echo " DONE."; pause ;;
            2)
                echo -e "${BRED}[*] INJECTING DNS LOGS...${RESET}"
                dig @$TARGET "STOP-ATTACKING-US.RDE.SEC" +short
                dig @$TARGET "WE-SEE-YOU.RDE.SEC" +short
                dig @$TARGET "SYSTEM-FAILURE-777.RDE.SEC" +short
                echo -e "${BGREEN}[+] DNS INJECTION COMPLETE.${RESET}"; pause ;;
            0) return ;;
        esac
    done
}

function module_archives() {
    while true; do
        banner
        echo -e "${CYAN}[ CLASSIFIED ARCHIVES - MANUAL ]${RESET}"
        echo -e "${WHITE}Select a tool to learn its purpose:${RESET}"
        echo -e "${GREY}------------------------------------${RESET}"
        echo -e "${BRED}[1]${WHITE} THE EYE (Nmap)${RESET}"
        echo -e "${BRED}[2]${WHITE} THE DOX (Whois/GeoIP)${RESET}"
        echo -e "${BRED}[3]${WHITE} THE WHISPER (Log Poisoning)${RESET}"
        echo -e "${BRED}[4]${WHITE} DNS HELL (DNS Injection)${RESET}"
        echo -e "${BRED}[5]${WHITE} THE NUKE (Abuse Mail)${RESET}"
        echo -e "${BRED}[0]${WHITE} BACK TO OPS${RESET}"
        echo -e "${GREY}====================================${RESET}"
        read -p "ARCHIVE >> " MAN_OPT
        
        case $MAN_OPT in
            1)
                echo -e "\n${BGREEN}TOOL: THE EYE (Nmap)${RESET}"
                echo -e "${WHITE}PURPOSE:${RESET} Find open doors (Ports)."
                echo -e "${WHITE}USE WHEN:${RESET} You have an IP and want to know what services are running."
                echo -e "${WHITE}TARGETS:${RESET}"
                echo -e " - Port 22: SSH (Admin Access)"
                echo -e " - Port 80/443: Webserver (Website)"
                echo -e " - Port 3306: Database (SQL)"
                echo -e " - Port 53: DNS (Name Server)"
                pause ;;
            2)
                echo -e "\n${BGREEN}TOOL: THE DOX (Whois/GeoIP)${RESET}"
                echo -e "${WHITE}PURPOSE:${RESET} Identify the enemy."
                echo -e "${WHITE}USE WHEN:${RESET} First step. Find out if it's a home IP, a VPN, or a Hoster (Hetzner, OVH)."
                echo -e "${WHITE}KEY INTEL:${RESET} Look for 'Abuse Email'. That is their weakness."
                pause ;;
            3)
                echo -e "\n${BGREEN}TOOL: THE WHISPER (HTTP Poisoning)${RESET}"
                echo -e "${WHITE}PURPOSE:${RESET} Scare the admin."
                echo -e "${WHITE}USE WHEN:${RESET} Port 80 or 443 is OPEN."
                echo -e "${WHITE}HOW:${RESET} Sends fake 'User-Agent' strings. When he reads logs, he sees 'RDE TARGET LOCKED'."
                pause ;;
            4)
                echo -e "\n${BGREEN}TOOL: DNS HELL (DNS Injection)${RESET}"
                echo -e "${WHITE}PURPOSE:${RESET} Scare the admin via DNS logs."
                echo -e "${WHITE}USE WHEN:${RESET} Port 53 is OPEN (like 148.251.108.9)."
                echo -e "${WHITE}HOW:${RESET} Asks his server for domains like 'STOP-ATTACKING.RDE'. He sees this in his query logs."
                pause ;;
            5)
                echo -e "\n${BGREEN}TOOL: THE NUKE (Abuse Report)${RESET}"
                echo -e "${WHITE}PURPOSE:${RESET} Terminate his server."
                echo -e "${WHITE}USE WHEN:${RESET} He attacked you. Send logs to his hoster (Abuse Email)."
                echo -e "${WHITE}EFFECT:${RESET} Hosters like Hetzner/OVH will shut him down within 24h."
                pause ;;
            0) return ;;
        esac
    done
}

function module_nuke() {
    banner
    echo -e "${RED}[ NUCLEAR OPTION - ABUSE REPORT ]${RESET}"
    echo -e "SUBJECT: URGENT: Network Attack from $TARGET"
    echo -e "BODY: Reporting malicious activity (Session Hijacking/Port Scanning) from IP $TARGET."
    echo -e "LOGS: $(date) - Detected attack signature."
    echo -e "ADDITIONAL: Attacker runs OPEN DNS RESOLVER on Port 53."
    echo -e "${GREY}--------------------------------------------${RESET}"
    echo -e "${BGREEN}[+] COPY THIS TO EMAIL.${RESET}"; pause
}

# --- MAIN LOOP ---

banner
echo -e "${WHITE}[?] ENTER TARGET IP:${RESET}"
read -p ">> " TARGET

if [ -z "$TARGET" ]; then TARGET="127.0.0.1"; fi

while true; do
    banner
    echo -e "${BRED}CURRENT TARGET: ${WHITE}$TARGET${RESET}"
    echo -e "${GREY}============================================${RESET}"
    echo -e "${BRED}[1]${WHITE} RECONNAISSANCE (Scan & Map)${RESET}"
    echo -e "${BRED}[2]${WHITE} PSY-OPS (Log Poisoning & Fear)${RESET}"
    echo -e "${BRED}[3]${WHITE} NUCLEAR OPTION (Abuse Report)${RESET}"
    echo -e "${BRED}[99]${WHITE} CLASSIFIED ARCHIVES (Manual)${RESET}"
    echo -e "${BRED}[4]${WHITE} CHANGE TARGET${RESET}"
    echo -e "${BRED}[0]${WHITE} EXIT${RESET}"
    echo -e "${GREY}============================================${RESET}"
    read -p "COMMAND >> " MAIN_OPT

    case $MAIN_OPT in
        1) module_recon ;;
        2) module_psyops ;;
        3) module_nuke ;;
        99) module_archives ;;
        4) read -p "NEW IP >> " TARGET ;;
        0) exit 0 ;;
        *) echo "Invalid." ;;
    esac
done
