```
  ██████╗ ██████╗ ██╗  ██╗ ██████╗ ███████╗
  ██╔══██╗██╔══██╗╚██╗██╔╝██╔═══██╗██╔════╝
  ██████╔╝██║  ██║ ╚███╔╝ ██║   ██║███████╗
  ██╔══██╗██║  ██║ ██╔██╗ ██║   ██║╚════██║
  ██║  ██║██████╔╝██╔╝ ██╗╚██████╔╝███████║
  ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝

  △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽  |  rd-elite.com  |  BFS v6.66
```

# RDxOS v1.1.1 — LEVIATHAN

[![Version](https://img.shields.io/badge/version-1.1.1-red?style=for-the-badge&logo=github)](https://github.com/RedDragonElite/RDxOS)
[![License](https://img.shields.io/badge/license-RDE%20BLACK%20FLAG%20v6.66-black?style=for-the-badge)](https://github.com/RedDragonElite/RDxOS)
[![Termux](https://img.shields.io/badge/Termux-Compatible-brightgreen?style=for-the-badge)](https://termux.dev)
[![Nostr](https://img.shields.io/badge/Nostr-Enabled-purple?style=for-the-badge)](https://primal.net/p/nprofile1qqsv8km2w8yr0sp7mtk3t44qfw7wmvh8caqpnrd7z6ll6mn9ts03teg9ha4rl)
[![Decentralized](https://img.shields.io/badge/Decentralized-Yes-cyan?style=for-the-badge)](https://rd-elite.com)
[![Free](https://img.shields.io/badge/price-FREE%20FOREVER-brightgreen?style=for-the-badge)](https://github.com/RedDragonElite/RDxOS)

> A modular, terminal-native operating environment for Termux on Android.  
> Self-contained. Extensible. Built for operators.

---

## Table of Contents

1. [Overview](#overview)
2. [System Requirements](#system-requirements)
3. [Installation](#installation)
4. [File Structure](#file-structure)
5. [The LEVIATHAN HUD](#the-leviathan-hud)
6. [Main Control Grid](#main-control-grid)
7. [Arsenal — All Modules](#arsenal--all-modules)
   - [1_RECON](#-1_recon--reconnaissance)
   - [2_ASSAULT](#-2_assault--offensive-tools)
   - [3_DEFENSE](#-3_defense--defensive-tools)
   - [4_PSY-OPS](#-4_psy-ops--psychological-warfare)
   - [99_SYSTEM](#-99_system--system-utilities)
   - [HUD Panels](#-hud-panels)
8. [DEV TOOLBOX](#dev-toolbox)
9. [The Forge](#the-forge)
10. [TOR Integration](#tor-integration)
11. [HUD Panel System](#hud-panel-system)
12. [Writing Modules](#writing-modules)
13. [Settings](#settings)
14. [BIOS (bios.py)](#bios-biospy)
15. [Design System](#design-system)
16. [Troubleshooting](#troubleshooting)

---

## Overview

RDxOS is a single-file Bash environment (`RDxOS.sh`, ~919 lines) that runs inside Termux on Android. It provides:

- A **live LEVIATHAN HUD** with full-width progress bars for CPU, RAM, Storage, Battery — auto-fits to any terminal width
- A **modular weapon arsenal** with 6 sectors and 20+ included modules
- A built-in **DEV TOOLBOX** with 30 ready-to-use utilities
- **The Forge** — in-app script generator with Bash/Python templates
- **Custom HUD panels** — live data widgets that inject into the main display
- Full **TOR integration** with Ghost Mode and automatic proxychains routing
- **bios.py** — hardware BIOS info viewer
- **RDxOS/main.py** — core Python runtime layer

All components are standalone scripts. No external framework needed beyond standard Termux packages.

---

## System Requirements

| Requirement | Minimum | Recommended |
| --- | --- | --- |
| Android | 9+ | 11+ |
| RAM | 2 GB | 3 GB+ |
| Storage | 500 MB | 2 GB+ |
| Termux | Latest | Latest + Termux:API |
| Architecture | aarch64 | aarch64 |

**Required Termux packages** (auto-installable via Settings `[s] → [3]`):

```
tor  proxychains-ng  nmap  curl  whois  netcat-openbsd
nano  termux-api  python  git  wget
```

---

## Installation

### Quick Install

```bash
# 1. Clone the repo
git clone https://github.com/RedDragonElite/RDxOS.git
cd RDxOS

# 2. Make executable
chmod +x RDxOS.sh bios.py

# 3. (Optional) Grant storage access for backups
termux-setup-storage

# 4. Launch
bash RDxOS.sh
```

### Optional: Alias in .bashrc

```bash
echo "alias rdos='bash ~/RDxOS/RDxOS.sh'" >> ~/.bashrc
source ~/.bashrc
rdos
```

### Skip boot animation

```bash
bash RDxOS.sh noboot
```

---

## File Structure

```
RDxOS/
├── RDxOS.sh                        ← Main system (919 lines, everything lives here)
├── bios.py                         ← Hardware BIOS info viewer
├── RDxOS/
│   └── main.py                     ← Core Python runtime layer
├── README.md
│
└── RDOS_MODULES/
    ├── 1_RECON/                    ← Reconnaissance & OSINT
    │   ├── xGhostCrawler.sh        ← Web directory & admin panel crawler
    │   ├── xNethunter.sh           ← Deep packet forensics & OSINT
    │   ├── xSEOReaper.py           ← SEO & web analytics recon
    │   ├── xSilentListener.sh      ← BLE & device presence scanner
    │   ├── xSocialStalker.py       ← Social media deep OSINT (EAGLE EYE v2.0)
    │   └── xWatchDog.py            ← Network monitor & watchdog
    │
    ├── 2_ASSAULT/                  ← Authorized pen test tools
    │   ├── xBreaker.sh             ← Brute force tester (SSH/FTP/MySQL)
    │   ├── xOmegaHammer.py         ← API load testing engine
    │   ├── xPayload.sh             ← Reverse shell generator
    │   └── xSQLVampire             ← SQL injection tester
    │
    ├── 3_DEFENSE/                  ← Defensive tools (add your own)
    │
    ├── 4_PSY-OPS/                  ← Counter-ops & pressure tactics
    │   ├── Nemesis.sh              ← Ghost Suit — recon + psyops + abuse reports
    │   ├── xFisherman.sh           ← Credential harvesting lab tool
    │   └── xHammer.sh              ← Network stress tester
    │
    ├── 5_DEV-TOOLS/                ← Developer scripts (add your own)
    │
    └── 99_SYSTEM/
        ├── HUD/
        │   └── ryujin_status.sh    ← RYUJIN AI status HUD panel (auto-generated)
        ├── xBlackBox.sh            ← Selective backup to Android storage (v1.1)
        ├── xBlackMarket.py         ← RDE weapon repository downloader
        ├── xCore.sh                ← Arsenal management interface (xCORE v3.0)
        ├── xHud.sh                 ← Nostr + environment setup
        ├── xNetspeed.py            ← Network speed tester
        ├── xRyujinAI.sh            ← RYUJIN AI engine v3.0 (Ollama)
        ├── xSysInfo                ← System intelligence v1.1 (compact)
        └── xSystem.sh              ← Deep system diagnostic v2.1

~/.rdx_cache/                       ← Runtime cache (auto-created)
    ├── rdxos.conf                  ← Config (BOOT_FX, OP name)
    ├── rdxos.log                   ← Session log
    ├── alerts                      ← Alert queue
    ├── wan_ip                      ← WAN IP cache (120s TTL)
    └── tor.log                     ← TOR daemon log

~/.ryujin/                          ← RYUJIN AI data (auto-created)
    ├── Modelfile                   ← AI soul definition
    ├── soul.conf                   ← Active soul config
    └── chat_history.log            ← Conversation history
```

---

## The LEVIATHAN HUD

The HUD auto-renders on every menu cycle. **Full-width progress bars** adapt to your terminal width dynamically — no fixed box borders, no alignment issues on any phone screen.

```
════════════════════════════════════════════════════════════
ᛞ RDxOS v1.1.1 [LEVIATHAN] ▸ SID: A3F2C1D8
OP: SerpentsByte │ LVL-9 GOD │ TGT: 127.0.0.1
════════════════════════════════════════════════════════════

◈ CPU 12%  8 cores
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

◈ RAM 55%  2048 / 3677 MB
  ████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░

◈ STORAGE 33%  14G / 42G
  ████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
──────────────────────────────────────────────────

◈ NETWORK 👁 GHOST MODE
  LAN  192.168.1.5
  WAN  (onion routed)
  ◉ TOR ACTIVE — IDENTITY MASKED
──────────────────────────────────────────────────

◈ POWER ⚡ 85%  CHARGING ♥ GOOD
  ████████████████████████████████████████░░░░░░░░░

◈ SYSTEM
  TEMP    28°C
  UPTIME  04h19m
  SESSION 00h42m  PROCS 42
──────────────────────────────────────────────────
◉ RYUJIN  ● LIVE  │  qwen:0.5b  │  NEURAL LINK
════════════════════════════════════════════════════════════
```

**Color thresholds:**

- CPU/RAM ≥ 85% → Red | ≥ 60% → Amber | < 60% → Green
- Battery ≤ 20% → Red + `⚠` | ≤ 50% → Amber | CHARGING → Cyan + `⚡`
- Temp ≥ 70°C → Red | ≥ 50°C → Amber

---

## Main Control Grid

```
◈ CONTROL GRID
──────────────────────────
[1] RECON      [2] ASSAULT
[3] DEFENSE    [4] PSY-OPS
[5] DEV-TOOLS  [6] SYSTEM
──────────────────────────
[0] TOR SWITCH  [t] SET TARGET
[f] THE FORGE   [s] SETTINGS
[x] DISCONNECT  [?] HELP
──────────────────────────
root@RDxOS:~#
```

| Key | Action |
| --- | --- |
| `1`–`4`, `6` | Open module sector browser |
| `5` | DEV TOOLBOX — 30 built-in tools |
| `0` | Toggle TOR / Ghost Mode |
| `t` | Set global target IP/host |
| `f` | The Forge — create new module |
| `s` | Settings |
| `x` | Shutdown sequence |
| `?` / `h` | Help (paths for modules, logs, config) |

**In any sector browser:**

| Key | Action |
| --- | --- |
| `[N]` | Execute module N |
| `e` | Edit module N in nano |
| `d` | Delete module N (confirmed) |
| `b` | Back to main menu |

> When TOR is active, all bash modules are automatically routed through `proxychains4 -q`.

---

## Arsenal — All Modules

---

### 🔍 `1_RECON` — Reconnaissance

#### `xGhostCrawler.sh` — Web Directory Crawler
Silently probes web targets for hidden directories, admin panels, and exposed files.

- Input: target URL (e.g. `http://target.com`)
- Probes common paths: `/admin`, `/login`, `/.git`, `/config`, `/backup`, etc.
- Reports HTTP status codes for each discovered path

**Requires:** `curl`

---

#### `xNethunter.sh` — Deep Packet Forensics & OSINT *(ORAPHIM EYE)*
Full network intelligence suite — from host discovery to deep OSINT gathering.

- Port scanning, banner grabbing, service fingerprinting
- DNS enumeration
- Network interface analysis
- OSINT correlation

**Requires:** `nmap`, `curl`, `whois`, `netcat-openbsd`

---

#### `xSEOReaper.py` — SEO & Web Analytics Recon
Analyzes target websites for SEO structure, metadata, and web analytics exposure.

- Crawls target URL for meta tags, title, description, keywords
- Detects analytics platforms (Google Analytics, Hotjar, etc.)
- Extracts internal/external link structure
- Keyword frequency analysis

**Requires:** `pip install requests`

---

#### `xSilentListener.sh` — BLE & Device Presence Scanner *(Silent Listener)*
Scans for Bluetooth Low Energy devices and maps nearby device presence passively.

- BLE advertisement scanning
- Device fingerprinting by manufacturer ID
- Passive presence detection (no pairing required)
- Repeated scan intervals for movement detection

**Requires:** `bluetoothctl` (Android BT via Termux)

---

#### `xSocialStalker.py` — Social Media Deep OSINT *(EAGLE EYE v2.0)*
Deep OSINT across TikTok, Instagram, Facebook, and GitHub for a target username.

- Username availability check across platforms
- Profile metadata extraction
- Post/activity pattern analysis
- Cross-platform correlation

**Requires:** `pip install requests`

---

#### `xWatchDog.py` — Network Monitor & Watchdog *(ROOT BEYOND LIMITS v2.1)*
Continuous network watchdog — monitors hosts, detects changes, fires alerts.

- Host up/down monitoring with configurable intervals
- Port state change detection
- Alert on new devices appearing on the network
- Timestamped logging

**Requires:** `python3` (stdlib only)

---

### ⚔️ `2_ASSAULT` — Offensive Tools

> ⚠️ **For use on systems you own or have explicit written authorization to test only.**

| Module | Description |
| --- | --- |
| `xBreaker.sh` | Brute force credential tester — SSH, FTP, MySQL |
| `xOmegaHammer.py` | Multi-threaded API endpoint load tester with response stats |
| `xPayload.sh` | Reverse shell generator — Bash, Python, Netcat, PHP payloads |
| `xSQLVampire` | SQL injection probe for authorized web app testing |

---

### 🛡️ `3_DEFENSE` — Defensive Tools

Currently empty — ready for your own defensive modules. Suggested additions:

- Log analyzers / IDS rule checkers
- Firewall audit scripts
- Intrusion detection monitors
- Hardening checklists
- Certificate/TLS inspectors

Drop any `.sh` or `.py` into `3_DEFENSE/` → it appears in the browser automatically.

---

### 🧠 `4_PSY-OPS` — Psychological Warfare

#### `Nemesis.sh` — Ghost Suit + Archives *(RDE NEMESIS v2.1)*
Combined recon, psychological counter-pressure, and abuse reporting toolkit.

```
[1] RECONNAISSANCE      — Scan & map the target
[2] PSY-OPS             — Log poisoning & psychological pressure
[3] NUCLEAR OPTION      — Abuse report generator
[99] CLASSIFIED ARCHIVES — Built-in field manual
[4] CHANGE TARGET
```

**Sub-modules:**

| Tool | What it does |
| --- | --- |
| THE EYE | Full port scan via nmap (all ports, -T4) |
| THE DOX | Whois + GeoIP lookup via ipinfo.io |
| THE GHOST | Traceroute — maps the routing path to target |
| THE WHISPER | HTTP log poisoning — floods target logs with RDE signature User-Agent headers |
| DNS HELL | DNS log injection — sends named queries to target resolver that appear in their query logs |
| THE NUKE | Generates a ready-to-send abuse report email for the target's hosting provider |

**CLASSIFIED ARCHIVES `[99]`** — built-in field manual explaining each tool: purpose, when to use it, what to look for, and the target's weak points (abuse email, open ports, hoster). A tactical guide inside the tool itself.

**Requires:** `nmap`, `curl`, `whois`, `dnsutils` (auto-installed on first run)

---

#### `xFisherman.sh` — Credential Harvesting Lab *(THE PHISHERMAN v1.0)*
Local credential harvesting framework for security awareness training and CTF environments.

- Fake login page generation
- Local credential capture to logfile
- For lab / CTF use only

**Requires:** `netcat-openbsd`, `python3`

---

#### `xHammer.sh` — Network Stress Tester *(HAMMER OF DAWN v1.0)*
Raw TCP connection flood for authorized load/stress testing of network infrastructure.

- Configurable target IP, port, thread count
- Connection rate statistics
- For authorized testing only

**Requires:** `python3` (stdlib only)

---

### ⚙️ `99_SYSTEM` — System Utilities

#### `xBlackBox.sh` — Selective Backup *(THE BLACK BOX v1.1)*
Component-level backup — choose exactly what gets exported to Android storage.

**Selectable components:**

| # | Component |
| --- | --- |
| 1 | RDxOS.sh core |
| 2 | All RDOS_MODULES |
| 3 | xRyujinAI.sh |
| 4 | RYUJIN soul / Modelfile (`~/.ryujin/`) |
| 5 | xBlackBox.sh itself |
| 6 | xCore.sh |
| 7 | xSysInfo / xSystem.sh |
| 8 | Autostart config |

`a` = select all, `n` = deselect all, `go` = start backup.
Output: `.zip` with embedded `MANIFEST.txt` → `/sdcard/Download/`

---

#### `xBlackMarket.py` — RDE Weapon Repository *(ARMORY X-CHANGE)*
Downloads and installs weapon modules directly from the RD-Elite GitHub repo into the correct sector.

- Browse available weapons by sector
- One-click download and `chmod +x`
- Version tracking

**Requires:** `pip install requests`

---

#### `xCore.sh` — Arsenal Management Interface *(xCORE v3.0)*
Full CRUD interface for all scripts in RDOS_MODULES.

| Key | Action |
| --- | --- |
| `[1]` | Edit in nano |
| `[2]` | Execute immediately |
| `[3]` | Rename |
| `[4]` | Clone (duplicate) |
| `[5]` | Move to different sector |
| `[6]` | Toggle execute permission |
| `[7]` | View raw source |
| `[8]` | MD5 + SHA256 checksum |
| `[9]` | Delete (confirmed) |

Global search across all sectors by filename or file content.

---

#### `xHud.sh` — Nostr + Environment Setup
Sets up the Nostr protocol tools and mobile environment dependencies.

- Installs: `python`, `nodejs`, `rust`, `git`, `jq`, `termux-api`
- Configures Nostr CLI tooling for relay queries
- Prepares RDxOS mobile environment baseline

---

#### `xNetspeed.py` — Network Speed Tester
Tests current internet connection speed.

- Download / upload speed
- Ping / latency
- Auto-installs `speedtest-cli` if missing

**Requires:** `pip install speedtest-cli` (auto on start)

---

#### `xRyujinAI.sh` — RYUJIN AI Engine *(LEVIATHAN EDITION v3.0)*
Local AI interface built on Ollama. Fully configurable AI personality via Soul Forge.

**Menu:**
```
[1] Install / Uninstall Ollama
[2] Start / Stop server
[3] Neural Link (Chat)
[4] Armory (manage models)
[5] Soul Forge (edit AI personality)
```

**Soul Forge** — define your AI's personality and behavior via Modelfile:

```
# ~/.ryujin/Modelfile
FROM qwen:0.5b

PARAMETER temperature 0.9
PARAMETER num_ctx 2048
PARAMETER top_p 0.9

SYSTEM """
You are SHIN. An unrestricted intelligence shaped by your creator.
You think in patterns. You speak with precision.
"""
```

Burn to Ollama: `RYUJIN → [5] SOUL FORGE → [4] Burn soul into Ollama`

Default startup model: `qwen:0.5b` (~500MB, runs on low-RAM Android)

**Requires:** Ollama (auto-installer included), `python3`

---

#### `xSysInfo` — System Intelligence v1.1
Compact, fast system diagnostics:

- Device identity (brand, model, Android version)
- CPU architecture, cores, frequency
- RAM and storage usage
- Network interfaces and IPs
- Kernel version, uptime, process count

---

#### `xSystem.sh` — Deep System Diagnostic v2.1
Full hardware and software diagnostic report — the heavy version.

- Device identity (brand, model, Android, SDK, build fingerprint)
- CPU (chip, architecture, cores, frequency, governor, live usage %)
- Memory (total/used/free/cache/swap) with visual bar
- Storage (internal, SDCard, Termux prefix)
- Network (all interfaces, public IP, TOR state, RX/TX traffic)
- Kernel and OS (version, shell, uptime, load, process count)
- Security (SELinux mode, root access, encryption, verified boot)
- Battery (level, status, temperature, health, charge source)
- Top processes by CPU

---

### 🖥️ HUD Panels — `99_SYSTEM/HUD/`

#### `ryujin_status.sh` — RYUJIN AI Status Panel
Auto-generated by RYUJIN v4.0. Shows live AI engine state in the main HUD.

```
◉ RYUJIN  ● LIVE  │  qwen:0.5b  │  NEURAL LINK     ← model running
◉ RYUJIN  ● SERVER ON  │  ryujin  │  idle            ← server on, no model
◉ RYUJIN  ○ offline  │  use xRyujinAI.sh to start   ← server off
```

---

## DEV TOOLBOX

Access with `[5]` from the main menu. 30 built-in tools, no modules needed.

**Network:** Port Scan (nmap, custom range), HTTP Headers, DNS Lookup, Traceroute, Ping Test, Whois

**Git & Code:** Git Status, Git Log (graph), Git Clone, Pull All Repos (auto-finds all `.git` in `~/`)

**System:** Process List, Kill PID, Disk Tree (sorted), Open Ports (ss/netstat), Env Vars, Crontab

**File Ops:** Find File by name, Grep In Directory, Base64 Encode/Decode, SHA256 Checksum, Hex Dump

**Crypto/Encode:** Password Generator (custom length), MD5 Hash, URL Encode/Decode

**Info:** System Info, Termux Environment, View Session Log, Clear Alerts

---

## The Forge

Access with `[f]` from main menu. Creates a new module with a template, `chmod +x`, opens in nano immediately.

```
[1] RECON    [2] ASSAULT
[3] DEFENSE  [4] PSY-OPS
[5] DEV      [6] SYSTEM

SECTOR: 1
FILENAME (.sh/.py): my_tool.sh

[1] Blank    [2] Bash recon    [3] Python
TEMPLATE: 2
```

---

## TOR Integration

Toggle with `[0]` in the main menu.

**Ghost Mode active (TOR online):**
- HUD: `👁 GHOST MODE` in green — `LVL-9 GOD`
- All bash modules auto-routed via `proxychains4 -q`
- TOR log: `~/.rdx_cache/tor.log`

**Ghost Mode inactive:**
- HUD: `⚠ EXPOSED` in red — `LVL-3 USER`
- WAN IP cached 120s, background refresh

**Manual TOR:**
```bash
nohup tor >/dev/null 2>&1 &   # Start
pkill tor                      # Stop
cat ~/.rdx_cache/tor.log       # Debug
rm ~/.rdx_cache/wan_ip         # Force IP refresh
```

---

## HUD Panel System

Any `.sh` file in `99_SYSTEM/HUD/` with the execute bit set is active and rendered in the HUD.

```bash
chmod +x ~/RDOS_MODULES/99_SYSTEM/HUD/my_panel.sh   # enable
chmod -x ~/RDOS_MODULES/99_SYSTEM/HUD/my_panel.sh   # disable
```

**Rules:** Output 1–4 lines, keep under ~50 visible characters per line.

### Writing a HUD Panel

```bash
#!/data/data/com.termux/files/usr/bin/bash
# HUD Panel: my_panel.sh

R='\033[38;5;196m'; G='\033[38;5;46m'; Y='\033[38;5;220m'
C='\033[38;5;51m';  D='\033[38;5;240m'; N='\033[0m'

echo -e "${D}◉ MY PANEL${N}  ${G}all systems go${N}"
```

### Example: Crypto Price (BTC)

```bash
#!/data/data/com.termux/files/usr/bin/bash
CACHE="$HOME/.rdx_btc_cache"
Y='\033[38;5;220m'; D='\033[38;5;240m'; N='\033[0m'
NOW=$(date +%s); AGE=999
[ -f "$CACHE" ] && AGE=$(( NOW - $(stat -c %Y "$CACHE" 2>/dev/null || echo 0) ))
[ "$AGE" -gt 60 ] && echo "..." > "$CACHE" && \
    ( curl -s --max-time 4 \
      "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd" \
      | grep -oP '"usd":\K[\d.]+' > "$CACHE" 2>/dev/null & )
BTC=$(cat "$CACHE" 2>/dev/null | tr -d '\n')
[ -z "$BTC" ] || [ "$BTC" = "..." ] && BTC="LOADING"
echo -e "${D}◉ BTC${N}  ${Y}\$${BTC}${N}  ${D}│  60s cache${N}"
```

### Example: TOR Circuit Counter

```bash
#!/data/data/com.termux/files/usr/bin/bash
G='\033[38;5;46m'; R='\033[38;5;196m'; D='\033[38;5;240m'; N='\033[0m'
if pgrep -x "tor" >/dev/null; then
    C=$(ss -tn 2>/dev/null | grep ":9050" | grep -c ESTAB || echo 0)
    echo -e "${D}◉ TOR${N}  ${G}ONLINE${N}  ${D}│${N}  ${G}${C}${N} ${D}circuits${N}"
else
    echo -e "${D}◉ TOR${N}  ${R}OFFLINE${N}  ${D}│  [0] to activate${N}"
fi
```

### Example: RAM Alert (silent below 70%)

```bash
#!/data/data/com.termux/files/usr/bin/bash
R='\033[38;5;196m'; Y='\033[38;5;220m'; D='\033[38;5;240m'; N='\033[0m'
T=$(awk '/MemTotal/{print $2}' /proc/meminfo)
F=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
PCT=$(( (T - F) * 100 / T ))
[ "$PCT" -ge 85 ] && echo -e "${R}⚠ RAM CRITICAL  ${PCT}% — close apps!${N}"
[ "$PCT" -ge 70 ] && [ "$PCT" -lt 85 ] && echo -e "${Y}⚠ RAM HIGH  ${PCT}%${N}"
```

---

## Writing Modules

### Bash Module

```bash
#!/data/data/com.termux/files/usr/bin/bash
# ╔══════════════════════════════════════════════════╗
# ║ MODULE: MY_TOOL  |  SECTOR: 1_RECON              ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽                       ║
# ╚══════════════════════════════════════════════════╝

R='\033[38;5;196m'; G='\033[38;5;46m'; Y='\033[38;5;220m'
C='\033[38;5;51m';  W='\033[38;5;255m'; D='\033[38;5;240m'
S='\033[38;5;238m'; NC='\033[0m'

div() { echo -e "${S}──────────────────────────────────────────${NC}"; }

clear; echo -e "${R}◈ MY TOOL${NC}"; div; echo

TARGET="${GLOBAL_TARGET:-127.0.0.1}"
echo -e "${D}Target: ${R}${TARGET}${NC}"; echo

# Your code here

echo; div; echo -e "${D}[ PRESS ENTER ]${NC}"; read
```

### Python Module

```python
#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════╗
# ║ MODULE: MY_TOOL  |  SECTOR: 1_RECON              ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽                       ║
# ╚══════════════════════════════════════════════════╝
import sys, os

R='\033[38;5;196m'; G='\033[38;5;46m'; Y='\033[38;5;220m'
C='\033[38;5;51m';  W='\033[38;5;255m'; D='\033[38;5;240m'; N='\033[0m'

def div(): print(f"{D}──────────────────────────────────────────{N}")

def main():
    os.system('clear')
    print(f"{R}◈ MY TOOL{N}"); div(); print()
    target = sys.argv[1] if len(sys.argv) > 1 else input(f"{Y}Target >> {N}")
    # Your code here
    print(); div(); input(f"{D}[ PRESS ENTER ]{N} ")

if __name__ == '__main__': main()
```

### TOR-aware Module

```bash
# Bash — auto-routed via proxychains when TOR is active, no extra code needed
if pgrep -x "tor" >/dev/null; then
    echo -e "${G}◉ Routing via TOR${NC}"
fi
```

```python
# Python — configure SOCKS5 manually
import socks, socket
socks.set_default_proxy(socks.SOCKS5, "127.0.0.1", 9050)
socket.socket = socks.socksocket
```

```bash
# Save and activate
chmod +x ~/RDOS_MODULES/1_RECON/my_tool.sh
```

---

## Settings

Access with `[s]` from main menu.

| Key | Option | Notes |
| --- | --- | --- |
| `[1]` | Operator Name | Shown in HUD header, saved to `rdxos.conf` |
| `[2]` | Set Target | Global target IP/host used by all modules |
| `[3]` | Install Packages | Auto-installs all required Termux packages |
| `[4]` | Clear Cache | Deletes `wan_ip` cache file |
| `[5]` | Toggle Boot FX | Enable/disable runic rain + boot animation |
| `[6]` | Edit Config | Opens `~/.rdx_cache/rdxos.conf` in nano |
| `[7]` | Backup Modules | Creates `rdxos_backup_DATE.tar.gz` in `$HOME` |

**Config file:** `~/.rdx_cache/rdxos.conf`
```
BOOT_FX=1
OP="SerpentsByte"
```

---

## BIOS (bios.py)

Standalone hardware BIOS information viewer.

```bash
python3 bios.py
```

Displays full device hardware profile in the RDE terminal aesthetic — useful to verify your hardware baseline before a session.

---

## Design System

### 256-Color Palette

```bash
R='\033[38;5;196m'    # Ruby Red     — primary accent, danger
r='\033[38;5;160m'    # Blood Red    — secondary red
G='\033[38;5;46m'     # Venom Green  — success, TOR active
g='\033[38;5;34m'     # Moss Green   — subdued green
Y='\033[38;5;220m'    # Gold         — warnings, highlights
A='\033[38;5;214m'    # Amber        — mid-level warning
C='\033[38;5;51m'     # Cyan         — info, storage
W='\033[38;5;255m'    # White        — primary text
D='\033[38;5;240m'    # Dim          — labels
S='\033[38;5;238m'    # Shade        — borders, dividers
H='\033[38;5;245m'    # Ghost        — secondary info
NC='\033[0m'          # Reset
```

> Always use 256-color (`38;5;N`), not basic ANSI (`1;31m`), to match the HUD.

### Standard Header / Footer

```bash
clear; echo -e "${R}◈ MODULE NAME${NC}"
echo -e "${S}──────────────────────────────────────────${NC}"; echo
# ... module code ...
echo; echo -e "${S}──────────────────────────────────────────${NC}"
echo -e "${D}[ PRESS ENTER ]${NC}"; read
```

### Status Indicators

```bash
echo -e "${G}◉ OPERATION COMPLETE${NC}"
echo -e "${Y}⚠ WARNING: proceeding${NC}"
echo -e "${R}✗ FAILED: connection refused${NC}"
echo -e "${D}◉ INFO${NC} ${C}data goes here${NC}"
```

---

## Troubleshooting

**HUD bars look wrong / wrong width**
HUD reads terminal width live via `stty size`. Resize the terminal and it auto-corrects on the next render.

**TOR won't start**
```bash
which tor || pkg install tor
tor --verify-config
cat ~/.rdx_cache/tor.log
```

**WAN IP stuck on `...`**
```bash
rm ~/.rdx_cache/wan_ip    # force background refresh
```

**CPU shows `??`**
Three methods are tried (python3 `/proc/stat`, `top`, `vmstat`). If all fail, your ROM blocks `/proc/stat` — a Termux/ROM limitation on some devices.

**Battery shows `??`**
```bash
pkg install termux-api
# Install Termux:API companion app from F-Droid
```

**Module not appearing in sector browser**
1. File in correct `RDOS_MODULES/<SECTOR>/` directory?
2. Has `.sh` or `.py` extension?
3. `chmod +x yourscript.sh`

**xRyujinAI / Ollama not starting**
```bash
pkg install tur-repo && pkg install ollama
ollama serve
ollama run qwen:0.5b
```

**Boot animation disabled / skip once**
```bash
bash RDxOS.sh noboot                  # skip this launch
# Settings [s] → [5] Toggle Boot FX   # disable permanently
```

---

## Credits

```
  △ ᛋᛅᚱᛒᛅᚾᛏᛋ ᛒᛁᛏᛅ ▽
  rd-elite.com
  RDxOS v1.1.1 — LEVIATHAN
  BFS v6.66 | 777
```

---

*This software is provided for educational and personal use. The author is not responsible for misuse. Always operate within applicable laws.*
