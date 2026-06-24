# sujin-noti

Two notification tools:

- **`time_notify.py`** — time-based sound alerts on a schedule (runs locally)
- **`job-notify-listen` + `remote-bashrc-snippet.sh`** — job-done TTS notifications from remote machines

---

## time_notify.py

Plays a sound at specific times. No goddamn notifier on the web supports:
1. Sound only (not an alarm you have to dismiss)
2. Multiple notifiers
3. Configurable days / sleep hours

This does.

```bash
./time_notify.py
```

---

## Job-done notifier

When a shell command or Claude task finishes on a remote machine, your local machine speaks **"Thoth, Claude is done"** or **"Thoth, Shell is done"**.

Uses [ntfy.sh](https://ntfy.sh) as a relay — remote machines post a message, local machine subscribes and plays TTS.

### Architecture

```
remote machine
  └─ notify / alias claude → posts to ntfy.sh topic
                                    ↓
                              ntfy.sh (relay)
                                    ↓
local machine
  └─ job-notify-listen → espeak-ng TTS + desktop notification
```

---

## Local machine setup

The listener is at `~/.local/bin/job-notify-listen`. Run it in a persistent tmux pane or add to autostart:

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

| Command | Spoken notification |
|---|---|
| `notify make build` | "Thoth, Shell is done" |
| `notify python train.py` | "Thoth, Python is done" |
| `notify make all` | "Thoth, Make is done" |
| `claude ...` | "Thoth, Claude is done" (aliased automatically) |

`claude` is aliased to `notify claude` automatically — no extra typing needed.

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
