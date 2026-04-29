#!/data/data/com.termux/files/usr/bin/bash

# 1. Environment Setup (The Base)
echo -e "\e[1;32m[*] INITIALIZING RDxOS MOBILE ENVIRONMENT...\e[0m"
pkg update -y && pkg upgrade -y
pkg install -y python nodejs rust git jq termux-api

# 2. Install nostr-tool (The Weapon)
# Wir nutzen eine leichte CLI version, um Relays abzufragen
echo -e "\e[1;33m[*] ARMING NOSTR PROTOCOLS...\e[0m"
cargo install nostr-tool 

# 3. Create the HUD Script (The View)
cat << 'EOF' > ~/nostr_hud.py
import asyncio
import json
import ssl
import websockets
from datetime import datetime

# RDE CONFIG
RELAY = "wss://relay.damus.io" # Oder dein eigenes Relay
PUBKEY_FILTER = None # Optional: Nur Logs von deinem Server-Bot filtern
RED = "\033[1;31m"
GREEN = "\033[1;32m"
CYAN = "\033[1;36m"
YELLOW = "\033[1;33m"
RESET = "\033[0m"

async def connect():
    print(f"{GREEN}⚡ RDE OPERATOR HUD ONLINE ⚡{RESET}")
    print(f"{CYAN}📡 Listening on {RELAY}...{RESET}\n")
    
    async with websockets.connect(RELAY) as ws:
        # Subscribe to Kind 1 (Text) & Kind 777 (System Alerts)
        req = {
            "ids": [], "kinds": [1, 777], "limit": 10
        }
        await ws.send(json.dumps(["REQ", "RDE-HUD-01", req]))
        
        while True:
            msg = await ws.recv()
            data = json.loads(msg)
            
            if data[0] == "EVENT":
                event = data[2]
                content = event['content']
                timestamp = datetime.fromtimestamp(event['created_at']).strftime('%H:%M:%S')
                
                # STYLING BASED ON CONTENT
                if "WANTED" in content or "MURDER" in content:
                    prefix = f"{RED}[ALERT]{RESET}"
                elif "ONLINE" in content or "connected" in content:
                    prefix = f"{GREEN}[SYS]{RESET}"
                elif "sold" in content:
                    prefix = f"{YELLOW}[$$$]{RESET}"
                else:
                    prefix = f"{CYAN}[LOG]{RESET}"
                
                print(f"{prefix} {timestamp} | {content}")

asyncio.run(connect())
EOF

# 4. Launch Instructions
echo -e "\e[1;32m[+] SYSTEM READY. EXECUTE 'python ~/nostr_hud.py' TO ENGAGE.\e[0m"
