@echo off
title OpenClaw Gateway
set PATH=%PATH%;%APPDATA%\npm
openclaw gateway --port 18789 --verbose
pause
