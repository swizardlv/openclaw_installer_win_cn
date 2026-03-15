@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================
:: OpenClaw CMD Install Script
:: China Network Environment
:: ============================================

echo.
echo ========================================
echo   OpenClaw Install Script
echo ========================================
echo.

:: Check admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run as Administrator!
    echo Right click -^> Run as administrator
    echo.
    pause
    exit /b 1
)

:: Step 1: Install winget
echo [1/7] Installing winget...

if exist "%ProgramFiles%\WindowsApps\Microsoft.DesktopAppInstaller*" (
    echo   winget already installed
) else (
    powershell -NoProfile -Command "Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile winget.msixbundle"
    powershell -NoProfile -Command "Add-AppxPackage winget.msixbundle"
    del winget.msixbundle 2>nul
    echo   winget installed
)

:: Step 2: Install Node.js 24+
echo [2/7] Installing Node.js (need 24+)...

set NEED_NODE_INSTALL=1

where node >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo   Current: !NODE_VERSION!
    for /f "tokens=1 delims=." %%a in ("!NODE_VERSION!") do set NODE_MAJOR=%%a
    if !NODE_MAJOR! GEQ 24 (
        echo   Version OK
        set NEED_NODE_INSTALL=0
    ) else (
        echo   Version too old, uninstalling...
        winget uninstall OpenJS.NodeJS --silent
    )
)

if !NEED_NODE_INSTALL!==1 (
    echo   Installing Node.js 24...
    winget install OpenJS.NodeJS --version 24.0.0 --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        winget install OpenJS.NodeJS --silent --accept-package-agreements --accept-source-agreements
    )
    set PATH=%PATH%;%ProgramFiles%\nodejs
    echo   Node.js installed
)

:: Step 3: Install Git
echo [3/7] Installing Git...

where git >nul 2>&1
if %errorlevel% equ 0 (
    echo   Git already installed
) else (
    winget install Git.Git --silent --accept-package-agreements --accept-source-agreements -e
    set PATH=%PATH%;%ProgramFiles%\Git\cmd;%ProgramFiles%\Git\bin
    echo   Git installed
)

:: Step 4: Install OpenClaw
echo [4/7] Installing OpenClaw...
echo   Setting npm mirror...

set NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
set npm_config_registry=https://registry.npmmirror.com

echo   Running: npm install -g openclaw@latest --legacy-peer-deps
npm install -g openclaw@latest --legacy-peer-deps

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] OpenClaw install failed
    pause
    exit /b 1
)

echo   OpenClaw installed

:: Step 5: Configure OpenClaw
echo [5/7] Configuring OpenClaw...

openclaw config set tools.profile full
openclaw config validate

:: Step 6: Install official plugin
echo [6/7] Installing official plugin...

npx -y @larksuite/openclaw-lark-tools install

:: Step 7: Configure Feishu
echo [7/7] Configuring Feishu...

openclaw config set channels.feishu.streaming true
openclaw config set channels.feishu.footer.elapsed true
openclaw config set channels.feishu.footer.status true

:: Done
echo.
echo ========================================
echo   DONE!
echo ========================================
echo.
echo   Run: openclaw start
echo.
pause
