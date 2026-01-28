# 飞书 MCP Server (Claude Code CLI)

让 Claude Code CLI 能够读取和处理飞书文档。

## 快速开始

```bash
# 1. 运行安装脚本
bash install.sh

# 2. 启动 Claude CLI
claude

# 3. 测试功能
> 请读取这个飞书文档：https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg
```

## 文件说明

- `install.sh` - 全局安装脚本
- `install_project.sh` - 项目级安装脚本
- `remove.sh` - 卸载脚本
- `verify.sh` - 验证脚本
- `安装文档-CLI.md` - 详细中文文档
- `config/.mcp.json.example` - 配置示例

## 系统要求

- macOS
- Node.js >= v18
- Claude Code CLI

## 两种安装方式

### 全局安装
```bash
bash install.sh
```
在任何地方都可用

### 项目安装
```bash
bash install_project.sh
```
仅在当前项目可用

## 验证

```bash
claude mcp list
```

## License

MIT
