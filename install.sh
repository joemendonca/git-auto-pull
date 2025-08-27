#!/bin/bash

echo "Auto Git-Pull Installer"

# Detect repo path automatically
REPO_PATH=$(pwd)

# Confirm it's a Git repo
if [ ! -d "$REPO_PATH/.git" ]; then
  echo "Error: $REPO_PATH is not a Git repo."
  exit 1
fi

echo "Found Git repo at $REPO_PATH"

# Ask install or uninstall
read -p "Do you want to [i]nstall or [u]ninstall the cron job? " choice

if [[ "$choice" == "u" ]]; then
  crontab -l | grep -v "cd $REPO_PATH && git pull" | crontab -
  echo "Cron job uninstalled."
  exit 0
fi

if [[ "$choice" != "i" ]]; then
  echo "Invalid choice. Exiting."
  exit 1
fi

# Ask for schedule
read -p "Enter the time for the daily pull (HH:MM, 24h format): " TIME

# Validate time format
if [[ ! "$TIME" =~ ^([01]?[0-9]|2[0-3]):([0-5][0-9])$ ]]; then
  echo "Invalid time format. Use HH:MM (24h). Example: 05:00"
  exit 1
fi

HOUR=$(echo $TIME | cut -d: -f1 | sed 's/^0*//')
MINUTE=$(echo $TIME | cut -d: -f2 | sed 's/^0*//')

# Default to 0 if empty
if [ -z "$HOUR" ]; then HOUR=0; fi
if [ -z "$MINUTE" ]; then MINUTE=0; fi

# Add to crontab
( crontab -l 2>/dev/null; echo "$MINUTE $HOUR * * * cd $REPO_PATH && git pull >> /tmp/git-pull.log 2>&1" ) | crontab -

echo "Cron job installed to run daily at $TIME"