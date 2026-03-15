@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================
:: OpenClaw 一键安装脚本 (CMD版)
:: 适用于中国大陆网络环境
:: ============================================

echo.
echo ========================================
echo   OpenClaw 一键安装脚本
echo   适用于中国大陆网络环境
echo ========================================
echo.

:: 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本！
    echo 右键点击脚本，选择"以管理员身份运行"
    echo.
    pause
    exit /b 1
)

:: ============================================
:: 第一步：安装 winget
:: ============================================
echo [1/7] 正在安装 winget...

if exist "%ProgramFiles%\WindowsApps\Microsoft.DesktopAppInstaller*" (
    echo   winget 已安装，跳过
) else (
    powershell -NoProfile -Command "Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile winget.msixbundle"
    powershell -NoProfile -Command "Add-AppxPackage winget.msixbundle"
    del winget.msixbundle 2>nul
    echo   winget 安装完成
)

:: ============================================
:: 第二步：安装 Node.js (需要 24 以上)
:: ============================================
echo [2/7] 正在安装 Node.js (需要 24+)...

set NEED_NODE_INSTALL=1

where node >nul 2>&1
if %errorlevel% equ 0 (
    :: 检查 Node.js 版本
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo   当前版本: !NODE_VERSION!

    :: 提取版本号主版本
    for /f "tokens=1 delims=." %%a in ("!NODE_VERSION!") do set NODE_MAJOR=%%a

    if !NODE_MAJOR! GEQ 24 (
        echo   Node.js 版本 >= 24，满足要求
        set NEED_NODE_INSTALL=0
    ) else (
        echo   Node.js 版本低于 24，正在卸载...
        winget uninstall OpenJS.NodeJS --silent
    )
)

if !NEED_NODE_INSTALL!==1 (
    echo   正在安装 Node.js 24+ ...
    winget install OpenJS.NodeJS --version 24.0.0 --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo   指定版本安装失败，尝试安装最新版...
        winget install OpenJS.NodeJS --silent --accept-package-agreements --accept-source-agreements
    )
    :: 刷新环境变量
    set PATH=%PATH%;%ProgramFiles%\nodejs
    echo   Node.js 安装完成
)

:: ============================================
:: 第三步：安装 Git
:: ============================================
echo [3/7] 正在安装 Git...

where git >nul 2>&1
if %errorlevel% equ 0 (
    echo   Git 已安装，跳过
    for /f "tokens=*" %%i in ('where git') do set GIT_PATH=%%i
    echo   版本: !GIT_PATH!
) else (
    winget install Git.Git --silent --accept-package-agreements --accept-source-agreements -e
    echo   Git 安装完成
    :: 刷新环境变量
    set PATH=%PATH%;%ProgramFiles%\Git\cmd;%ProgramFiles%\Git\bin
)

:: ============================================
:: 第四步：安装 OpenClaw
:: ============================================
echo [4/7] 正在安装 OpenClaw...
echo   设置 npm 镜像源...

:: 设置 npm 镜像为国内源
set NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
set npm_config_registry=https://registry.npmmirror.com

:: 使用 --legacy-peer-deps 强制安装
echo   正在安装 openclaw@latest ...
npm install -g openclaw@latest --legacy-peer-deps

if %errorlevel% neq 0 (
    echo.
    echo [错误] OpenClaw 安装失败
    echo 请检查网络连接后重试
    pause
    exit /b 1
)

echo   OpenClaw 安装完成

:: ============================================
:: 第五步：配置 OpenClaw
:: ============================================
echo [5/7] 正在配置 OpenClaw...

echo   设置 tools.profile 为 full...
openclaw config set tools.profile full

echo   验证配置...
openclaw config validate

:: ============================================
:: 第六步：安装官方插件
:: ============================================
echo [6/7] 正在安装官方插件...

npx -y @larksuite/openclaw-lark-tools install

:: ============================================
:: 第七步：配置飞书集成
:: ============================================
echo [7/7] 正在配置飞书集成...

openclaw config set channels.feishu.streaming true
openclaw config set channels.feishu.footer.elapsed true
openclaw config set channels.feishu.footer.status true

:: ============================================
:: 安装完成
:: ============================================
echo.
echo ========================================
echo   安装完成！
echo ========================================
echo.
echo   可以使用以下命令启动 OpenClaw:
echo   openclaw start
echo.
echo   查看配置:
echo   openclaw config list
echo.
pause
