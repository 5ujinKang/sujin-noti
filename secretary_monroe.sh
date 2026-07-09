#!/usr/bin/env bash
#
# time_notify.sh
#
# Boot greeting: good_morning/afternoon/evening once per block, welcomeback otherwise
#
# writer: Sujin Kang

LOCKFILE="/tmp/secretary_monroe.lock"
if [[ -f $LOCKFILE ]] && kill -0 "$(cat "$LOCKFILE")" 2>/dev/null; then
    echo "Monroe is already running (PID $(cat "$LOCKFILE"))."
    exit 1
fi
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

SOUNDS="$BASE_DIR/sounds"
GOOD_MORNING="$SOUNDS/good_morning.mp3"
GOOD_AFTERNOON="$SOUNDS/good_afternoon.mp3"
GOOD_EVENING="$SOUNDS/good_evening.mp3"
WELCOMEBACK="$SOUNDS/welcomeback.mp3"

print_info() {
    local C="\033[38;2;57;255;20m" R="\033[0m"
    printf "$C"
    img << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║  ███╗   ███╗ ██████╗ ███╗   ██╗██████╗  ██████╗ ███████╗     ║
║  ████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔═══██╗██╔════╝     ║
║  ██╔████╔██║██║   ██║██╔██╗ ██║██████╔╝██║   ██║█████╗       ║
║  ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══██╗██║   ██║██╔══╝       ║
║  ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝███████╗     ║
║  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ║
║                                                              ║
║            Executive Assistant Daemon Initialized            ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝


⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⢀⣠⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⣠⣴⣾⣿⡽⠟⠛⠻⣶⣄⠀⢀⣐⣒⣒⣶⣴⣾⡿⢷⣶⣽⡢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⢀⡾⣿⣿⢿⠋⠀⠀⠀⠀⠀⠉⠛⠓⠒⠛⠚⠛⠉⣿⠀⠀⣧⡏⠻⣷⣽⡦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⢀⣻⡾⠋⣇⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠉⠀⠀⢸⠙⠻⣿⣷⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀    ⠀⣠⣶⣿⠋⠈⠀⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠈⡿⣷⣽⣇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀    ⢀⣞⡿⠟⣟⠀⠀⠀⠀⠀⠀⠀⠀⠸⡆⠀⠀⠀⣆⠀⠀⡀⢸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠈⠻⣯⡳⣄⠀⠀⠀⠀⠀
⠀⠀⠀⠀    ⢀⣽⠟⠁⠀⠘⠃⠀⠀⠀⠀⢰⡀⠀⠀⢹⡀⠀⠀⢸⡄⢀⣇⡾⣠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣾⣅⠀⠀⠀⠀
    ⣀⣀⣠⡴⠿⣅⠐⢦⡀⠀⠀⠀⠲⣄⠀⠀⣙⣦⣶⣾⣻⣶⣶⠾⠿⠾⢿⣿⣿⣻⢷⣢⢤⣀⠀⠀⠀⠀⠀⠀⠀⡀⠀⣴⠛⣿⣷⣄⡀⠀
    ⠹⠿⢿⣷⣦⣼⣷⣤⣻⣶⣤⣀⣀⣬⣷⡯⠷⠾⢿⣿⣭⣄⣀⣀⣀⣀⣀⣤⣭⡿⠿⢾⣿⣿⣿⣦⣤⣤⣤⣶⢾⡷⣿⣷⣾⣷⣿⡿⠿⠟
    ⠀⠀⠘⣿⡝⣿⡿⢻⣿⡿⢩⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠰⡄⠀⠀⠀⠀⠘⢦⠹⣮⢷⠹⣷⣿⠀⠀⠀
    ⠀⠀⠀⠙⣷⣿⠁⡞⣾⠀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⡇⠀⠀⠀⠀⠀⢸⡆⢸⢸⣦⡟⠁⠀⠀⠀
⠀    ⠀⠀⠀⠈⢻⣄⡏⣿⠀⡇⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⢐⣧⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⣼⡇⠘⣼⠏⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀    ⠀⠙⠻⣧⣧⢣⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠸⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢹⣠⡾⠃⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀    ⠈⠛⢿⣧⡘⣆⠀⠀⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⣴⣷⣿⡋⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⠈⠙⠻⠷⣤⣀⣹⣄⠀⠀⠀⠀⠀⠀⡇⠀⠀⢀⠀⡆⠀⠀⣀⣴⣧⣴⣟⠯⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⠀⠈⠽⠿⠿⠷⠶⢤⣤⣴⣿⣦⣶⣾⣿⣷⣾⣻⣿⠝⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀    ⠀⠀⠈⠉⠉⠉⠉⠛⠛⠛⠛⠛⠊⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

┌────────────────────────────────────────────────────────────┐
│ MONROE CONFIGURATION                                       │
├────────────────────────────────────────────────────────────┤
│                                                            │
│ Greeting          : RUNNING ●                              │
│ Job Notifier      : RUNNING ●                              │
└────────────────────────────────────────────────────────────┘
EOF
    printf "$R"
}

img() { cat "$@"; }

play_mp3() { mpg123 -q "$1" >/dev/null 2>&1 & }

boot_greet() {
    local hour today block sound flag
    hour=$(date +%-H)
    today=$(date +%Y%m%d)

    if   (( hour >= 5  && hour < 12 )); then block=morning;   sound=$GOOD_MORNING
    elif (( hour >= 12 && hour < 17 )); then block=afternoon; sound=$GOOD_AFTERNOON
    elif (( hour >= 17 && hour < 22 )); then block=evening;   sound=$GOOD_EVENING
    else play_mp3 "$WELCOMEBACK"; return
    fi

    flag="/tmp/boot_greet_${block}_${today}"
    if [[ ! -f $flag ]]; then
        touch "$flag"
        play_mp3 "$sound"
    else
        play_mp3 "$WELCOMEBACK"
    fi
}

"$BASE_DIR/job-notify-listen" > /dev/null 2>&1 &
NOTIFY_PID=$!
trap "kill $NOTIFY_PID 2>/dev/null" EXIT

print_info
boot_greet

wait "$NOTIFY_PID"
