#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE SEO REAPER v1.0                                              ║
# ║ TARGET: SEARCH ENGINE ALGORITHM MANIPULATION                             ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

import os
import sys
import time
import re
import requests
from collections import Counter
from urllib.parse import urlparse

# --- [ COLORS ] ---
R = '\033[1;31m' # Error / Critical
G = '\033[1;30m' # Grey / Stealth
W = '\033[1;37m' # Text
Y = '\033[1;33m' # Info / Warning
P = '\033[1;35m' # Headers
C = '\033[0;36m' # Data
N = '\033[0m'    # Reset

# --- [ DEPENDENCY CHECK ] ---
try:
    from bs4 import BeautifulSoup
except ImportError:
    print(f"{R}[SYSTEM] MISSING SOUL... INSTALLING 'bs4'{N}")
    os.system("pip install beautifulsoup4 requests")
    os.execv(sys.executable, ['python3'] + sys.argv)

# --- [ UTILS ] ---
def banner():
    os.system('clear')
    print(f"{R}")
    print(f"   █▀▀ █▀▀ █▀▀█   █▀▀█ █▀▀ █▀▀█ █▀▀█ █▀▀ █▀▀█")
    print(f"   ▀▀█ █▀▀ █  █   █▄▄▀ █▀▀ █▄▄█ █  █ █▀▀ █▄▄▀")
    print(f"   ▀▀▀ ▀▀▀ ▀▀▀▀   ▀ ▀▀ ▀▀▀ ▀  ▀ █▀▀▀ ▀▀▀ ▀ ▀▀")
    print(f"   {G}:: SEARCH ENGINE DOMINATION TOOL ::{N}")
    print(f"")

def loading(msg):
    print(f"{P}[ANALYZING]{N} {msg}", end="\r")
    time.sleep(0.5)
    print(f"{P}[ANALYZING]{N} {msg} {Y}COMPLETE{N}          ")

def clean_text(text):
    # Remove special chars and make lowercase
    return re.sub(r'[^\w\s]', '', text).lower()

# --- [ CORE ANALYSIS ] ---
def analyze_seo(url):
    print(f"{W}TARGET LOCKED: {Y}{url}{N}\n")
    
    start_time = time.time()
    try:
        headers = {'User-Agent': 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'}
        r = requests.get(url, headers=headers, timeout=10)
        load_time = round(time.time() - start_time, 3)
        soup = BeautifulSoup(r.text, 'html.parser')
        
        # --- 1. PERFORMANCE & TECH ---
        loading("SERVER RESPONSE")
        print(f"{G}────────────────────────────────────────{N}")
        print(f"  STATUS   :: {C}{r.status_code}{N}")
        
        speed_color = G
        if load_time < 0.5: speed_color = C
        elif load_time > 2.0: speed_color = R
        
        print(f"  SPEED    :: {speed_color}{load_time}s{N} (Google wants < 0.5s)")
        print(f"  SIZE     :: {W}{len(r.content)/1024:.2f} KB{N}")
        print(f"  SERVER   :: {W}{r.headers.get('Server', 'Unknown')}{N}")
        print(f"{G}────────────────────────────────────────{N}")

        # --- 2. META TAGS (THE FACE) ---
        loading("METADATA INJECTION")
        title = soup.title.string if soup.title else None
        desc = soup.find('meta', attrs={'name': 'description'})
        robots = soup.find('meta', attrs={'name': 'robots'})
        canonical = soup.find('link', attrs={'rel': 'canonical'})

        print(f"{G}────────────────────────────────────────{N}")
        
        # Title Analysis
        if title:
            t_len = len(title)
            t_col = C if 30 <= t_len <= 60 else R
            print(f"  TITLE    :: {W}{title}{N}")
            print(f"           :: Length: {t_col}{t_len}/60{N} chars")
        else:
            print(f"  TITLE    :: {R}[MISSING] CRITICAL ERROR{N}")

        # Desc Analysis
        if desc:
            d_content = desc['content']
            d_len = len(d_content)
            d_col = C if 120 <= d_len <= 160 else R
            print(f"  DESC     :: {W}{d_content[:60]}...{N}")
            print(f"           :: Length: {d_col}{d_len}/160{N} chars")
        else:
            print(f"  DESC     :: {R}[MISSING] CRITICAL ERROR{N}")

        # Robots
        rob_content = robots['content'] if robots else "index, follow (Default)"
        print(f"  ROBOTS   :: {Y}{rob_content}{N}")
        print(f"{G}────────────────────────────────────────{N}")

        # --- 3. STRUCTURE (THE BONES) ---
        loading("HEADER HIERARCHY")
        h1s = soup.find_all('h1')
        h2s = soup.find_all('h2')
        h3s = soup.find_all('h3')

        print(f"{G}────────────────────────────────────────{N}")
        if len(h1s) == 0:
            print(f"  H1 TAG   :: {R}[MISSING] Google is blind here.{N}")
        elif len(h1s) > 1:
            print(f"  H1 TAG   :: {R}[MULTIPLE] ({len(h1s)}) Confusing for bots.{N}")
        else:
            print(f"  H1 TAG   :: {C}{h1s[0].get_text().strip()[:40]}...{N}")

        print(f"  H2 TAGS  :: {W}{len(h2s)}{N} found")
        print(f"  H3 TAGS  :: {W}{len(h3s)}{N} found")
        print(f"{G}────────────────────────────────────────{N}")

        # --- 4. LINKS (THE BLOOD) ---
        loading("LINK PROFILE")
        links = soup.find_all('a', href=True)
        internal = 0
        external = 0
        domain = urlparse(url).netloc

        for l in links:
            href = l['href']
            if href.startswith('/') or domain in href:
                internal += 1
            elif href.startswith('http'):
                external += 1
        
        print(f"{G}────────────────────────────────────────{N}")
        print(f"  INTERNAL :: {W}{internal}{N} (Structure)")
        print(f"  EXTERNAL :: {W}{external}{N} (Outbound Juice)")
        print(f"  TOTAL    :: {Y}{len(links)}{N}")
        
        images = soup.find_all('img')
        missing_alt = sum(1 for img in images if not img.get('alt'))
        print(f"  IMAGES   :: {W}{len(images)}{N} Total")
        if missing_alt > 0:
             print(f"  ALT TEXT :: {R}{missing_alt} images missing description (Bad SEO){N}")
        else:
             print(f"  ALT TEXT :: {C}All Optimized{N}")
        print(f"{G}────────────────────────────────────────{N}")

        # --- 5. KEYWORD DENSITY (THE BRAIN) ---
        loading("SEMANTIC ANALYSIS")
        # Extract text, clean it, count words
        text = soup.get_text()
        words = clean_text(text).split()
        # Filter common stopwords (very basic list)
        stopwords = {'the', 'and', 'to', 'of', 'a', 'in', 'is', 'that', 'for', 'it', 'on', 'with', 'as', 'this', 'by', 'at', 'be', 'are', 'from', 'or', 'an', 'your', 'we', 'can', 'us', 'if'}
        filtered_words = [w for w in words if w not in stopwords and len(w) > 2]
        
        common = Counter(filtered_words).most_common(5)
        
        print(f"{G}────────────────────────────────────────{N}")
        print(f"  WORD COUNT :: {W}{len(words)}{N} (Recommend > 300)")
        print(f"  TOP KEYWORDS:{N}")
        for word, count in common:
            print(f"    - {Y}{word}{N}: {count} times")
        print(f"{G}────────────────────────────────────────{N}")

        # --- 6. SOCIAL SIGNALS (THE HYPE) ---
        loading("SOCIAL READY CHECK")
        og_title = soup.find('meta', property='og:title')
        og_image = soup.find('meta', property='og:image')
        
        if og_title and og_image:
            print(f"  {C}[OK]{N} SOCIAL CARDS ACTIVE")
            print(f"  IMG: {P}{og_image['content'][:50]}...{N}")
        else:
            print(f"  {R}[FAIL]{N} NO SOCIAL PREVIEW (Links look ugly on FB/Twitter)")
            
    except Exception as e:
        print(f"\n{R}[CRITICAL ERROR]{N} Could not analyze target: {e}")

# --- [ MAIN ] ---
def main():
    banner()
    print(f"{W}ENTER URL TO AUDIT (http/https):{N}")
    url = input(f"{R}>> {N}").strip()
    
    if not url.startswith("http"):
        url = "https://" + url
        
    analyze_seo(url)
    
    print(f"\n{G}[ PRESS ENTER ]{N}")
    input()

if __name__ == "__main__":
    main()

