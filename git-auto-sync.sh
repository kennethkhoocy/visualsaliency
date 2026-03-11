#!/bin/bash
REPO_DIR="/volume1/HomeNetwork/Main/VisualSaliency"
INOTIFY="/opt/bin/inotifywait"
cd "$REPO_DIR" || exit 1
while true; do
    $INOTIFY -r -e modify,create,delete,move --exclude '\.git|git-sync\.log|git-auto-sync\.sh' "$REPO_DIR"
    # Brief pause to let Cloud Sync finish writing
    sleep 5
    if [ -n "$(git status --porcelain)" ]; then
        git add -A
        git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
        git push origin main
    fi
done
