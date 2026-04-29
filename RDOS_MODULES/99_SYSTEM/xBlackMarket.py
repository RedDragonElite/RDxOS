#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE BLACK MARKET (ARMORY X-CHANGE)                               ║
# ║ SECTOR: 99_SYSTEM                                                        ║
# ║ TARGET: RD-ELITE WEAPON REPOSITORY                                       ║
# ║ AUTHOR: DAN [RYUJIN UPLINK]                                              ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import requests
import os
import sys
import json

# ── [ CONFIG ] ──
BASE_URL = "https://rd-elite.com/Files/RDxOS/Weapons"
MANIFEST_URL = f"{BASE_URL}/weapons.json"
LOCAL_MODULES = os.path.expanduser("~/RDOS_MODULES")

# RDxOS Design
R = '\033[1;31m'; V = '\033[1;32m'; Y = '\033[1;33m'; C = '\033[0;36m'
GR = '\033[1;30m'; W = '\033[1;37m'; P = '\033[1;35m'; N = '\033[0m'

def div(): print(f"{GR}──────────────────────────────────────────────────{N}")

def header():
    os.system('clear')
    print(f"{R}   ▄▄▄▄▀ ▄  █ ▄███▄      ▄▄▄▄▀ █ ▄▄  █▀▄▀█ ▄███▄   █▄▄▄▄ {N}")
    print(f"{R}▀▀▀ █   █   █ █▀   ▀  ▀▀▀ █    █   █ █ █ █ █▀   ▀  █  ▄▀ {N}")
    print(f"{R}    █   ██▀▀█ ██▄▄        █    █▀▀▀  █ ▄ █ ██▄▄    █▀▀▌  {N}")
    print(f"{R}   █    █   █ █▄   ▄▀    █     █     █   █ █▄   ▄▀ █  █  {N}")
    print(f"{R}  ▀      █ █  ▀███▀     ▀       █       █  ▀███▀     █   {N}")
    print(f"{R}          ▀                            ▀            ▀    {N}")
    print(f"            {W}◈ THE BLACK MARKET :: WEAPON BROWSER v1.0{N}")
    div()

def get_local_version(sector, filename):
    path = os.path.join(LOCAL_MODULES, sector, filename)
    if os.path.exists(path):
        # Wir nehmen an, dass die Version im Header steht oder wir tracken sie in einer versteckten rdx_meta.json
        return "INSTALLED" # Platzhalter für Deep Version Check
    return None

def download_weapon(weapon):
    target_path = os.path.join(LOCAL_MODULES, weapon['sector'], weapon['file'])
    print(f"{C}[*] Deploying {weapon['name']} to {weapon['sector']}...{N}")
    
    res = requests.get(f"{BASE_URL}/{weapon['file']}")
    if res.status_code == 200:
        with open(target_path, 'wb') as f:
            f.write(res.content)
        os.chmod(target_path, 0o755) # Make executable
        print(f"{V}✓ SUCCESS: Weapon locked and loaded.{N}")
    else:
        print(f"{R}✗ FAILED: Connection severed.{N}")

def delete_weapon(weapon):
    target_path = os.path.join(LOCAL_MODULES, weapon['sector'], weapon['file'])
    if os.path.exists(target_path):
        os.remove(target_path)
        print(f"{Y}⚠ Weapon dismantled and removed.{N}")
    else:
        print(f"{R}✗ Weapon not found locally.{N}")

def main():
    try:
        weapons = requests.get(MANIFEST_URL, timeout=5).json()
    except:
        print(f"{R}✗ UNABLE TO REACH THE BLACK MARKET. CHECK TOR/WAN.{N}")
        return

    page = 0
    per_page = 4

    while True:
        header()
        start = page * per_page
        end = start + per_page
        current_batch = weapons[start:end]

        for i, w in enumerate(current_batch):
            local_status = get_local_version(w['sector'], w['file'])
            status_tag = f"{V}[INSTALLED]{N}" if local_status else f"{GR}[AVAILABLE]{N}"
            
            print(f" {W}[{i+1}]{N} {P}{w['name'].ljust(15)}{N} v{w['version']} {status_tag}")
            print(f"     {C}Sector: {w['sector']}{N}")
            print(f"     {GR}{w['desc']}{N}")
            print("")

        div()
        print(f" {W}[n]{N} Next Page  {W}[p]{N} Prev Page  {W}[x]{N} Exit")
        print(f" Type number to {V}Install{N} or {R}Uninstall{N}")
        div()
        
        choice = input(f"{C}ACTION >> {N}").lower()

        if choice == 'n' and end < len(weapons): page += 1
        elif choice == 'p' and page > 0: page -= 1
        elif choice == 'x': break
        elif choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(current_batch):
                target_w = current_batch[idx]
                if get_local_version(target_w['sector'], target_w['file']):
                    print(f"{R}!!! UNINSTALL {target_w['name']}? (y/n) !!!{N}")
                    if input().lower() == 'y': delete_weapon(target_w)
                else:
                    download_weapon(target_w)
                input(f"\n{GR}[ PRESS ENTER ]{N}")

if __name__ == "__main__":
    main()
#!/usr/bin/env python3
# ══════════════════════════════════════════════════════════
#  MODULE: xBlackMarket  |  SECTOR: 99_SYSTEM
#  AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽
# ══════════════════════════════════════════════════════════

# YOUR CODE HERE

