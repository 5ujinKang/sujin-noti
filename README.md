# sujin-noti

Two notification tools:

- **`secretary_monroe.sh`** — time-based sound alerts on a schedule (runs locally)
- **`job-notify-listen` + `remote-bashrc-snippet.sh`** — job-done notifications from remote machines (sound played locally)

Sound files live in `sounds/`.

---

## secretary_monroe.sh

Plays sounds at `:00` and `:50` each hour, boot greeting, and scheduled reminders (lunch, dinner, paper group, etc.).

```bash
bash secretary_monroe.sh
```

Starts `job-notify-listen` automatically as a subprocess (with auto-restart on crash).

---

## Job-done notifier

When a shell command or Claude task finishes on a remote machine, your local machine plays a sound or speaks the result.

Uses [ntfy.sh](https://ntfy.sh) as a relay — remote machines post a message, local machine subscribes and reacts.

### Architecture

```
remote machine
  └─ notify / alias claude → posts to ntfy.sh topic
                                    ↓
                              ntfy.sh (relay)
                                    ↓
local machine
  └─ job-notify-listen → plays mp3 / espeak-ng TTS + desktop notification
```

---

## Local machine setup

The listener is started automatically by `secretary_monroe.sh`. To run it standalone:

```bash
job-notify-listen
```

### Claude Code hook (for local Claude sessions)

Add to `~/.claude/settings.json` to get notified when Claude finishes each response:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "curl -s -H \"Title: $(uname -n)\" -d \"[claude] ✓ finished\" \"https://ntfy.sh/claude-done-73147a89\" > /dev/null"
          }
        ]
      }
    ]
  }
}
```

### Per-host sounds

`job-notify-listen` plays `sounds/local_claude.mp3` by default for `[claude]` messages. To use a different sound for a specific host, edit `CLAUDE_SOUND_BY_HOST` near the top of the script:

```python
CLAUDE_SOUND_BY_HOST = {
    "thoth": os.path.expanduser("~/Downloads/thoth_claude.mp3"),
}
```

---

## Remote machine setup

```bash
# 1. clone the repo
git clone git@github.com:5ujinKang/sujin-noti.git ~/sujin-noti

# 2. add to ~/.bashrc  (shell command wrapper)
echo "source ~/sujin-noti/remote-bashrc-snippet.sh" >> ~/.bashrc
source ~/.bashrc

# 3. install the Claude Code Stop hook  (interactive sessions)
bash ~/sujin-noti/remote-claude-hook-setup.sh
```

Step 2 covers one-shot commands (`notify make build`, `claude train.py`, etc.).  
Step 3 covers interactive Claude Code sessions — every time Claude finishes a response, your local machine plays the sound.

### Set the server name

Edit `_NOTIFY_HOST` at the top of `~/sujin-noti/remote-bashrc-snippet.sh`:

```bash
_NOTIFY_HOST="Thoth"      # on thoth
_NOTIFY_HOST="Server03"   # on server03
_NOTIFY_HOST="Ginkgo01"   # on ginkgo01
```

The Claude Code hook uses `$(hostname)` automatically — no extra config needed.

### Keep it updated

```bash
cd ~/sujin-noti && git pull && source ~/.bashrc
```

---

## Usage on remote machines

| Command | Local reaction |
|---|---|
| `notify make build` | speaks "make is done" |
| `notify python train.py` | speaks "python is done" |
| `notify ./script.sh` | speaks "shell is done" |
| `claude ...` | plays claude sound (aliased automatically) |
| Claude Code session | plays claude sound (via Stop hook) |

`claude` is aliased to `notify claude` automatically — no extra typing needed for one-shot runs.  
For interactive Claude Code, the Stop hook fires on every completed response.

For any other command, wrap it with `notify`:

```bash
notify ./long-running-script.sh
notify rsync -av /src /dst
```

---

## Adding a new task type

Edit the `case` block in `remote-bashrc-snippet.sh`:

```bash
case "$1" in
    claude)          task="claude" ;;
    python|python3)  task="python" ;;
    make|cmake)      task="make" ;;
    cargo)           task="cargo" ;;   # ← add here
esac
```

Commit and `git pull` on all machines.
