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
    
    # Add the Wallpaper class only if it doesn't already exist
    if (-not ([System.Management.Automation.PSTypeName]'Wallpaper').Type) {
        Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        
        public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
            
            public static void SetWallpaper(string path) {
                SystemParametersInfo(20, 0, path, 0x01 | 0x02);
            }
        }
"@
    }
    
    # Set wallpaper style in registry
    $regPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $regPath -Name "WallpaperStyle" -Value $Style
    Set-ItemProperty -Path $regPath -Name "TileWallpaper" -Value 0
    
    # Set the wallpaper
    [Wallpaper]::SetWallpaper($Path)
}

# Set the wallpaper automatically
Write-Host "Setting wallpaper as desktop background..." -ForegroundColor Cyan
try {
    # Get the absolute path
    $absolutePath = Resolve-Path $WallpaperPath
    Set-Wallpaper -Path $absolutePath.Path
    Write-Host "Wallpaper set successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Error: Failed to set wallpaper: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You can manually set the wallpaper from: $WallpaperPath" -ForegroundColor Yellow
}

Write-Host "`nWallpaper setup completed!" -ForegroundColor Green
