# OpenClaw 一键安装脚本

在中国大陆网络环境下，一键安装 OpenClaw，无需任何配置，告别报错。

## 功能特性

- ✅ 自动安装 winget
- ✅ 自动安装 Node.js
- ✅ 自动安装 Git
- ✅ 自动配置 npm 镜像源 (npmmirror)
- ✅ 自动安装 OpenClaw
- ✅ 自动配置官方插件
- ✅ 自动配置飞书集成

## 使用方法

### 1. 下载脚本

点击 Code → Download ZIP，或克隆本仓库：

```bash
git clone https://github.com/your-repo/openclaw_installer_win_cn.git
cd openclaw_installer_win_cn
```

### 2. 运行脚本

**必须以管理员身份运行！**

右键点击 `install-openclaw.cmd`，选择 **以管理员身份运行**

或使用命令行：

```cmd
install-openclaw.cmd
```

### 3. 等待安装完成

脚本会自动执行所有安装步骤，耐心等待即可。

### 4. 启动 OpenClaw

安装完成后，使用以下命令启动：

```bash
openclaw start
```

查看配置：

```bash
openclaw config list
```

## 安装流程

| 步骤 | 说明 |
|------|------|
| 1 | 安装 winget (Windows 应用安装器) |
| 2 | 安装 Node.js (LTS 版本) |
| 3 | 安装 Git (版本控制) |
| 4 | 安装 OpenClaw (使用 npmmirror 镜像) |
| 5 | 配置 OpenClaw (tools.profile=full) |
| 6 | 安装官方插件 (@larksuite/openclaw-lark-tools) |
| 7 | 配置飞书集成 (streaming/footer) |

## 配置说明

安装脚本会自动配置以下内容：

```bash
# 工具配置
openclaw config set tools.profile full
openclaw config validate

# 飞书配置
openclaw config set channels.feishu.streaming true
openclaw config set channels.feishu.footer.elapsed true   # 开启耗时显示
openclaw config set channels.feishu.footer.status true     # 开启状态展示

# 官方插件
npx -y @larksuite/openclaw-lark-tools install
```

## 常见问题

### Q: 提示"请以管理员身份运行"

A: 右键点击脚本，选择"以管理员身份运行"

### Q: winget 安装失败

A: 确保系统为 Windows 10 1809 或更高版本，或手动下载 [DesktopAppInstaller](https://aka.ms/getwinget)

### Q: npm install 报错

A: 脚本已自动配置 npmmirror 镜像，如仍报错，可尝试：
```bash
npm config set registry https://registry.npmmirror.com
npm install -g openclaw@latest --legacy-peer-deps
```

### Q: 如何卸载？

```bash
npm uninstall -g openclaw
```

## 环境要求

- Windows 10 1809 或更高版本
- 需要管理员权限

## 许可证

MIT License - see [LICENSE](LICENSE)
