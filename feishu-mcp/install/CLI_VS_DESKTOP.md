# 🚨 重要提示：Claude CLI vs Claude Desktop

## 问题说明

从您的截图中看到，`claude mcp list` 命令显示了多个 MCP Server，但**没有 feishu**。

**关键发现**：`claude mcp list` 是 **Claude CLI** 的命令，而我们的安装脚本配置的是 **Claude Desktop**。

## 🔑 两者的区别

| 项目 | Claude CLI | Claude Desktop |
|------|-----------|----------------|
| **是什么** | 命令行工具 | 桌面应用程序 |
| **配置文件** | `~/.config/claude/config.json` | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| **MCP 列表命令** | `claude mcp list` | Settings > Developer |
| **使用场景** | 终端中使用 | GUI 界面使用 |

## ✅ 正确的验证方法

### 不要使用 `claude mcp list`

这个命令查看的是 Claude CLI 的配置，与 Claude Desktop 无关！

### 正确的步骤：

#### 1️⃣ 完全重启 Claude Desktop

```bash
# 完全退出（不是关闭窗口）
killall "Claude"

# 或者按 Cmd+Q

# 等待 5 秒
sleep 5

# 重新启动
open -a "Claude"
```

#### 2️⃣ 在 Claude Desktop 中检查

打开 Claude Desktop：
1. 点击右上角头像
2. 选择 **Settings**
3. 选择 **Developer** 标签
4. 查看 **MCP Servers** 列表

应该看到：
- ✅ `feishu` 条目
- ✅ 绿色状态指示器 🟢
- ✅ 或者显示可用的工具列表

#### 3️⃣ 在对话中测试

在 Claude Desktop 对话框中输入：

```
请读取这个飞书文档：
https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg
```

**首次使用时会提示授权**，选择：
```
✓ Yes, and don't ask again
```

如果 Claude 能够读取并返回文档内容，说明配置成功！

## 🔧 如果仍然看不到 feishu

### 运行诊断脚本

```bash
cd /path/to/install
./diagnose.sh
```

这会检查：
- ✓ 配置文件位置
- ✓ 配置文件内容
- ✓ Node.js 环境
- ✓ feishu-mcp 包
- ✓ Claude Desktop 进程

### 手动检查配置文件

```bash
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

应该看到：
```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=cli_a761f9c6d1ffd00e",
        "--feishu-app-secret=VNhXgzmowleKU068HSaFqei0ZWrNSqtS",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

### 验证文件是否被读取

```bash
# 查看文件修改时间
ls -l ~/Library/Application\ Support/Claude/claude_desktop_config.json

# 应该显示最近的修改时间
```

## 💡 如果需要在 Claude CLI 中使用

如果您确实需要在 **Claude CLI** 中使用 feishu MCP，需要单独配置：

### 1. 找到 CLI 配置文件

```bash
# 查看 CLI 配置位置
claude config show

# 或者编辑配置
claude config edit
```

### 2. 添加 feishu MCP 配置

在 CLI 配置文件中添加：
```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=cli_a761f9c6d1ffd00e",
        "--feishu-app-secret=VNhXgzmowleKU068HSaFqei0ZWrNSqtS",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

### 3. 验证

```bash
claude mcp list
# 现在应该显示 feishu
```

## 📋 快速检查清单

```
□ 已完全退出 Claude Desktop（使用 Cmd+Q，不是关闭窗口）
□ 已等待至少 5 秒
□ 已重新启动 Claude Desktop
□ 在 Settings > Developer 中查看（不是使用 claude mcp list）
□ 配置文件位置正确：~/Library/Application Support/Claude/claude_desktop_config.json
□ 配置文件包含 feishu 配置
□ Node.js 版本 >= v18
```

## 🎯 总结

**重点**：
1. ✅ 我们的安装脚本是为 **Claude Desktop** 配置的
2. ✅ `claude mcp list` 是 **Claude CLI** 的命令
3. ✅ 两者使用**不同的配置文件**
4. ✅ 应该在 **Claude Desktop 的 Settings > Developer** 中验证
5. ✅ 如果看不到，尝试完全重启 Claude Desktop

---

**需要帮助？** 运行诊断脚本：`./diagnose.sh`