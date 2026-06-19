# ── remote job notifier ──────────────────────────────────────────────────────
# Paste this into ~/.bashrc on each remote machine.
# Set _NOTIFY_HOST to a friendly name for this machine.
# Usage:
#   notify <command>       e.g.  notify make build
#   claude ...             auto-notified via alias

_NOTIFY_TOPIC="claude-done-73147a89"
_NOTIFY_URL="https://ntfy.sh/${_NOTIFY_TOPIC}"
_NOTIFY_HOST="Thoth"   # <-- change per machine (e.g. "Server03", "Ginkgo01")

notify() {
    # detect task type from the first token of the command
    local task="shell"
    case "$1" in
        claude) task="claude" ;;
        python|python3) task="python" ;;
        make|cmake) task="make" ;;
    esac

    eval "$@"
    local status=$?
    local icon="✓"
    [ "$status" -ne 0 ] && icon="✗"

    curl -s \
        -H "Title: ${_NOTIFY_HOST}" \
        -d "[${task}] ${icon} exit ${status}: ${*:0:60}" \
        "$_NOTIFY_URL" > /dev/null &
    return "$status"
}

alias claude='notify claude'
# ─────────────────────────────────────────────────────────────────────────────
