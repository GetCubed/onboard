# install-apps.ps1
# Installs applications using Windows Package Manager (Winget)

$ErrorActionPreference = "Stop"

# Check for internet connection
Write-Host "Checking internet connection..." -ForegroundColor Cyan
try {
    $null = Test-NetConnection -ComputerName "1.1.1.1" -Port 53 -InformationLevel Quiet
    Write-Host "Internet connection verified." -ForegroundColor Green
}
catch {
    Write-Host "Error: No internet connection detected. Please connect to the internet and try again." -ForegroundColor Red
    exit 1
}

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    try {
        if (Get-Command $Command -ErrorAction SilentlyContinue) {
            return $true
        }
        return $false
    }
    catch {
        return $false
    }
}

# Check for Windows Package Manager (winget)
Write-Host "Checking for Windows Package Manager (winget)..." -ForegroundColor Cyan
if (Test-Command "winget") {
    Write-Host "Winget is available." -ForegroundColor Green
}
else {
    Write-Host "Error: Winget not found." -ForegroundColor Red
    Write-Host "Please install Winget by:" -ForegroundColor Yellow
    Write-Host "1. Installing 'App Installer' from Microsoft Store, or" -ForegroundColor Yellow
    Write-Host "2. Downloading from: https://github.com/microsoft/winget-cli/releases" -ForegroundColor Yellow
    exit 1
}

# Define applications to install
$WingetApps = @(
    # Add your preferred applications here
    # Example: "7zip.7zip"
)

Write-Host "Installing applications using Winget..." -ForegroundColor Cyan
foreach ($app in $WingetApps) {
    try {
        Write-Host "Installing $app..." -ForegroundColor Yellow
        winget install --id $app --silent --accept-source-agreements --accept-package-agreements
        Write-Host "$app installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install $app. It may already be installed or unavailable." -ForegroundColor Yellow
    }
}

Write-Host "`nApplication installation completed!" -ForegroundColor Green
Write-Host "Note: Some applications may require a restart or new terminal session to be fully available." -ForegroundColor Yellow
