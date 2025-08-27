#!/bin/bash
# Installer/Uninstaller for auto git-pull cron job

usage() {
  echo "Usage: $0 [--remove]"
  exit 1
}

if [ "$1" == "--remove" ]; then
  echo "🗑 Removing auto-pull cron job..."
  crontab -l | grep -v "git-auto-pull.sh" | crontab -
  echo "✅ Cron job removed"
  exit 0
fi

echo "🚀 Auto Git-Pull Installer"

# 1. Ask for repo path
read -rp "Enter the full path to your repo: " REPO_PATH
if [ ! -d "$REPO_PATH/.git" ]; then
  echo "❌ Error: $REPO_PATH is not a Git repo."
  exit 1
fi

# 2. Ask for time
read -rp "Enter the time to run daily (HH:MM, 24hr): " TIME
HOUR=$(echo $TIME | cut -d: -f1)
MIN=$(echo $TIME | cut -d: -f2)

# 3. Create the auto-pull script inside the repo
SCRIPT_PATH="$REPO_PATH/git-auto-pull.sh"

cat <<'EOF' > "$SCRIPT_PATH"
#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit 1

echo "===== Sync at $(date) =====" >> "$SCRIPT_DIR/git-auto-pull.log"
git fetch --all >> "$SCRIPT_DIR/git-auto-pull.log" 2>&1
git reset --hard origin/main >> "$SCRIPT_DIR/git-auto-pull.log" 2>&1
EOF

chmod +x "$SCRIPT_PATH"

# 4. Add cron job
(crontab -l 2>/dev/null; echo "$MIN $HOUR * * * /bin/bash $SCRIPT_PATH") | crontab -

echo "✅ Installer complete!"
echo "➡️ Script saved at: $SCRIPT_PATH"
echo "➡️ Cron job added: $TIME every day"