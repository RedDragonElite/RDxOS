#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: xWatchDog v2.1 (ROOT BEYOND LIMITS)                              ║
# ║ SECTOR: 1_RECON                                                          ║
# ║ AUTHOR: DAN [RYUJIN UPLINK]                                              ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import os
import sys
import time
import socket
import struct
import subprocess

# ── [ AUTO-DEPENDENCY CHECK ] ──
def check_deps():
    try:
        # Hier könnten Pakete wie 'psutil' stehen, falls wir sie brauchen
        import subprocess
    except ImportError:
        print("\033[1;31m[!] Missing Dependencies. Installing...\033[0m")
        os.system("pip install psutil requests") # Beispiel
        os.execv(sys.executable, ['python'] + sys.argv)

# ── [ COLORS ] ──
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'
C='\033[0;36m'; W='\033[1;37m'; GR='\033[1;30m'; N='\033[0m'

def hex2ip(hex_ip):
    try:
        addr = int(hex_ip, 16)
        return socket.inet_ntoa(struct.pack("<L", addr))
    except: return hex_ip

def hex2port(hex_port):
    return int(hex_port, 16)

def get_connection_state(st):
    states = {'01':f'{G}ESTABLISHED{N}', '0A':f'{C}LISTEN{N}     ', '02':f'{Y}SYN_SENT{N}'}
    return states.get(st, f"{GR}CLOSED{N}   ")

def get_proc_net_via_su(proto):
    """Der Kern-Hack: Nutzt 'su -c cat' um Kernel-Lock zu umgehen"""
    try:
        # Wir führen 'cat' als root aus, um den PermissionError zu killen
        cmd = f"su -c 'cat /proc/net/{proto}'"
        result = subprocess.check_output(cmd, shell=True).decode('utf-8')
        return result.splitlines()
    except Exception as e:
        # Fallback für Non-Root (wird wahrscheinlich auf Android 11+ leer sein)
        try:
            with open(f"/proc/net/{proto}", "r") as f:
                return f.readlines()
        except:
            return []

def main():
    check_deps()
    try:
        while True:
            os.system('clear')
            print(f"{R}   📡 xWatchDog v2.1 :: {Y}ROOT BYPASS ACTIVE{N}")
            print(f"{GR}   Reading kernel network stack via SU-Tunnel...{N}")
            print(f"{GR}──────────────────────────────────────────────────────────────{N}")
            print(f" {W}PROTO  USERID      LOCAL IP        REMOTE IP       STATE{N}")
            print(f"{GR}──────────────────────────────────────────────────────────────{N}")
            
            lines = get_proc_net_via_su("tcp") + get_proc_net_via_su("udp")
            
            count = 0
            for line in lines:
                if line.strip().startswith("sl") or not line.strip(): continue
                parts = line.strip().split()
                
                try:
                    local_ip, local_port = parts[1].split(':')
                    rem_ip, rem_port = parts[2].split(':')
                    state = parts[3]
                    uid = parts[7]
                    
                    l_ip = hex2ip(local_ip)
                    if l_ip.startswith("127."): continue # Filter Loopback
                    
                    r_display = f"{hex2ip(rem_ip)}:{hex2port(rem_port)}"
                    state_txt = get_connection_state(state)
                    
                    proto = "TCP" if "tcp" in line.lower() or count < len(get_proc_net_via_su("tcp")) else "UDP"
                    
                    print(f" {B}{proto.ljust(5)}{N} {W}{uid.ljust(10)}{N} {l_ip}:{hex2port(local_port)}  {R}→{N}  {C}{r_display.ljust(21)}{N} {state_txt}")
                    count += 1
                except: continue

            print(f"{GR}──────────────────────────────────────────────────────────────{N}")
            if count == 0:
                print(f" {R}⚠ NO DATA. DID YOU GRANT ROOT (SU) ACCESS?{N}")
            else:
                print(f" {C}TOTAL ACTIVE STREAMS: {count}{N}")
            
            time.sleep(2)
            
    except KeyboardInterrupt:
        print(f"\n{R}Watchdog severed.{N}")

if __name__ == "__main__":
    main()
