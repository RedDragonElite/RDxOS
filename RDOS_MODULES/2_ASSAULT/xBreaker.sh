#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE BREAKER v1.0 [BRUTE FORCE]                                   ║
# ║ TARGET: SSH / FTP / MYSQL                                                ║
# ║ WARNING: USE ON AUTHORIZED TARGETS ONLY (OR DONT GET CAUGHT)             ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import socket
import threading
import time
import sys
import os

# COLORS
R = '\033[1;31m'
G = '\033[1;30m'
W = '\033[1;37m'
Y = '\033[1;33m'
N = '\033[0m'

def banner():
    os.system('clear')
    print(f"{R}  █▀▄ █▀▄ █▀▀ █▀█ █ █ █▀▀ █▀▄{N}")
    print(f"{R}  █▀▄ █▀▄ █▀▀ █▀█ █▀▄ █▀▀ █▀▄{N}")
    print(f"{R}  ▀▀  ▀ ▀ ▀▀▀ ▀ ▀ ▀ ▀ ▀▀▀ ▀ ▀{N}")
    print(f"{G}  :: PROTOCOL FORCE :: v1.0 ::{N}\n")

def attempt(target, port, user, password):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(3)
        s.connect((target, int(port)))
        # Simple Banner Grab / Protocol check logic would go here
        # This is a raw socket connector template
        # For SSH/FTP specifically, you'd use paramiko or ftplib libraries
        # But this Raw Connect checks if the service accepts connections rapidly
        
        print(f"{G}[*] TRYING: {user}:{password}{N}")
        s.close()
        return False # Simulation for template
    except:
        return False

def main():
    banner()
    target = input(f"{W}TARGET IP >> {N}")
    port = input(f"{W}PORT (22/21/3306) >> {N}")
    user = input(f"{W}USERNAME (root) >> {N}")
    wordlist = input(f"{W}WORDLIST PATH >> {N}")

    if not os.path.exists(wordlist):
        print(f"{R}[!] WORDLIST NOT FOUND.{N}")
        sys.exit()

    print(f"\n{Y}>>> STARTING ATTACK ON {target}:{port} <<<{N}")
    time.sleep(1)

    with open(wordlist, 'r') as f:
        for line in f:
            password = line.strip()
            # Here we would hook in the real auth check
            # Since this is a template for RDxOS, we simulate the "Hammering"
            # To make this functional for SSH, install 'paramiko' via pip
            
            print(f"{R}[ATTACK]{N} {user} :: {password}")
            time.sleep(0.1) # Artifical delay to look cool/prevent instant ban

    print(f"\n{Y}>>> WORDLIST EXHAUSTED.{N}")
    input(f"{G}[ PRESS ENTER ]{N}")

if __name__ == "__main__":
    main()

