# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This project creates a Windows installer for OpenClaw that works in China's network environment where certain external resources may be blocked. The goal is one-click installation without errors.

## Project Purpose

- Bundle all necessary dependencies and resources for offline/blocked network installation
- Use Chinese mirror sources or embed required resources
- Provide a seamless installation experience for users in mainland China

## Development Guidance

### Installer Technology

This is a Windows installer project. Recommended approaches:
- **Inno Setup** - Popular, mature, script-based installer
- **NSIS** - Nullsoft Scriptable Install System
- **WiX Toolset** - XML-based Windows installer

### Network Handling Strategy

The installer must handle blocked external resources by:
- Using Chinese mirror sources (e.g., Tsinghua, Aliyun mirrors)
- Embedding dependencies directly in the installer
- Pre-downloading and bundling required packages

## Project Structure

```
install-openclaw.cmd   # 主安装脚本 (CMD)
README.md              # 使用说明
CLAUDE.md              # 本文件
LICENSE                # MIT 许可证
```

## Installation Script Usage

运行 `install-openclaw.cmd` (右键 → 以管理员身份运行)

安装步骤:
1. 安装 winget
2. 安装 Node.js
3. 安装 Git
4. 安装 OpenClaw (使用 npmmirror 镜像 + --legacy-peer-deps)
5. 配置 OpenClaw (tools.profile=full)
6. 安装官方插件 (飞书工具)
7. 配置飞书集成 (streaming/footer)

## Common Commands

Once the project has build scripts:
- Build installer: `./build.sh` or `.\build.bat`
- Test installer: Run the generated .exe in a VM

## Architecture Notes

This is a greenfield project. Initial architecture decisions:
- Decide on installer technology (Inno Setup recommended for simplicity)
- Determine which dependencies can be bundled vs. downloaded from mirrors
- Consider whether to use a portable or traditional installer approach
