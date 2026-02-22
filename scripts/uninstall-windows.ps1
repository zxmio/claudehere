# ============================================
# claudehere Windows uninstaller (PowerShell)
# Run as Administrator!
# ============================================

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  Uninstalling claudehere..." -ForegroundColor Yellow
Write-Host ""

$keys = @(
    "HKLM:\SOFTWARE\Classes\Directory\Background\shell\claudehere",
    "HKLM:\SOFTWARE\Classes\Directory\shell\claudehere",
    "HKLM:\SOFTWARE\Classes\Directory\Background\shell\claude-finder",
    "HKLM:\SOFTWARE\Classes\Directory\shell\claude-finder"
)

$removed = 0

foreach ($key in $keys) {
    if (Test-Path $key) {
        Remove-Item -Path $key -Recurse -Force
        $removed++
    }
}

# Remove icon files
$iconDirs = @(
    (Join-Path $env:ProgramData "claudehere"),
    (Join-Path $env:ProgramData "claude-finder")
)

foreach ($dir in $iconDirs) {
    if (Test-Path $dir) {
        Remove-Item -Path $dir -Recurse -Force
        Write-Host "  [OK] Icon files removed" -ForegroundColor Green
    }
}

if ($removed -gt 0) {
    Write-Host "  [OK] Context menu entries removed" -ForegroundColor Green
} else {
    Write-Host "  [WARN] claudehere was not found in the registry" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Uninstall complete!" -ForegroundColor Green
Write-Host ""
