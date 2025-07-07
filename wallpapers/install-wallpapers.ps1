# install-wallpapers.ps1
# Downloads wallpapers and optionally sets them as desktop background on Windows

$ErrorActionPreference = "Stop"

# Wallpaper info
$WallpaperUrl = "https://w.wallhaven.cc/full/o5/wallhaven-o5jv65.jpg"
$WallpaperPage = "https://whvn.cc/o5jv65"
$WallpaperFile = "wallhaven-o5jv65.jpg"
$DownloadsDir = Join-Path $PSScriptRoot "..\downloads\wallpapers"
$Tags = "catppuccin digital art street art work building alleyway trees vending machine"

# Create downloads directory if it doesn't exist
if (-not (Test-Path $DownloadsDir)) {
    New-Item -ItemType Directory -Path $DownloadsDir -Force | Out-Null
}

$WallpaperPath = Join-Path $DownloadsDir $WallpaperFile

# Check if wallpaper already exists
if (Test-Path $WallpaperPath) {
    Write-Host "Wallpaper already exists: $WallpaperPath" -ForegroundColor Yellow
}
else {
    Write-Host "Downloading wallpaper..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $WallpaperUrl -OutFile $WallpaperPath -UseBasicParsing
        Write-Host "Wallpaper downloaded successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Error: Failed to download wallpaper from $WallpaperUrl" -ForegroundColor Red
        Write-Host "Please check your internet connection or try again later." -ForegroundColor Red
        exit 1
    }
}

Write-Host "Wallpaper page: $WallpaperPage" -ForegroundColor Cyan
Write-Host "Tags: $Tags" -ForegroundColor Cyan

# Function to set wallpaper on Windows
function Set-Wallpaper {
    param(
        [string]$Path,
        [int]$Style = 2  # 0=Center, 1=Tile, 2=Stretch, 3=Fit, 4=Fill, 5=Span
    )
    
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        
        public static void SetWallpaper(string path) {
            SystemParametersInfo(20, 0, path, 3);
        }
    }
"@
    
    # Set wallpaper style in registry
    $regPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $regPath -Name "WallpaperStyle" -Value $Style
    Set-ItemProperty -Path $regPath -Name "TileWallpaper" -Value 0
    
    # Set the wallpaper
    [Wallpaper]::SetWallpaper($Path)
}

# Ask user if they want to set the wallpaper
$response = Read-Host "Do you want to set this wallpaper as your desktop background? [y/N]"
if ($response -match "^[Yy]$") {
    Write-Host "Setting wallpaper as desktop background..." -ForegroundColor Cyan
    try {
        # Get the absolute path
        $absolutePath = Resolve-Path $WallpaperPath
        Set-Wallpaper -Path $absolutePath.Path -Style 4  # Fill style
        Write-Host "Wallpaper set successfully!" -ForegroundColor Green
        Write-Host "Note: You may need to refresh your desktop (F5) to see the changes." -ForegroundColor Yellow
    }
    catch {
        Write-Host "Error: Failed to set wallpaper: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "You can manually set the wallpaper from: $WallpaperPath" -ForegroundColor Yellow
    }
}
else {
    Write-Host "Wallpaper downloaded but not set as background." -ForegroundColor Yellow
    Write-Host "You can manually set it from: $WallpaperPath" -ForegroundColor Cyan
}

Write-Host "`nWallpaper setup completed!" -ForegroundColor Green
