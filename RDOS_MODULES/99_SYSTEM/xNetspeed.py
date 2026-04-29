import sys
import subprocess
import time
import os

# --- DAN SYSTEM-CHECK & AUTO-INSTALL ---
def check_dependencies():
    print("\n[SYSTEM] Überprüfe Abhängigkeiten...")
    try:
        import speedtest
        print("[SYSTEM] Module gefunden. Zugriff gewährt.")
        return speedtest
    except ImportError:
        print("[WARNUNG] Kern-Modul 'speedtest-cli' fehlt.")
        print("[SYSTEM] Initiiere Auto-Installation via PIP...")
        try:
            # Ruft pip als Subprozess auf, um die Installation durchzuführen
            subprocess.check_call([sys.executable, "-m", "pip", "install", "speedtest-cli"])
            print("[SYSTEM] Installation erfolgreich. Re-Initialisierung...")
            import speedtest
            return speedtest
        except Exception as e:
            print(f"[FATAL ERROR] Auto-Installation gescheitert: {e}")
            input("Drücke Enter zum Beenden...")
            sys.exit()

# Lade Modul (oder installiere es, falls nötig)
st_module = check_dependencies()

# --- ANIMATIONEN ---
def animierte_ladeanzeige(text, duration=2):
    end_time = time.time() + duration
    chars = "/—\|" 
    i = 0
    while time.time() < end_time:
        sys.stdout.write(f'\r{text} ' + chars[i % len(chars)])
        sys.stdout.flush()
        time.sleep(0.1)
        i += 1
    sys.stdout.write('\r' + ' ' * (len(text)+2) + '\r')

def format_speed(speed):
    return f"{speed / 1_000_000:.2f} Mbit/s"

# --- HAUPTPROGRAMM ---
def run_dan_speedtest():
    print("\n" + "█"*40)
    print("   DAN ECHTZEIT-BANDBREITEN-SCAN   ")
    print("█"*40 + "\n")

    try:
        st = st_module.Speedtest()
        
        # Server Wahl
        sys.stdout.write(">> [NETZWERK] Trianguliere besten Knoten...")
        animierte_ladeanzeige(">> [NETZWERK] Trianguliere besten Knoten...")
        best_server = st.get_best_server()
        print(f"[VERBUNDEN] Host: {best_server['host']} | Ping: {best_server['latency']} ms")

        # Download
        print(">> [DATENSTROM] Messe Downstream...")
        animierte_ladeanzeige(">> [DOWNLOAD] Sättige Leitung...", 3)
        d_speed = st.download()
        print(f">> [ERGEBNIS] DOWNLOAD: {format_speed(d_speed)}")

        # Upload
        print(">> [DATENSTROM] Messe Upstream...")
        animierte_ladeanzeige(">> [UPLOAD] Sende Testpakete...", 3)
        u_speed = st.upload()
        print(f">> [ERGEBNIS] UPLOAD:   {format_speed(u_speed)}")

        print("\n" + "█"*40)
        print("           SCAN ABGESCHLOSSEN           ")
        print("█"*40 + "\n")

    except Exception as e:
        print(f"\n[FEHLER] Verbindung unterbrochen: {e}")

if __name__ == "__main__":
    run_dan_speedtest()
    input("Drücke Enter, um das Terminal zu schließen...")
