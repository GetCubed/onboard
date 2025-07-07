# install-themes.ps1
# Downloads and installs themes for Windows Terminal and other supported apps

$ErrorActionPreference = "Stop"

# Windows Terminal theme configuration
$ThemeUrl = "https://github.com/catppuccin/windows-terminal/raw/main/dist/catppuccin-macchiato.json"
$ThemeFile = "catppuccin-macchiato.json"
$DownloadsDir = Join-Path $PSScriptRoot "..\downloads\themes"
$WindowsTerminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Create downloads directory if it doesn't exist
if (-not (Test-Path $DownloadsDir)) {
    New-Item -ItemType Directory -Path $DownloadsDir -Force | Out-Null
}

$ThemeFilePath = Join-Path $DownloadsDir $ThemeFile

# Check if theme already exists
if (Test-Path $ThemeFilePath) {
    Write-Host "Theme already exists: $ThemeFilePath" -ForegroundColor Yellow
}
else {
    Write-Host "Downloading Catppuccin Macchiato theme for Windows Terminal..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $ThemeUrl -OutFile $ThemeFilePath -UseBasicParsing
        Write-Host "Theme downloaded successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Failed to download theme from $ThemeUrl" -ForegroundColor Red
        Write-Host "Please check your internet connection or try again later." -ForegroundColor Red
        exit 1
    }
}

# Install theme to Windows Terminal if it exists
if (Test-Path $WindowsTerminalSettingsPath) {
    Write-Host "Installing theme to Windows Terminal..." -ForegroundColor Cyan
    try {
        # Read the current settings
        $settings = Get-Content $WindowsTerminalSettingsPath -Raw | ConvertFrom-Json
        
        # Read the theme
        $theme = Get-Content $ThemeFilePath -Raw | ConvertFrom-Json
        
        # Initialize schemes array if it doesn't exist
        if (-not $settings.schemes) {
            $settings | Add-Member -MemberType NoteProperty -Name "schemes" -Value @()
        }
        
        # Check if theme already exists
        $existingTheme = $settings.schemes | Where-Object { $_.name -eq $theme.name }
        if ($existingTheme) {
            Write-Host "Theme '$($theme.name)' already exists in Windows Terminal." -ForegroundColor Yellow
        }
        else {
            # Add theme to schemes
            $settings.schemes += $theme
            
            # Save the updated settings
            $settings | ConvertTo-Json -Depth 10 | Set-Content $WindowsTerminalSettingsPath
            Write-Host "Theme '$($theme.name)' installed successfully to Windows Terminal." -ForegroundColor Green
            Write-Host "You can now select this theme in Windows Terminal settings." -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "Error: Failed to install theme to Windows Terminal: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You can manually import the theme from: $ThemeFilePath" -ForegroundColor Yellow
    }
}
else {
    Write-Host "Windows Terminal settings not found. Theme downloaded to: $ThemeFilePath" -ForegroundColor Yellow
    Write-Host "You can manually import this theme in Windows Terminal settings." -ForegroundColor Cyan
}

# PowerShell profile theme setup (optional)
$ProfileThemeUrl = "https://github.com/catppuccin/powershell/raw/main/themes/catppuccin-macchiato.omp.json"
$ProfileThemeFile = "catppuccin-macchiato.omp.json"
$ProfileThemePath = Join-Path $DownloadsDir $ProfileThemeFile

Write-Host "`nDownloading PowerShell profile theme..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $ProfileThemeUrl -OutFile $ProfileThemePath -UseBasicParsing
    Write-Host "PowerShell theme downloaded to: $ProfileThemePath" -ForegroundColor Green
    Write-Host "To use this theme with Oh My Posh, add the following to your PowerShell profile:" -ForegroundColor Cyan
    Write-Host "oh-my-posh init pwsh --config '$ProfileThemePath' | Invoke-Expression" -ForegroundColor Yellow
}
catch {
    Write-Host "Warning: Failed to download PowerShell profile theme. Skipping..." -ForegroundColor Yellow
}

Write-Host "`nTheme installation completed!" -ForegroundColor Green
