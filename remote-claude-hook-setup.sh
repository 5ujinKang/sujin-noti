#!/usr/bin/env bash
# Set up the Claude Code Stop hook on this remote machine.
# Run once after cloning the repo:
#   bash ~/sujin-noti/remote-claude-hook-setup.sh
#
# Each time Claude Code finishes a response, it posts to ntfy.sh so your
# local job-notify-listen plays the sound.

set -euo pipefail

TOPIC="claude-done-73147a89"
SETTINGS="$HOME/.claude/settings.json"

HOOK_CMD="curl -s -H \"Title: \$(hostname)\" -d \"[claude] ✓ finished\" \"https://ntfy.sh/${TOPIC}\" > /dev/null"

mkdir -p "$(dirname "$SETTINGS")"

if [[ ! -f "$SETTINGS" ]]; then
    cat > "$SETTINGS" <<EOF
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${HOOK_CMD}"
          }
        ]
      }
    ]
  }
}
EOF
    echo "Created $SETTINGS with Stop hook."
else
    # Merge into existing settings without clobbering other keys.
    if ! command -v jq &>/dev/null; then
        echo "Error: jq is required. Install it (e.g. apt install jq) and rerun."
        exit 1
    fi

    MERGED=$(jq --arg cmd "$HOOK_CMD" '
        .hooks.Stop //= [] |
        .hooks.Stop += [{
            "hooks": [{
                "type": "command",
                "command": $cmd
            }]
        }]
    ' "$SETTINGS")

    echo "$MERGED" > "$SETTINGS"
    echo "Merged Stop hook into existing $SETTINGS."
fi

echo "Done. Claude Code on $(hostname) will now notify your local machine."
