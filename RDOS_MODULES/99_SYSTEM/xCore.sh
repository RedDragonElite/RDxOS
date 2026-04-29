#!/data/data/com.termux/files/usr/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  xCORE v3.0 — ARSENAL MANAGEMENT INTERFACE                                   ║
# ║  AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽  |  rd-elite.com                               ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ══════════════════════════════════════════════════════════════════════════════
# [ PALETTE ]
# ══════════════════════════════════════════════════════════════════════════════
R='\033[1;31m'      # Neon Red
DR='\033[0;31m'     # Blood Red
G='\033[1;30m'      # Grey
LG='\033[1;32m'     # Bright Green
W='\033[1;37m'      # White
Y='\033[1;33m'      # Gold
P='\033[1;35m'      # Purple
C='\033[0;36m'      # Cyan
LC='\033[1;36m'     # Bright Cyan
N='\033[0m'         # Reset

MODULES_DIR="$HOME/RDOS_MODULES"
SECTORS=("1_RECON" "2_ASSAULT" "3_DEFENSE" "4_PSY-OPS" "99_SYSTEM")
SECTOR_NAMES=("RECON" "ASSAULT" "DEFENSE" "PSY-OPS" "SYSTEM")

# ══════════════════════════════════════════════════════════════════════════════
# [ UTILS ]
# ══════════════════════════════════════════════════════════════════════════════
line()  { echo -e "${DR}══════════════════════════════════════════════════════${N}"; }
div()   { echo -e "${G}──────────────────────────────────────────────────────${N}"; }
pause() { echo ""; echo -e "${G}  ▸ PRESS ENTER TO CONTINUE${N}"; read -r; }

count_weapons() {
    local dir=$1
    local count=0
    for f in "$MODULES_DIR/$dir"/*.sh "$MODULES_DIR/$dir"/*.py; do
        [ -f "$f" ] && ((count++))
    done
    echo $count
}

total_weapons() {
    local total=0
    for sector in "${SECTORS[@]}"; do
        total=$((total + $(count_weapons "$sector")))
    done
    echo $total
}

sector_color() {
    case $1 in
        0) echo "$R" ;;    # RECON — red
        1) echo "$DR" ;;   # ASSAULT — blood
        2) echo "$LG" ;;   # DEFENSE — green
        3) echo "$P" ;;    # PSY-OPS — purple
        4) echo "$Y" ;;    # SYSTEM — gold
        *) echo "$W" ;;
    esac
}

# ══════════════════════════════════════════════════════════════════════════════
# [ MAIN DASHBOARD ]
# ══════════════════════════════════════════════════════════════════════════════
draw_dashboard() {
    clear
    echo -e "${R}"
    echo "  ██╗  ██╗ ██████╗ ██████╗ ██████╗ "
    echo "  ╚██╗██╔╝██╔════╝██╔═══██╗██╔══██╗"
    echo "   ╚███╔╝ ██║     ██║   ██║██████╔╝"
    echo "   ██╔██╗ ██║     ██║   ██║██╔══██╗"
    echo "  ██╔╝ ██╗╚██████╗╚██████╔╝██║  ██║"
    echo "  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${N}"
    echo -e "${G}  ARSENAL MANAGEMENT INTERFACE  |  v3.0${N}"
    echo ""
    
    line
    echo -e "${W}  ◈ SECTOR OVERVIEW${N}"
    div
    
    local total=$(total_weapons)
    local i=0
    for sector in "${SECTORS[@]}"; do
        local cnt=$(count_weapons "$sector")
        local SC=$(sector_color $i)
        local bar=""
        for ((j=0; j<cnt && j<20; j++)); do bar+="▓"; done
        printf "  ${SC}%-12s${N} ${G}│${N} ${W}%2d${N} ${G}weapons${N} ${SC}%s${N}\n" "${SECTOR_NAMES[$i]}" "$cnt" "$bar"
        ((i++))
    done
    
    div
    echo -e "  ${G}TOTAL ARSENAL: ${W}${total} weapons${N}  ${G}│${N}  ${G}STORAGE: ${C}$(du -sh "$MODULES_DIR" 2>/dev/null | cut -f1)${N}"
    line
    echo ""
}

# ══════════════════════════════════════════════════════════════════════════════
# [ SECTOR SELECTOR ]
# ══════════════════════════════════════════════════════════════════════════════
select_sector() {
    draw_dashboard
    echo -e "${W}  SELECT SECTOR:${N}"
    echo ""
    
    local i=0
    for sname in "${SECTOR_NAMES[@]}"; do
        local SC=$(sector_color $i)
        local cnt=$(count_weapons "${SECTORS[$i]}")
        echo -e "  ${SC}[$((i+1))]${N} ${W}${sname}${N} ${G}(${cnt} weapons)${N}"
        ((i++))
    done
    
    echo ""
    echo -e "${G}  [x]${N} Exit xCore"
    echo ""
    read -rp "  >> " sec_choice
    
    case $sec_choice in
        1) SELECTED_SECTOR="${SECTORS[0]}"; SELECTED_NAME="${SECTOR_NAMES[0]}"; return 0 ;;
        2) SELECTED_SECTOR="${SECTORS[1]}"; SELECTED_NAME="${SECTOR_NAMES[1]}"; return 0 ;;
        3) SELECTED_SECTOR="${SECTORS[2]}"; SELECTED_NAME="${SECTOR_NAMES[2]}"; return 0 ;;
        4) SELECTED_SECTOR="${SECTORS[3]}"; SELECTED_NAME="${SECTOR_NAMES[3]}"; return 0 ;;
        5) SELECTED_SECTOR="${SECTORS[4]}"; SELECTED_NAME="${SECTOR_NAMES[4]}"; return 0 ;;
        x) return 1 ;;
        *) return 1 ;;
    esac
}

# ══════════════════════════════════════════════════════════════════════════════
# [ FILE BROWSER ]
# ══════════════════════════════════════════════════════════════════════════════
browse_sector_files() {
    local DIR="$MODULES_DIR/$SELECTED_SECTOR"
    
    while true; do
        clear
        echo -e "${R}  ◈ SECTOR: ${W}${SELECTED_NAME}${N}"
        echo -e "${G}  PATH: ${C}${DIR}${N}"
        div
        
        local i=1
        local files=()
        
        # Header
        printf "  ${G}%-4s %-8s %-8s %-6s %s${N}\n" "IDX" "TYPE" "PERMS" "SIZE" "NAME"
        div
        
        for f in "$DIR"/*.sh "$DIR"/*.py; do
            if [ -f "$f" ]; then
                local fsize ftype fperm_icon fline_count
                fsize=$(du -h "$f" | cut -f1)
                fline_count=$(wc -l < "$f" 2>/dev/null)
                
                if [[ "$f" == *.py ]]; then
                    ftype="${Y}[PY]${N}"
                else
                    ftype="${LG}[SH]${N}"
                fi
                
                if [ -x "$f" ]; then
                    fperm_icon="${LG}EXEC${N}"
                else
                    fperm_icon="${G}READ${N}"
                fi
                
                local fname
                fname=$(basename "$f")
                printf "  ${R}[%02d]${N} %b  %b  %-6s ${W}%s${N} ${G}(%d lines)${N}\n" \
                    "$i" "$ftype" "$fperm_icon" "$fsize" "$fname" "$fline_count"
                files+=("$f")
                ((i++))
            fi
        done
        
        if [ ${#files[@]} -eq 0 ]; then
            echo -e "${G}  (SECTOR IS EMPTY)${N}"
        fi
        
        div
        echo -e "${W}  [s]${N} Search  ${W}[n]${N} New weapon  ${G}[b]${N} Back"
        echo ""
        read -rp "  Select weapon # or command >> " fid
        
        case $fid in
            b) return ;;
            n) forge_in_sector "$DIR"; continue ;;
            s) search_sector "$DIR" "${files[@]}"; continue ;;
            *)
                if [[ "$fid" =~ ^[0-9]+$ ]] && [ "$fid" -ge 1 ] && [ "$fid" -le ${#files[@]} ]; then
                    SELECTED_FILE="${files[$((fid-1))]}"
                    manage_weapon
                fi
                ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# [ SEARCH ]
# ══════════════════════════════════════════════════════════════════════════════
search_sector() {
    local dir=$1
    echo ""
    echo -e "${Y}  Search term (filename or content):${N}"
    read -rp "  >> " query
    [ -z "$query" ] && return
    
    echo ""
    echo -e "${W}  Results for: ${R}${query}${N}"
    div
    
    # Search filenames
    local found=false
    for f in "$dir"/*.sh "$dir"/*.py; do
        [ -f "$f" ] || continue
        if basename "$f" | grep -qi "$query"; then
            echo -e "  ${LG}[NAME]${N} $(basename "$f")"
            found=true
        elif grep -qi "$query" "$f" 2>/dev/null; then
            local match
            match=$(grep -i "$query" "$f" | head -2)
            echo -e "  ${Y}[CONTENT]${N} $(basename "$f")"
            echo -e "  ${G}  → $match${N}"
            found=true
        fi
    done
    
    [ "$found" = false ] && echo -e "${DR}  Nothing found.${N}"
    
    echo ""
    read -rp "  [Enter] Back >> "
}

# ══════════════════════════════════════════════════════════════════════════════
# [ FORGE IN SECTOR ]
# ══════════════════════════════════════════════════════════════════════════════
forge_in_sector() {
    local DIR=$1
    clear
    echo -e "${R}  ◈ FORGE WEAPON${N}"
    div
    echo ""
    echo -e "${Y}  Type: [1] Bash (.sh)  [2] Python (.py)${N}"
    read -rp "  >> " type_sel
    
    echo ""
    read -rp "${Y}  Weapon name >> ${N}" wname
    [ -z "$wname" ] && return
    
    local ext=".sh"
    local shebang="#!/data/data/com.termux/files/usr/bin/bash"
    [[ "$type_sel" == "2" ]] && ext=".py" && shebang="#!/usr/bin/env python3"
    
    local wpath="$DIR/${wname}${ext}"
    
    if [[ "$ext" == ".sh" ]]; then
        cat > "$wpath" << TEMPLATE
${shebang}
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: ${wname^^}                                                       ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽                                              ║
# ╚══════════════════════════════════════════════════════════════════════════╝

R='\033[1;31m'; G='\033[1;30m'; W='\033[1;37m'; V='\033[1;32m'; N='\033[0m'

clear
echo -e "\${R}◈ ${wname^^}\${N}"
echo -e "\${G}══════════════════════════════════\${N}"
echo ""

# YOUR CODE HERE

echo ""
echo -e "\${G}[ PRESS ENTER ]\${N}"
read
TEMPLATE
    else
        cat > "$wpath" << PY_TEMPLATE
${shebang}
# ══════════════════════════════════════════════════════
#  MODULE: ${wname}
#  AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽
# ══════════════════════════════════════════════════════

# YOUR CODE HERE
PY_TEMPLATE
    fi
    
    chmod +x "$wpath"
    echo -e "${LG}  Weapon created: ${W}$(basename "$wpath")${N}"
    sleep 0.5
    nano "$wpath"
}

# ══════════════════════════════════════════════════════════════════════════════
# [ WEAPON MANAGEMENT ]
# ══════════════════════════════════════════════════════════════════════════════
manage_weapon() {
    local fname
    fname=$(basename "$SELECTED_FILE")
    local fsize flines fperms
    fsize=$(du -h "$SELECTED_FILE" | cut -f1)
    flines=$(wc -l < "$SELECTED_FILE")
    fperms=$(ls -la "$SELECTED_FILE" | awk '{print $1}')
    
    while true; do
        clear
        echo -e "${P}  ◈ WEAPON INTERFACE${N}"
        div
        echo -e "  ${W}NAME   ${N}${R}${fname}${N}"
        echo -e "  ${W}PATH   ${G}${SELECTED_FILE}${N}"
        echo -e "  ${W}SIZE   ${Y}${fsize}${N}  ${W}LINES${N} ${C}${flines}${N}  ${W}PERMS${N} ${G}${fperms}${N}"
        div
        echo ""
        echo -e "${R}[1]${N} ${W}EDIT CODE${N}       ${G}(nano)${N}"
        echo -e "${R}[2]${N} ${W}EXECUTE${N}         ${G}(run now)${N}"
        echo -e "${R}[3]${N} ${W}RENAME${N}          ${G}(mv)${N}"
        echo -e "${R}[4]${N} ${W}CLONE${N}           ${G}(duplicate)${N}"
        echo -e "${R}[5]${N} ${W}MOVE TO SECTOR${N}  ${G}(relocate)${N}"
        echo -e "${R}[6]${N} ${W}PERMISSIONS${N}     ${G}(toggle exec)${N}"
        echo -e "${R}[7]${N} ${W}VIEW RAW${N}        ${G}(cat)${N}"
        echo -e "${R}[8]${N} ${W}CHECKSUM${N}        ${G}(md5/sha256)${N}"
        echo -e "${DR}[9]${N} ${W}DELETE${N}          ${G}(rm)${N}"
        echo -e "${G}[b]${N} Back"
        echo ""
        read -rp "  >> " act
        
        case $act in
            1)
                nano "$SELECTED_FILE"
                flines=$(wc -l < "$SELECTED_FILE")
                fsize=$(du -h "$SELECTED_FILE" | cut -f1)
                ;;
            2)
                echo ""
                echo -e "${R}  ◈ EXECUTING: ${W}${fname}${N}"
                div
                echo ""
                if [[ "$SELECTED_FILE" == *.py ]]; then
                    python3 "$SELECTED_FILE"
                else
                    bash "$SELECTED_FILE"
                fi
                pause
                ;;
            3)
                echo ""
                read -rp "  New name (with extension) >> " newname
                if [ -n "$newname" ]; then
                    local newpath
                    newpath="$(dirname "$SELECTED_FILE")/$newname"
                    mv "$SELECTED_FILE" "$newpath"
                    SELECTED_FILE="$newpath"
                    fname="$newname"
                    echo -e "${LG}  Renamed.${N}"; sleep 1
                fi
                ;;
            4)
                local clone_name="${fname%.*}_copy.${fname##*.}"
                cp "$SELECTED_FILE" "$(dirname "$SELECTED_FILE")/$clone_name"
                echo -e "${LG}  Cloned: ${W}${clone_name}${N}"; sleep 1.5
                ;;
            5)
                echo ""
                echo -e "${Y}  Move to sector:${N}"
                local si=0
                for sn in "${SECTOR_NAMES[@]}"; do
                    echo -e "  ${R}[$((si+1))]${N} $sn"
                    ((si++))
                done
                read -rp "  >> " move_sec
                local target_sec="${SECTORS[$((move_sec-1))]}"
                if [ -n "$target_sec" ] && [ -d "$MODULES_DIR/$target_sec" ]; then
                    mv "$SELECTED_FILE" "$MODULES_DIR/$target_sec/"
                    SELECTED_FILE="$MODULES_DIR/$target_sec/$fname"
                    echo -e "${LG}  Moved to ${target_sec}.${N}"; sleep 1
                fi
                ;;
            6)
                if [ -x "$SELECTED_FILE" ]; then
                    chmod -x "$SELECTED_FILE"
                    echo -e "${G}  Execution disabled.${N}"
                    fperms=$(ls -la "$SELECTED_FILE" | awk '{print $1}')
                else
                    chmod +x "$SELECTED_FILE"
                    echo -e "${LG}  Execution enabled.${N}"
                    fperms=$(ls -la "$SELECTED_FILE" | awk '{print $1}')
                fi
                sleep 1
                ;;
            7)
                clear
                echo -e "${R}  ◈ RAW: ${W}${fname}${N}"
                div
                cat "$SELECTED_FILE"
                echo ""
                div
                read -rp "  [Enter] Back >> "
                ;;
            8)
                echo ""
                echo -e "${Y}  MD5:    ${C}$(md5sum "$SELECTED_FILE" | cut -d' ' -f1)${N}"
                echo -e "${Y}  SHA256: ${C}$(sha256sum "$SELECTED_FILE" | cut -d' ' -f1)${N}"
                pause
                ;;
            9)
                echo ""
                echo -e "${DR}  ⚠ CANNOT BE UNDONE${N}"
                read -rp "  Type 'DELETE' to confirm >> " confirm
                if [ "$confirm" == "DELETE" ]; then
                    rm "$SELECTED_FILE"
                    echo -e "${R}  Weapon vaporized.${N}"
                    sleep 1
                    return
                else
                    echo -e "${G}  Aborted.${N}"; sleep 1
                fi
                ;;
            b) return ;;
        esac
    done
}

# ══════════════════════════════════════════════════════════════════════════════
# [ GLOBAL SEARCH ]
# ══════════════════════════════════════════════════════════════════════════════
global_search() {
    clear
    echo -e "${R}  ◈ GLOBAL ARSENAL SEARCH${N}"
    div
    echo ""
    read -rp "  Query >> " query
    [ -z "$query" ] && return
    
    echo ""
    echo -e "${W}  Results for: ${R}${query}${N}"
    div
    
    local found=false
    for sector in "${SECTORS[@]}"; do
        for f in "$MODULES_DIR/$sector"/*.sh "$MODULES_DIR/$sector"/*.py; do
            [ -f "$f" ] || continue
            if basename "$f" | grep -qi "$query" || grep -qi "$query" "$f" 2>/dev/null; then
                echo -e "  ${Y}[${sector}]${N} ${W}$(basename "$f")${N}"
                found=true
            fi
        done
    done
    
    [ "$found" = false ] && echo -e "${DR}  Nothing found.${N}"
    echo ""; pause
}

# ══════════════════════════════════════════════════════════════════════════════
# [ MAIN LOOP ]
# ══════════════════════════════════════════════════════════════════════════════
while true; do
    draw_dashboard
    
    echo -e "${W}  [1-5]${N} Browse sector"
    echo -e "${W}  [s]${N}   Global search"
    echo -e "${W}  [r]${N}   Refresh overview"
    echo -e "${G}  [x]${N}   Exit"
    echo ""
    read -rp "  ${R}◈${N} >> " main_choice
    
    case $main_choice in
        1|2|3|4|5)
            SELECTED_SECTOR="${SECTORS[$((main_choice-1))]}"
            SELECTED_NAME="${SECTOR_NAMES[$((main_choice-1))]}"
            browse_sector_files
            ;;
        s) global_search ;;
        r) continue ;;
        x) clear; exit 0 ;;
        *)
            # Also support select_sector flow
            if select_sector; then
                browse_sector_files
            else
                exit 0
            fi
            ;;
    esac
done
