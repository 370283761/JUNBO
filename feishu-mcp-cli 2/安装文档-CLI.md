# 飞书 MCP Server 安装文档 (Claude Code CLI)

## 📦 安装包信息

**系统**: macOS
**需要**:
- ✅ Node.js >= v18.0.0
- ✅ **Claude Code CLI**（必需）

⚠️ **重要**：此安装包适用于 **Claude Code CLI**，不是 Claude Desktop。

## 🚀 快速安装（2步）

### 方法 A：全局安装（推荐）

```bash
cd feishu-mcp-cli
bash install.sh
```

安装完成后：
```bash
claude  #  启动 Claude CLI
> 请读取这个飞书文档：https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg
```

### 方法 B：项目级安装

```bash
cd your-project
bash install_project.sh
```

在项目目录运行 `claude` 即可使用。

## ✅ 验证安装

```bash
claude mcp list
```

应该看到：
```
feishu  stdio  npx -y feishu-mcp@latest ...
```

## 🔧 管理命令

```bash
# 查看配置
claude mcp list

# 移除配置
bash remove.sh
# 或
claude mcp remove feishu

# 验证安装
bash verify.sh
```

## 💡 使用示例

启动 Claude CLI：
```bash
claude
```

在会话中：
```
> 请读取这个飞书文档并总结主要内容
> 将这个飞书文档转换为 Markdown 格式  
> 搜索飞书中关于"产品需求"的文档
```

## ❓ 常见问题

### Q: Claude Code CLI 是什么？
**A**: 命令行版本的 Claude，与 Claude Desktop 不同。

### Q: 如何安装 Claude Code CLI？
**A**: 
- 访问 https://claude.ai 登录
- 按照指引安装命令行工具
- 或使用: `brew install claude`

### Q: 全局安装 vs 项目安装的区别？
**A**:
- **全局**: 在任何地方的 claude 会话都可用
- **项目**: 仅在特定项目目录可用（通过 .mcp.json）

### Q: 密钥安全吗？
**A**: 
- 全局安装：配置存储在 Claude CLI 内部数据库
- 项目安装：.mcp.json 包含密钥，不要提交到公共仓库

## 🔐 密钥存储

- **全局安装**: Claude CLI 内部数据库（运行 `claude mcp list` 可查看）
- **项目安装**: 当前目录的 `.mcp.json` 文件

## 🔄 卸载

```bash
# 全局卸载
bash remove.sh

# 项目卸载
rm .mcp.json
```

---

**版本**: 2.0.0 (CLI Version)
**更新**: 2026-01-20
