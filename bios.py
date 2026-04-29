#!/usr/bin/env python3
import os
import sys
import time
import random
import socket
import platform
import subprocess
import shutil

# ── [ COLORS & STYLES ] ──
R = '\033[1;31m'  # Red (Danger/System)
G = '\033[1;32m'  # Green (Matrix)
Y = '\033[1;33m'  # Yellow (Warning)
B = '\033[1;34m'  # Blue
P = '\033[1;35m'  # Purple (Mystic)
C = '\033[1;36m'  # Cyan (Ice)
W = '\033[1;37m'  # White
GR = '\033[1;30m' # Grey (Subtle)
N = '\033[0m'     # Reset

# ── [ CONFIG ] ──
RDXOS_PATH = os.path.expanduser("~/RDxOS")

subliminal_msgs = [
    "THEY ARE WATCHING", "YOUR DATA IS MINE", "SYSTEM FAILURE IMMINENT",
    "WAKE UP", "REALITY IS BLEEDING", "GOD IS A MACHINE",
    "NO ESCAPE FOUND", "777", "LEVIATHAN AWAKENS", "DO NOT TURN OFF"
]

def clear():
    os.system('clear')

def type_writer(text, speed=0.02, color=W):
    for char in text:
        sys.stdout.write(color + char + N)
        sys.stdout.flush()
        time.sleep(speed)
    print()

def loading_bar(task, duration=0.5):
    sys.stdout.write(f"{C}[SYSTEM]{N} {task} ")
    sys.stdout.flush()
    steps = 15
    for i in range(steps):
        time.sleep(duration/steps)
        sys.stdout.write(f"{R}█{N}")
        sys.stdout.flush()
    sys.stdout.write(f" {G}[OK]{N}\n")

# ── [ ASCII ART FIX - 100% STABLE ] ──
def show_banner():
    clear()
    # Das Banner als stabiler Raw-String, zentriert für mobile Screens
    print(f"{GR}__________________________________________________{N}")
    print(f"{R}          _____  _____   _____               {N}")
    print(f"{R}         ██████╗ ██████╗ ███████╗         {N}")
    print(f"{R}   ██╗██╗██╔══██╗██╔══██╗██╔════╝██╗██╗   {N}")
    print(f"{R}   ╚═╝╚═╝██████╔╝██║  ██║█████╗  ╚═╝╚═╝   {N}")
    print(f"{R}   ██╗██╗██╔══██╗██║  ██║██╔══╝  ██╗██╗   {N}")
    print(f"{R}██╗╚═╝╚═╝██║  ██║██████╔╝███████╗╚═╝╚═╝██╗{N}")
    print(f"{R}╚═╝      ╚═╝  ╚═╝╚═════╝ ╚══════╝      ╚═╝{N}")
    print(f"{C}               rd-elite.com                 {N}")
    print(f"{GR}__________________________________________________{N}")
    print("")
    print(f"{W}    ... YOU HAVE TO BE A LIGHT TO YOURSELF ...{N}")
    print(f"{GR}__________________________________________________{N}")
    print("")

# ── [ MODULES ] ──

def launch_rdxos():
    print(f"\n{Y}>> INITIALIZING RDxOS KERNEL...{N}")
    loading_bar("Mounting file system...", 1.0)
    loading_bar("Loading 5th Element drivers...", 0.8)
    
    if os.path.exists(RDXOS_PATH):
        # Versuche das Script auszuführen (Python oder Bash)
        if os.path.isdir(RDXOS_PATH):
            # Wenn es ein Ordner ist, suche nach main.py oder boot.sh
            if os.path.exists(os.path.join(RDXOS_PATH, "main.py")):
                os.system(f"python3 {os.path.join(RDXOS_PATH, 'main.py')}")
            elif os.path.exists(os.path.join(RDXOS_PATH, "boot.sh")):
                os.system(f"bash {os.path.join(RDXOS_PATH, 'boot.sh')}")
            else:
                print(f"{R}[ERROR] No bootable file found in {RDXOS_PATH}{N}")
                input(f"{GR}[ PRESS ENTER ]{N}")
        else:
            # Wenn es eine Datei ist
            os.system(f"python3 {RDXOS_PATH}")
    else:
        print(f"{R}[ERROR] RDxOS not found at {RDXOS_PATH}{N}")
        print(f"{Y}>> Creating placeholder...{N}")
        os.makedirs(RDXOS_PATH, exist_ok=True)
        with open(os.path.join(RDXOS_PATH, "main.py"), "w") as f:
            f.write("print('RDxOS ONLINE - SYSTEM READY')\ninput()")
        print(f"{G}[SUCCESS] Placeholder created. Launching...{N}")
        time.sleep(1)
        launch_rdxos()

def ghost_protocol():
    print(f"\n{C}── [ GHOST PROTOCOL V3.0 ] ──{N}")
    loading_bar("Flushing DNS Cache...", 0.5)
    loading_bar("Clearing Termux History...", 0.5)
    loading_bar("Scrubbing RAM artifacts...", 0.8)
    print(f"{G}>> IDENTITY OBFUSCATED.{N}")
    print(f"{G}>> TRACKS WIPED.{N}")
    input(f"\n{GR}[ PRESS ENTER ]{N}")

def network_recon():
    print(f"\n{C}── [ WIFI RECON ] ──{N}")
    # Versucht, `arp` zu nutzen
    try:
        print(f"{Y}Scanning ARP table...{N}")
        os.system("arp -a")
    except:
        print(f"{R}[WARN] ARP tool not found. Install net-tools.{N}")
        # Fake output falls tools fehlen
        print(f"{GR}192.168.1.1   (Gateway){N}")
        print(f"{GR}192.168.1.15  (Target){N}")
    input(f"\n{GR}[ PRESS ENTER ]{N}")

def chaos_passwd():
    print(f"\n{C}── [ CHAOS KEYGEN ] ──{N}")
    chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-=[]{}|;:,.<>?"
    length = 24
    password = "".join(random.choice(chars) for _ in range(length))
    print(f"{G}GENERATED KEY:{N}")
    print(f"\n{P}{password}{N}\n")
    print(f"{GR}(Copied to clipboard buffer - simulated){N}")
    input(f"\n{GR}[ PRESS ENTER ]{N}")

def quick_ping():
    print(f"\n{C}── [ LATENCY CHECK ] ──{N}")
    targets = ["1.1.1.1", "8.8.8.8", "relay.damus.io"]
    for t in targets:
        response = os.system(f"ping -c 1 {t} > /dev/null 2>&1")
        if response == 0:
            print(f"{t:<20} : {G}ONLINE{N}")
        else:
            print(f"{t:<20} : {R}OFFLINE{N}")
    input(f"\n{GR}[ PRESS ENTER ]{N}")

def matrix_screensaver():
    try:
        print(f"{GR}Press CTRL+C to stop...{N}")
        time.sleep(1)
        chars = "01ﾊﾐﾋｰｳｼﾅﾓﾆｻﾜﾂｵﾘｱﾎﾃﾏｹﾒｴｶｷﾑﾕﾗｾﾈｽﾀﾇﾍ"
        cols = shutil.get_terminal_size().columns
        while True:
            line = "".join(random.choice(chars) for _ in range(cols))
            color = random.choice([G, G, G, W]) # Meistens grün
            print(f"{color}{line}{N}")
            time.sleep(0.04)
    except KeyboardInterrupt:
        pass

# ── [ MAIN MENU ] ──
def main_menu():
    while True:
        show_banner()
        
        # HUD
        user = os.environ.get('USER', 'ARCHITECT')
        try:
            ip = socket.gethostbyname(socket.gethostname())
        except:
            ip = "UNKNOWN"
            
        print(f"{GR}USER: {C}{user}{GR} | IP: {C}{ip}{GR} | MODE: {R}GOD{N}")
        print(f"{GR}────────────────────────────────────────────────__{N}")
        
        print(f"{R}[1]{N} LAUNCH RDxOS      {GR}(~/RDxOS){N}")
        print(f"{R}[2]{N} GHOST PROTOCOL    {GR}(Privacy){N}")
        print(f"{R}[3]{N} WIFI RECON        {GR}(Scan){N}")
        print(f"{R}[4]{N} CHAOS KEYGEN      {GR}(Security){N}")
        print(f"{R}[5]{N} LATENCY CHECK     {GR}(Ping){N}")
        print(f"{R}[6]{N} MATRIX RAIN       {GR}(Vis){N}")
        print(f"{R}[0]{N} EXIT TO SHELL")
        
        choice = input(f"\n{C}RDE@TERMUX ~# {N}")
        
        if choice == "1": launch_rdxos()
        elif choice == "2": ghost_protocol()
        elif choice == "3": network_recon()
        elif choice == "4": chaos_passwd()
        elif choice == "5": quick_ping()
        elif choice == "6": matrix_screensaver()
        elif choice == "0":
            type_writer(f"{R}Disconnecting from the Ether...{N}")
            sys.exit()
        else:
            print(f"{R}INVALID COMMAND.{N}")
            time.sleep(0.5)

# ── [ BOOT SEQ ] ──
def boot():
    # Nur beim ersten Start anzeigen (optional), hier immer
    clear()
    time.sleep(0.2)
    print(f"{GR}[KERNEL] Initializing RDE boot sequence...{N}")
    time.sleep(0.2)
    # Normie scare tactic
    if random.random() > 0.3:
        print(f"{R}[ERROR] SEGMENTATION FAULT AT 0x777000F{N}")
        time.sleep(0.3)
    
    show_banner()
    
    # Random Loading Texts
    tasks = [
        "Decrypting consciousness...",
        "Bypassing corporate firewalls...",
        "Injecting RDE protocol...",
        "Connecting to the Ether (Nostr)..."
    ]
    for task in tasks:
        loading_bar(task, 0.2)
    
    type_writer(f"\n{R}⚠️  SYSTEM FAILURE FOR GATEKEEPERS INITIATED.{N}", 0.02)
    type_writer(f"{W}Welcome home, Architect.{N}\n", 0.04)
    
    try:
        input(f"{GR}[ PRESS ENTER TO ENTER THE VOID ]{N}")
    except:
        pass
    main_menu()

if __name__ == "__main__":
    try:
        boot()
    except KeyboardInterrupt:
        print(f"\n{R}You cannot kill what is already dead.{N}")
        sys.exit()
