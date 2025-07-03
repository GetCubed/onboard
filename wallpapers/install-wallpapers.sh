#!/bin/zsh
# install-wallpapers.sh
# Downloads a wallpaper from Wallhaven and sets it as the desktop background on all displays (macOS)

# Wallpaper info
WALLPAPER_URL="https://w.wallhaven.cc/full/o5/wallhaven-o5jv65.jpg"
WALLPAPER_PAGE="https://whvn.cc/o5jv65"
WALLPAPER_FILE="wallhaven-o5jv65.jpg"
DOWNLOADS_DIR="$(cd "$(dirname "$0")/../downloads/wallpapers" && pwd)"
TAGS="catppuccin digital art street art work building alleyway trees vending machine"

mkdir -p "$DOWNLOADS_DIR"

# Check if wallpaper already exists
if [ -f "$DOWNLOADS_DIR/$WALLPAPER_FILE" ]; then
  echo "Wallpaper already exists: $DOWNLOADS_DIR/$WALLPAPER_FILE"
else
  echo "Downloading wallpaper..."
  if ! curl -fL -o "$DOWNLOADS_DIR/$WALLPAPER_FILE" "$WALLPAPER_URL"; then
    echo "Error: Failed to download wallpaper from $WALLPAPER_URL" >&2
    echo "Please check your internet connection or try again later." >&2
    exit 1
  fi
  echo "Wallpaper downloaded: $DOWNLOADS_DIR/$WALLPAPER_FILE"
fi

echo "Source page: $WALLPAPER_PAGE"
echo "Tags: $TAGS"

# Set wallpaper on all displays (macOS only)
# Uses AppleScript to set the wallpaper for all desktops
osascript <<EOF
set wallpaperPath to (POSIX file "$DOWNLOADS_DIR/$WALLPAPER_FILE") as alias
try
    tell application "System Events"
        set theDesktops to a reference to every desktop
        repeat with aDesktop in theDesktops
            set picture of aDesktop to (wallpaperPath as text)
        end repeat
    end tell
end try
EOF

echo "Wallpaper applied to all displays."
