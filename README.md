# onboard

Welcome to my personal onboarding repository! This repo is my toolkit for setting up a new development environment on any PC. Whenever I get a new machine, I just clone this repo to bring in all the things that make my workflow comfortable and productive.

## What I keep here

- Wallpapers I like
- Apps and scripts to automate setup and configuration
- Terminal and app themes
- Bookmarks for browsers
- Handy code snippets
- Any other files or resources I want quick access to

## Why I made this

Setting up a new computer can be tedious. With this repo, I can skip the repetitive steps and get straight to work. Everything I need is in one place, ready to go.

## How I use it

### macOS/Linux (zsh/bash)
1. Open a terminal running zsh or bash.
2. Clone this repository:
   ```bash
   git clone https://github.com/getcubed/onboard.git
   ```
3. Run the main setup script to automate onboarding:
   ```bash
   ./onboard-setup.sh
   ```
   - By default, this runs all setup scripts (apps, themes, wallpapers).
   - You can also run `./onboard-setup.sh select` to choose which scripts to run interactively.

### Windows (PowerShell)
1. Open PowerShell (preferably as Administrator for app installations).
2. Clone this repository:
   ```powershell
   git clone https://github.com/getcubed/onboard.git
   ```
3. Run the main setup script to automate onboarding:
   ```powershell
   .\onboard-setup.ps1
   ```
   - By default, this runs all setup scripts (apps, themes, wallpapers).
   - You can also run `.\onboard-setup.ps1 select` to choose which scripts to run interactively.

4. Add new files or update existing ones as my preferences change.

## Folder structure

- `apps/` – My setup and automation scripts (e.g., Homebrew apps on macOS, Winget/Chocolatey on Windows)
- `themes/` – Terminal and app themes, plus install scripts
- `wallpapers/` – My favorite backgrounds and wallpaper scripts
- `bookmarks/` – Browser bookmarks
- `snippets/` – Code snippets and utilities
- `onboard-setup.sh` – Main script to run all setup scripts (macOS/Linux)
- `onboard-setup.ps1` – Main script to run all setup scripts (Windows)
- `README.md` – This file

I update and reorganize these folders as needed.

---

This repo is for my own use, but if you find it helpful, feel free to take ideas!
