# Apps Folder

This folder contains setup and automation scripts for onboarding a new machine.

## macOS Apps Installed by `install-apps.sh`

The following apps and formulae will be installed when I run `install-apps.sh`:

### Homebrew Formulae
- gh (GitHub CLI)

### Homebrew Cask Apps
- Discord
- Logi Options+
- Rectangle
- Visual Studio Code
- GOG Galaxy
- Microsoft Edge
- Steam

## Windows Apps Installed by `install-apps.ps1`

The following apps will be installed when I run `install-apps.ps1`:

### Core Development Tools
- Git
- Visual Studio Code
- PowerShell Core
- GitHub CLI
- Windows Terminal

The script will automatically detect and use the best available package manager:
1. **Winget** (Windows Package Manager) - preferred for Windows 10/11
2. **Chocolatey** - fallback option, automatically installed if needed

## Usage

### macOS/Linux
```bash
chmod +x install-apps.sh
./install-apps.sh
```

### Windows
```powershell
.\install-apps.ps1
```
