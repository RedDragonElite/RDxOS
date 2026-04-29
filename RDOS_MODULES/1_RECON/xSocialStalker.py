#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE SOCIAL STALKER v2.0 [EAGLE EYE]                              ║
# ║ TARGET: TIKTOK / INSTA / FB / GITHUB DEEP OSINT                          ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import os
import sys
import time
import json
import re
import random
import datetime

# --- [ COLORS ] ---
R = '\033[1;31m'
DR = '\033[0;31m'
G = '\033[1;30m'
W = '\033[1;37m'
Y = '\033[1;33m'
P = '\033[1;35m'
C = '\033[0;36m'
N = '\033[0m'

# --- [ DEPENDENCY CHECK ] ---
try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    print(f"{R}[SYSTEM] MISSING PYTHON MODULES...{N}")
    os.system("pip install requests beautifulsoup4")
    print(f"{Y}RESTARTING...{N}")
    os.execv(sys.executable, ['python3'] + sys.argv)

# --- [ UTILS ] ---
UA_LIST = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
    'Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
    'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
]

def get_random_ua():
    return random.choice(UA_LIST)

def banner():
    os.system('clear')
    print(f"{P}")
    print(f"   █▀▀ █▀▀█ █▀▀ █ █ █▀▄▀█ █ █▄ █ ▀▀█▀▀")
    print(f"   ▀▀█ █  █ █   █  █ ▀ █ █ █ ▀█   █  ")
    print(f"   ▀▀▀ ▀▀▀▀ ▀▀▀ ▀  ▀   ▀ ▀ ▀  ▀   ▀  ")
    print(f"   {C}:: SOCIAL STALKER v2.0 [EAGLE EYE] ::{N}")
    print(f"")

def loading(msg):
    print(f"{R}[PROC]{N} {msg}", end="\r")
    time.sleep(0.8)
    print(f"{R}[PROC]{N} {msg} {Y}DONE{N}          ")

def save_json(data, prefix):
    ts = int(time.time())
    fname = f"dump_{prefix}_{ts}.json"
    with open(fname, 'w') as f:
        json.dump(data, f, indent=4)
    print(f"{G}    [SAVED JSON] -> {fname}{N}")

# --- [ GITHUB DEEP SCAN ] ---
def scan_github(url):
    print(f"\n{Y}>>> TARGET: GITHUB REPO{N}")
    match = re.search(r"github\.com/([^/]+)/([^/]+)", url)
    if not match: print(f"{R}[!] INVALID URL{N}"); return

    user, repo = match.groups()
    headers = {'User-Agent': get_random_ua()}
    
    loading("FETCHING REPO METADATA")
    try:
        r = requests.get(f"https://api.github.com/repos/{user}/{repo}", headers=headers)
        d = r.json()
        
        if "message" in d and d["message"] == "Not Found":
             print(f"{R}[!] REPO NOT FOUND OR PRIVATE{N}"); return

        print(f"{G}────────────────────────────────────────{N}")
        print(f"  PROJECT  :: {W}{d.get('name')}{N}")
        print(f"  OWNER    :: {Y}{d.get('owner', {}).get('login')}{N} (ID: {d.get('owner', {}).get('id')})")
        print(f"  DESC     :: {W}{d.get('description')}{N}")
        print(f"  LANG     :: {C}{d.get('language')}{N}")
        print(f"  STATS    :: Stars: {Y}{d.get('stargazers_count')}{N} | Forks: {Y}{d.get('forks_count')}{N}")
        print(f"  ISSUES   :: {R}{d.get('open_issues_count')}{N} Open")
        print(f"  CREATED  :: {G}{d.get('created_at')}{N}")
        print(f"  SIZE     :: {W}{d.get('size')} KB{N}")
        print(f"{G}────────────────────────────────────────{N}")

        loading("ANALYZING COMMIT HISTORY")
        c = requests.get(f"https://api.github.com/repos/{user}/{repo}/commits", headers=headers).json()
        
        if isinstance(c, list) and len(c) > 0:
            print(f"{P}  LATEST ACTIVITY:{N}")
            for i in range(min(5, len(c))):
                msg = c[i]['commit']['message'].split('\n')[0]
                auth = c[i]['commit']['author']['name']
                date = c[i]['commit']['author']['date']
                print(f"  [{G}{date[:10]}{N}] {Y}{auth}{N}: {msg}")
        
        save_json({"repo": d, "commits": c[:5]}, "github")

    except Exception as e:
        print(f"{R}[!] ERROR: {e}{N}")

# --- [ TIKTOK DEEP SCAN ] ---
def scan_tiktok(url):
    print(f"\n{Y}>>> TARGET: TIKTOK VIDEO{N}")
    loading("BYPASSING TIKTOK WATERMARK")
    
    # We use tikwm.com public API for cleaner data
    api_url = "https://www.tikwm.com/api/"
    headers = {'User-Agent': get_random_ua()}
    
    try:
        r = requests.post(api_url, data={'url': url}, headers=headers)
        data = r.json()
        
        if data['code'] == 0:
            v = data['data']
            print(f"{G}────────────────────────────────────────{N}")
            print(f"  TITLE    :: {W}{v.get('title')}{N}")
            print(f"  AUTHOR   :: {Y}{v.get('author', {}).get('nickname')}{N} (@{v.get('author', {}).get('unique_id')})")
            print(f"  REGION   :: {C}{v.get('region')}{N}")
            print(f"  STATS    :: Plays: {Y}{v.get('play_count')}{N} | Likes: {Y}{v.get('digg_count')}{N}")
            print(f"  MUSIC    :: {P}{v.get('music_info', {}).get('title')}{N}")
            print(f"  CREATED  :: {G}{datetime.datetime.fromtimestamp(v.get('create_time'))}{N}")
            print(f"{G}────────────────────────────────────────{N}")
            
            # Direct Links
            print(f"{P}  [DIRECT DOWNLOAD LINKS]:{N}")
            print(f"  NO-WM    :: {C}https://www.tikwm.com{v.get('play')}{N}")
            print(f"  MUSIC    :: {C}{v.get('music')}{N}")
            print(f"  COVER    :: {C}{v.get('cover')}{N}")
            
            save_json(v, "tiktok")
        else:
            print(f"{R}[!] API ERROR (Video private or deleted?){N}")
            
    except Exception as e:
        print(f"{R}[!] FAILED: {e}{N}")

# --- [ INSTAGRAM RECON ] ---
def scan_instagram(url):
    print(f"\n{Y}>>> TARGET: INSTAGRAM POST{N}")
    loading("SCRAPING META TAGS (No-Login)")
    
    # Instagram is hard. We try basic OpenGraph scraping.
    headers = {'User-Agent': get_random_ua()}
    try:
        r = requests.get(url, headers=headers)
        soup = BeautifulSoup(r.text, 'html.parser')
        
        meta = {}
        for tag in soup.find_all('meta'):
            if tag.get('property', '').startswith('og:'):
                meta[tag.get('property')] = tag.get('content')
        
        print(f"{G}────────────────────────────────────────{N}")
        if 'og:title' in meta:
            print(f"  TITLE    :: {W}{meta['og:title']}{N}")
        if 'og:description' in meta:
            print(f"  DESC     :: {W}{meta['og:description'][:100]}...{N}")
        if 'og:image' in meta:
            print(f"  IMG URL  :: {P}{meta['og:image']}{N}")
        if 'og:url' in meta:
            print(f"  PERMALINK:: {C}{meta['og:url']}{N}")
        print(f"{G}────────────────────────────────────────{N}")
        
        if not meta:
            print(f"{R}[!] INSTAGRAM BLOCKED CONNECTION (Login Wall){N}")
        else:
            save_json(meta, "insta")

    except Exception as e:
        print(f"{R}[!] ERROR: {e}{N}")

# --- [ WEB GENERAL ] ---
def scan_general(url):
    print(f"\n{Y}>>> TARGET: GENERAL WEB{N}")
    loading("EXTRACTING METADATA")
    try:
        r = requests.get(url, headers={'User-Agent': get_random_ua()}, timeout=5)
        soup = BeautifulSoup(r.text, 'html.parser')
        
        title = soup.title.string if soup.title else "No Title"
        desc = soup.find('meta', attrs={'name': 'description'})
        desc = desc['content'] if desc else "No Description"
        
        print(f"{G}────────────────────────────────────────{N}")
        print(f"  TITLE    :: {W}{title.strip()}{N}")
        print(f"  SERVER   :: {C}{r.headers.get('Server', 'Unknown')}{N}")
        print(f"  DESC     :: {W}{desc[:100]}...{N}")
        print(f"{G}────────────────────────────────────────{N}")
        
        # Find Emails
        emails = set(re.findall(r"[a-z0-9\.\-+_]+@[a-z0-9\.\-+_]+\.[a-z]+", r.text, re.I))
        if emails:
            print(f"{P}  [EMAILS FOUND]:{N}")
            for e in emails: print(f"  - {R}{e}{N}")
            
    except Exception as e:
        print(f"{R}[!] ERROR: {e}{N}")

# --- [ MAIN ] ---
def main():
    banner()
    print(f"{W}PASTE TARGET LINK:{N}")
    url = input(f"{R}>> {N}").strip()
    
    if not url: return

    if "github.com" in url:
        scan_github(url)
    elif "tiktok.com" in url:
        scan_tiktok(url)
    elif "instagram.com" in url:
        scan_instagram(url)
    else:
        scan_general(url)

    print(f"\n{G}[ PRESS ENTER ]{N}")
    input()

if __name__ == "__main__":
    main()

