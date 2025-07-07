# onboard-setup.ps1
# Runs all setup scripts in the repo, or lets you select which ones to run.
# Windows PowerShell version

param(
    [string]$Mode = "all"
)

$ErrorActionPreference = "Stop"

$Scripts = @(
    "apps\install-apps.ps1",
    "themes\install-themes.ps1",
    "wallpapers\install-wallpapers.ps1"
)

$FailedScripts = @()

function Show-Usage {
    Write-Host "Usage: .\onboard-setup.ps1 [all|select]"
    Write-Host "  all    - Run all setup scripts (default)"
    Write-Host "  select - Choose which scripts to run interactively"
    exit 1
}

function Invoke-Script {
    param([string]$ScriptPath)
    
    if (Test-Path $ScriptPath) {
        Write-Host "`n--- Running $ScriptPath ---" -ForegroundColor Cyan
        try {
            & "powershell.exe" -ExecutionPolicy Bypass -File $ScriptPath
            if ($LASTEXITCODE -ne 0) {
                throw "Script exited with code $LASTEXITCODE"
            }
        }
        catch {
            Write-Host "[Error] $ScriptPath failed: $($_.Exception.Message). Skipping to next script." -ForegroundColor Red
            $script:FailedScripts += $ScriptPath
        }
    }
    else {
        Write-Host "`n[Warning] $ScriptPath is not found. Skipping." -ForegroundColor Yellow
        $script:FailedScripts += "$ScriptPath (not found)"
    }
}

if ($Mode -eq "select") {
    Write-Host "Select which scripts to run (y/n):" -ForegroundColor Green
    foreach ($script in $Scripts) {
        $response = Read-Host "Run $script? [y/N]"
        if ($response -match "^[Yy]$") {
            Invoke-Script $script
        }
        else {
            Write-Host "Skipping $script." -ForegroundColor Yellow
        }
    }
}
elseif ($Mode -eq "all") {
    foreach ($script in $Scripts) {
        Invoke-Script $script
    }
}
else {
    Show-Usage
}

Write-Host "`nAll selected setup scripts completed." -ForegroundColor Green

if ($FailedScripts.Count -gt 0) {
    Write-Host "`nThe following scripts failed or were skipped:" -ForegroundColor Red
    foreach ($failed in $FailedScripts) {
        Write-Host "  - $failed" -ForegroundColor Red
    }
}
else {
    Write-Host "`nAll scripts ran successfully." -ForegroundColor Green
}
