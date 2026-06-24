#!/usr/bin/env bash
#
# time_notify.sh
#
# Play a notification sound at :00 and :50
# Boot greeting: good_morning/afternoon/evening once per block, welcomeback otherwise
#
# writer: Sujin Kang

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

SOUNDS="$BASE_DIR/sounds"
SOUND_00="$SOUNDS/page_00.wav"
SOUND_50="$SOUNDS/noti_50.wav"
LUNCH_SOUND="$SOUNDS/lunch.mp3"
DINNER_SOUND="$SOUNDS/dinner.mp3"
GOOD_MORNING="$SOUNDS/good_morning.mp3"
GOOD_AFTERNOON="$SOUNDS/good_afternoon.mp3"
GOOD_EVENING="$SOUNDS/good_evening.mp3"
WELCOMEBACK="$SOUNDS/welcomeback.mp3"
DAY_END_SOUND="$SOUNDS/day-end.mp3"
LAB_LUNCH_SOUND="$SOUNDS/lab-lunch.mp3"
PAPER_GROUP_SOUND="$SOUNDS/paper-group.mp3"

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
│ Time Notificator  : RUNNING ●                              │
│ ├─ Active Days    : Mon Tue Wed Thu Fri Sat Sun            │
│ ├─ Active Hours   : 00:00 - 23:59                          │
│ └─ Ring Minutes   : 00, 50                                 │
│                                                            │
│ Greeting          : RUNNING ●                              │
│ Job Notifier      : RUNNING ●                              │
│ Schedules         : RUNNING ●                              │
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

(while true; do job-notify-listen; sleep 2; done) &
NOTIFY_PID=$!
trap "kill $NOTIFY_PID 2>/dev/null" EXIT

print_info
boot_greet

last_played=""
while true; do
    minute=$(date +%-M)
    hour=$(date +%-H)

    if (( minute == 0 )) && [[ $last_played != 0 ]]; then
        paplay "$SOUND_00" >/dev/null 2>&1 &
        last_played=0
    elif (( minute == 50 )) && [[ $last_played != 50 ]]; then
        if   (( hour == 11 )); then play_mp3 "$LUNCH_SOUND"
        elif (( hour == 16 )); then play_mp3 "$DINNER_SOUND"
        elif (( hour == 19 )); then play_mp3 "$DAY_END_SOUND"
        else paplay "$SOUND_50" >/dev/null 2>&1 &
        fi
        last_played=50
    elif (( minute == 55 )) && [[ $last_played != 55 ]]; then
        dow=$(date +%u)
        if   (( hour == 8  && dow == 4 )); then play_mp3 "$PAPER_GROUP_SOUND"
        elif (( hour == 11 && dow == 5 )); then play_mp3 "$LAB_LUNCH_SOUND"
        fi
        last_played=55
    fi

    sleep 1
done
