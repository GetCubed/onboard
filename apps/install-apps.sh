#!/bin/zsh
# install-apps.sh
# Installs all Homebrew apps and formulae listed in this folder's README

set -e

# Check for internet connection
if ! ping -c 1 1.1.1.1 >/dev/null 2>&1; then
  echo "Error: No internet connection detected. Please connect to the internet and try again." >&2
  exit 1
fi

# Install Homebrew if not installed
echo "Checking for Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

echo "Updating Homebrew..."
brew update

# Install formulae
echo "Installing Homebrew formulae..."
brew install -q --formula gh

# Install cask apps
echo "Installing Homebrew cask apps..."
brew install -q --cask discord logi-options+ rectangle visual-studio-code gog-galaxy microsoft-edge steam

echo "All apps installed!"
