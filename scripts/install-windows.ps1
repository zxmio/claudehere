# ============================================
# claudehere Windows installer (PowerShell)
# Adds "Open Claude Code Here" to Explorer
# right-click context menu (with Claude icon)
# Run as Administrator!
# https://claudehere.com
# ============================================

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  claudehere for Windows - installer" -ForegroundColor Cyan
Write-Host "  ===================================" -ForegroundColor Cyan
Write-Host ""

# --- Locate and install icon ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectDir = Split-Path -Parent $scriptDir
$iconSrc = Join-Path $projectDir "assets\icon.ico"

$iconDir = Join-Path $env:ProgramData "claudehere"
$iconPath = Join-Path $iconDir "icon.ico"

if (-not (Test-Path $iconDir)) {
    New-Item -Path $iconDir -ItemType Directory -Force | Out-Null
}

$iconValue = "cmd.exe"
if (Test-Path $iconSrc) {
    Copy-Item -Path $iconSrc -Destination $iconPath -Force
    $iconValue = $iconPath
    Write-Host "  [OK] Icon installed to $iconPath" -ForegroundColor Green
} else {
    Write-Host "  [WARN] icon.ico not found, using default icon" -ForegroundColor Yellow
}

# --- Check if claude is available ---
$claudePath = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claudePath) {
    Write-Host "  [WARN] claude command not found." -ForegroundColor Yellow
    Write-Host "  Please install Claude Code CLI first:" -ForegroundColor Yellow
    Write-Host "  https://docs.claude.com/en/docs/claude-code" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "  Continue anyway? (y/n)"
    if ($continue -ne "y") { exit 1 }
}

# --- Detect terminal ---
$useWindowsTerminal = $false
$wtPath = Get-Command wt -ErrorAction SilentlyContinue
if ($wtPath) {
    $useWindowsTerminal = $true
}

# --- Build launch command ---
$launchCmd = 'cmd.exe /s /k "pushd "%V" && claude"'

Write-Host "  Installing context menu entries..." -ForegroundColor White

# --- Remove old claude-finder entries if exist ---
$oldBgKey = "HKLM:\SOFTWARE\Classes\Directory\Background\shell\claude-finder"
$oldDirKey = "HKLM:\SOFTWARE\Classes\Directory\shell\claude-finder"
if (Test-Path $oldBgKey) { Remove-Item -Path $oldBgKey -Recurse -Force }
if (Test-Path $oldDirKey) { Remove-Item -Path $oldDirKey -Recurse -Force }

# --- 1. Folder background right-click ---
$bgKey = "HKLM:\SOFTWARE\Classes\Directory\Background\shell\claudehere"
$bgCmdKey = "$bgKey\command"

if (Test-Path $bgKey) { Remove-Item -Path $bgKey -Recurse -Force }

New-Item -Path $bgKey -Force | Out-Null
New-Item -Path $bgCmdKey -Force | Out-Null

$bgReg = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Classes\Directory\Background\shell\claudehere", $true)
$bgReg.SetValue("", "Open Claude Code Here")
$bgReg.SetValue("Icon", $iconValue, [Microsoft.Win32.RegistryValueKind]::String)
$bgReg.Close()

$bgCmdReg = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Classes\Directory\Background\shell\claudehere\command", $true)
$bgCmdReg.SetValue("", $launchCmd)
$bgCmdReg.Close()

Write-Host "  [OK] Folder background right-click menu" -ForegroundColor Green

# --- 2. Right-click on a folder ---
$dirKey = "HKLM:\SOFTWARE\Classes\Directory\shell\claudehere"
$dirCmdKey = "$dirKey\command"

if (Test-Path $dirKey) { Remove-Item -Path $dirKey -Recurse -Force }

New-Item -Path $dirKey -Force | Out-Null
New-Item -Path $dirCmdKey -Force | Out-Null

$dirReg = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Classes\Directory\shell\claudehere", $true)
$dirReg.SetValue("", "Open Claude Code Here")
$dirReg.SetValue("Icon", $iconValue, [Microsoft.Win32.RegistryValueKind]::String)
$dirReg.Close()

$dirCmdReg = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Classes\Directory\shell\claudehere\command", $true)
$dirCmdReg.SetValue("", $launchCmd)
$dirCmdReg.Close()

Write-Host "  [OK] Folder right-click menu" -ForegroundColor Green

Write-Host ""
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host ""

if ($useWindowsTerminal) {
    Write-Host "  Terminal: Windows Terminal (detected)" -ForegroundColor White
} else {
    Write-Host "  Terminal: cmd.exe" -ForegroundColor White
}

Write-Host ""
Write-Host "  How to use:" -ForegroundColor White
Write-Host "    1. Open any folder in File Explorer" -ForegroundColor Gray
Write-Host "    2. Right-click on empty space" -ForegroundColor Gray
Write-Host "    3. Click - Open Claude Code Here" -ForegroundColor Gray
Write-Host "    Note: On Win11, click Show more options first" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  https://claudehere.com" -ForegroundColor DarkGray
Write-Host ""
