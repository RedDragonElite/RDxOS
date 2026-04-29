#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE OMEGA HAMMER v1.0 [RDWE STRESS ENGINE]                       ║
# ║ TARGET: API ENDPOINT LOAD TESTING (MULTI-THREADED)                       ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import os
import sys
import time
import threading
import requests
import random
import json
from queue import Queue

# --- [ COLORS & VISUALS ] ---
R = '\033[1;31m' # Critical
G = '\033[1;30m' # Stealth
W = '\033[1;37m' # Text
Y = '\033[1;33m' # Warning
P = '\033[1;35m' # Neon
C = '\033[0;36m' # Info
N = '\033[0m'    # Reset

# --- [ CONFIG ] ---
STATS = {
    "reqs": 0,
    "success": 0,
    "fails": 0,
    "errors": 0,
    "rps": 0,
    "avg_lat": 0.0
}
LOCK = threading.Lock()
RUNNING = True

# --- [ UTILS ] ---
def banner():
    os.system('clear')
    print(f"{R}")
    print(f"   █▀▀█ █▀▄▀█ █▀▀ █▀▀▀ █▀▀█   █  █ █▀▀█ █▀▄▀█ █▀▄▀█ █▀▀ █▀▀█")
    print(f"   █  █ █ ▀ █ █▀▀ █ ▀█ █▄▄█   █▄▄█ █▄▄█ █ ▀ █ █ ▀ █ █▀▀ █▄▄▀")
    print(f"   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀▀ ▀  ▀   ▄▄▄█ ▀  ▀ ▀   ▀ ▀   ▀ ▀▀▀ ▀ ▀▀")
    print(f"   {P}:: RDWE STRESS TESTING UNIT :: v1.0 ::{N}")
    print(f"")

def draw_hud(target, threads, method):
    global STATS
    while RUNNING:
        time.sleep(0.5)
        with LOCK:
            # Calculate RPS dynamically
            # (Simple approximation for HUD visual)
            
            # Color logic
            lat_col = C if STATS['avg_lat'] < 0.2 else (Y if STATS['avg_lat'] < 0.8 else R)
            
            os.system('clear')
            banner()
            print(f"{G}────────────────────────────────────────────────────────────{N}")
            print(f"  TARGET   :: {W}{target}{N}")
            print(f"  METHOD   :: {P}{method}{N} | THREADS :: {P}{threads}{N}")
            print(f"{G}────────────────────────────────────────────────────────────{N}")
            print(f"  SENT     :: {W}{STATS['reqs']}{N}")
            print(f"  SUCCESS  :: {C}{STATS['success']} (200 OK){N}")
            print(f"  FAIL     :: {Y}{STATS['fails']} (4xx/5xx){N}")
            print(f"  ERROR    :: {R}{STATS['errors']} (Connection){N}")
            print(f"{G}────────────────────────────────────────────────────────────{N}")
            
            # Progress Bars
            # Latency Bar
            lat_bar_len = int(STATS['avg_lat'] * 20)
            if lat_bar_len > 20: lat_bar_len = 20
            lat_vis = "█" * lat_bar_len + "░" * (20 - lat_bar_len)
            
            print(f"  LATENCY  :: [{lat_col}{lat_vis}{N}] {lat_col}{STATS['avg_lat']:.3f}s{N}")
            print(f"{G}────────────────────────────────────────────────────────────{N}")
            print(f"  {R}[CTRL+C] TO STOP ASSAULT{N}")

# --- [ WORKER DRONE ] ---
def worker(target, method, payload):
    global STATS
    
    headers = {
        'User-Agent': 'RDxOS-OmegaHammer/1.0',
        'Content-Type': 'application/json'
    }

    while RUNNING:
        start = time.time()
        try:
            if method == "GET":
                r = requests.get(target, headers=headers, timeout=5)
            elif method == "POST":
                r = requests.post(target, headers=headers, json=payload, timeout=5)
            elif method == "PUT":
                r = requests.put(target, headers=headers, json=payload, timeout=5)
            else:
                r = requests.get(target, headers=headers, timeout=5)

            end = time.time()
            lat = end - start

            with LOCK:
                STATS['reqs'] += 1
                # Moving average for latency
                if STATS['reqs'] == 1:
                    STATS['avg_lat'] = lat
                else:
                    STATS['avg_lat'] = (STATS['avg_lat'] * 0.95) + (lat * 0.05)
                
                if 200 <= r.status_code < 300:
                    STATS['success'] += 1
                else:
                    STATS['fails'] += 1

        except Exception as e:
            with LOCK:
                STATS['reqs'] += 1
                STATS['errors'] += 1
        
        # Slight delay to prevent local CPU choke (optional, set to 0 for max power)
        # time.sleep(0.01)

# --- [ MAIN ] ---
def main():
    global RUNNING
    banner()
    
    # --- SETUP ---
    print(f"{W}ENTER API ENDPOINT (e.g. http://localhost:3000/api/status):{N}")
    target = input(f"{R}>> {N}").strip()
    if not target.startswith("http"): target = "http://" + target

    print(f"\n{W}SELECT METHOD:{N}")
    print(f"{C}[1] GET  (Read/Load){N}")
    print(f"{C}[2] POST (Create/Inject){N}")
    print(f"{C}[3] PUT  (Update/Stress){N}")
    m_choice = input(f"{R}>> {N}")
    
    method = "GET"
    payload = {}
    
    if m_choice == "2" or m_choice == "3":
        method = "POST" if m_choice == "2" else "PUT"
        print(f"\n{W}ENTER JSON PAYLOAD (or press ENTER for empty):{N}")
        print(f"{G}Example: {{'user': 'test', 'data': 'stress'}}{N}")
        raw_pay = input(f"{R}>> {N}")
        if raw_pay:
            try:
                # Allow single quotes for lazy typing, convert to valid JSON
                raw_pay = raw_pay.replace("'", '"')
                payload = json.loads(raw_pay)
                print(f"{Y}Payload Loaded.{N}")
            except:
                print(f"{R}[!] INVALID JSON. SENDING EMPTY BODY.{N}")

    print(f"\n{W}THREAD COUNT (10-500):{N}")
    try:
        t_count = int(input(f"{R}>> {N}"))
    except:
        t_count = 10

    # --- LAUNCH ---
    print(f"\n{R}>>> ARMING {t_count} WARHEADS...{N}")
    time.sleep(1)
    
    # Start HUD
    hud_thread = threading.Thread(target=draw_hud, args=(target, t_count, method))
    hud_thread.daemon = True
    hud_thread.start()
    
    # Start Workers
    threads = []
    for _ in range(t_count):
        t = threading.Thread(target=worker, args=(target, method, payload))
        t.daemon = True
        t.start()
        threads.append(t)
        time.sleep(0.01) # Stagger start

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        RUNNING = False
        print(f"\n\n{R}>>> CEASE FIRE. COOLING DOWN...{N}")
        time.sleep(1)
        print(f"{G}>>> STRESS TEST COMPLETE.{N}")

if __name__ == "__main__":
    main()

