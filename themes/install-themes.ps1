# install-themes.ps1
# Downloads and installs themes for Windows Terminal and other supported apps

$ErrorActionPreference = "Stop"

# Windows Terminal theme configuration
$ThemeUrl = "https://github.com/catppuccin/windows-terminal/raw/main/macchiato.json"
$ThemeFile = "macchiato.json"
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
        if (-not ($settings.PSObject.Properties.Name -contains "schemes")) {
            $settings | Add-Member -MemberType NoteProperty -Name "schemes" -Value @()
        }
        elseif ($null -eq $settings.schemes) {
            $settings.schemes = @()
        }
        
        # Check if theme already exists
        $existingTheme = $settings.schemes | Where-Object { $_.name -eq $theme.name }
        if ($existingTheme) {
            Write-Host "Theme '$($theme.name)' already exists in Windows Terminal." -ForegroundColor Yellow
        }
        else {
            # Add theme to schemes
            $settings.schemes += $theme
            
            # Apply theme to default profile
            $defaultProfileGuid = $settings.defaultProfile
            if ($defaultProfileGuid) {
                $defaultProfile = $settings.profiles.list | Where-Object { $_.guid -eq $defaultProfileGuid }
                if ($defaultProfile) {
                    if (-not ($defaultProfile.PSObject.Properties.Name -contains "colorScheme")) {
                        $defaultProfile | Add-Member -MemberType NoteProperty -Name "colorScheme" -Value $theme.name
                    }
                    else {
                        $defaultProfile.colorScheme = $theme.name
                    }
                    Write-Host "Applied theme '$($theme.name)' to default profile." -ForegroundColor Green
                }
                else {
                    Write-Host "Warning: Default profile not found, theme added to schemes only." -ForegroundColor Yellow
                }
            }
            else {
                Write-Host "Warning: No default profile specified, theme added to schemes only." -ForegroundColor Yellow
            }
            
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

Write-Host "`nTheme installation completed!" -ForegroundColor Green
