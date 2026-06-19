# ── remote job notifier ──────────────────────────────────────────────────────
# Paste this into ~/.bashrc on each remote machine.
# Usage:
#   notify <command>          e.g.  notify make build
#   notify claude run task    wraps any command, posts result when done
#
# Also aliases 'claude' so every Claude CLI run auto-notifies.

_NOTIFY_TOPIC="claude-done-73147a89"
_NOTIFY_URL="https://ntfy.sh/${_NOTIFY_TOPIC}"

notify() {
    local cmd_display="${*:0:80}"
    eval "$@"
    local status=$?
    local icon="${status:+✗}"
    [ "$status" -eq 0 ] && icon="✓"
    local host
    host=$(hostname -s)
    curl -s \
        -H "Title: ${host}" \
        -d "${icon} [exit ${status}] ${cmd_display}" \
        "$_NOTIFY_URL" > /dev/null &
    return "$status"
}

# Auto-notify every Claude CLI invocation
alias claude='notify claude'
# ─────────────────────────────────────────────────────────────────────────────
