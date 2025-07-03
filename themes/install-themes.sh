#!/bin/zsh
# install-themes.sh
# Downloads and installs themes for macOS Terminal.app and other supported apps

# Catppuccin Macchiato for Terminal.app
THEME_URL="https://github.com/catppuccin/Terminal.app/raw/main/themes/catppuccin-macchiato.terminal"
THEME_FILE="catppuccin-macchiato.terminal"
DOWNLOADS_DIR="$(cd "$(dirname "$0")/../downloads/themes" && pwd)"

mkdir -p "$DOWNLOADS_DIR"

# Check if theme already exists
if [ -f "$DOWNLOADS_DIR/$THEME_FILE" ]; then
  echo "Theme already exists: $DOWNLOADS_DIR/$THEME_FILE"
else
  echo "Downloading Catppuccin Macchiato theme for Terminal.app..."
  if ! curl -fL -o "$DOWNLOADS_DIR/$THEME_FILE" "$THEME_URL"; then
    echo "Error: Failed to download theme from $THEME_URL" >&2
    echo "Please check your internet connection or try again later." >&2
    exit 1
  fi
  echo "Theme downloaded: $DOWNLOADS_DIR/$THEME_FILE"
fi

echo "Opening theme to import into Terminal.app..."
open "$DOWNLOADS_DIR/$THEME_FILE"

echo "Done! Select 'Catppuccin Macchiato' in Terminal.app Preferences > Profiles."

# Add more theme installation steps below as needed
