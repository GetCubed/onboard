#!/bin/zsh
# onboard-setup.sh
# Runs all setup scripts in the repo, or lets you select which ones to run.

set -e

SCRIPTS=(
  "apps/install-apps.sh"
  "themes/install-themes.sh"
  "wallpapers/install-wallpapers.sh"
)

FAILED_SCRIPTS=()

usage() {
  echo "Usage: $0 [all|select]"
  echo "  all    - Run all setup scripts (default)"
  echo "  select - Choose which scripts to run interactively"
  exit 1
}

run_script() {
  local script="$1"
  if [ -f "$script" ]; then
    chmod +x "$script"
    if [ -x "$script" ]; then
      echo "\n--- Running $script ---"
      if ! "$script"; then
        echo "[Error] $script failed. Skipping to next script." >&2
        FAILED_SCRIPTS+=("$script")
      fi
    else
      echo "\n[Warning] $script is not executable after chmod. Skipping."
      FAILED_SCRIPTS+=("$script (chmod failed)")
    fi
  else
    echo "\n[Warning] $script is not found. Skipping."
    FAILED_SCRIPTS+=("$script (not found)")
  fi
}

if [ "$1" = "select" ]; then
  echo "Select which scripts to run (y/n):"
  for script in "${SCRIPTS[@]}"; do
    read "_run?Run $script? [y/N]: "
    if [[ "$_run" =~ ^[Yy]$ ]]; then
      run_script "$script"
    else
      echo "Skipping $script."
    fi
  done
else
  for script in "${SCRIPTS[@]}"; do
    run_script "$script"
  done
fi

echo "\nAll selected setup scripts completed."

if [ ${#FAILED_SCRIPTS[@]} -ne 0 ]; then
  echo "\nThe following scripts failed or were skipped:"
  for failed in "${FAILED_SCRIPTS[@]}"; do
    echo "  - $failed"
  done
else
  echo "\nAll scripts ran successfully."
fi
