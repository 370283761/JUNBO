# Claude Desktop 配置指南

本指南将帮助您配置 Claude Desktop，使其能够通过 MCP (Model Context Protocol) 读取飞书文档。

## 前提条件

在开始之前，请确保：

- ✅ 已完成[飞书应用配置](FEISHU_APP_SETUP.md)
- ✅ 已获得 App ID 和 App Secret
- ✅ Mac 上已安装 Node.js (v18 或更高版本)
- ✅ 已安装 Claude Desktop 应用

## 配置步骤

### 方法一：自动配置（推荐）

运行一键配置脚本：

```bash
cd /Users/depp/projects/Prd_PO/feishu-mcp
./setup-feishu-mcp.sh
```

脚本会自动：
1. 检查环境
2. 引导您输入飞书凭证
3. 配置 Claude Desktop
4. 验证安装

### 方法二：手动配置

#### 步骤 1：找到 Claude Desktop 配置文件

Claude Desktop 配置文件位于：

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

#### 步骤 2：编辑配置文件

您可以：

**选项 A**：通过 Claude Desktop 应用打开
1. 打开 Claude Desktop
2. 点击菜单栏 **Claude > Settings**（或按 `Cmd+,`）
3. 选择 **Developer** 标签
4. 点击 **Edit Config** 按钮

**选项 B**：直接编辑文件
```bash
# 使用您喜欢的编辑器打开配置文件
open -a "TextEdit" ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

#### 步骤 3：添加 MCP Server 配置

在配置文件中添加飞书 MCP Server 配置。有三种安装方式可选：

##### 选项 A：使用 NPX（推荐，最简单）

不需要预先安装，每次自动使用最新版本：

```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=cli_xxxxxxxxxx",
        "--feishu-app-secret=xxxxxxxxxxxxxxxx",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

##### 选项 B：全局安装

首先全局安装 feishu-mcp：

```bash
npm install -g feishu-mcp
```

然后配置：

```json
{
  "mcpServers": {
    "feishu": {
      "command": "feishu-mcp",
      "args": [
        "--feishu-app-id=cli_xxxxxxxxxx",
        "--feishu-app-secret=xxxxxxxxxxxxxxxx",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

##### 选项 C：本地开发版本

如果您想使用本地开发版本或自定义代码：

```bash
# 克隆仓库
git clone https://github.com/cso1z/Feishu-MCP.git
cd Feishu-MCP
npm install
npm run build
```

然后配置：

```json
{
  "mcpServers": {
    "feishu": {
      "command": "node",
      "args": [
        "/path/to/Feishu-MCP/build/index.js",
        "--feishu-app-id=cli_xxxxxxxxxx",
        "--feishu-app-secret=xxxxxxxxxxxxxxxx",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

#### 步骤 4：替换实际凭证

将配置中的占位符替换为您的实际凭证：

- `cli_xxxxxxxxxx` → 您的 App ID
- `xxxxxxxxxxxxxxxx` → 您的 App Secret

⚠️ **重要提示**：
- 不要在配置文件中留下空格或换行
- 确保 JSON 格式正确（可以使用 JSON 验证工具）
- 不要将包含真实凭证的配置文件提交到 Git

#### 步骤 5：认证类型说明

`--feishu-auth-type` 参数有两个选项：

| 认证类型 | 说明 | 适用场景 |
|---------|------|---------|
| `tenant` | 应用访问凭证 | **推荐**：只需 App ID 和 Secret，适合只读操作 |
| `user` | 用户访问凭证 | 需要用户授权，适合需要以用户身份操作的场景 |

**推荐使用 `tenant` 模式**，因为：
- 配置简单，无需额外授权
- 足够满足读取文档的需求
- 更安全，权限范围受限于应用本身

#### 步骤 6：保存并重启 Claude Desktop

1. 保存配置文件
2. **完全退出** Claude Desktop（菜单栏 > Claude > Quit，或按 `Cmd+Q`）
3. 重新启动 Claude Desktop

⚠️ **注意**：必须完全退出并重启，而不是仅关闭窗口。

## 验证配置

### 检查 MCP Server 状态

1. 打开 Claude Desktop
2. 在 Settings > Developer 中查看 MCP Servers 列表
3. 确认 "feishu" server 状态为运行中（绿色指示器）

### 测试飞书文档读取

在 Claude 对话框中尝试：

```
请帮我读取这个飞书文档的内容：
https://xxx.feishu.cn/docx/xxxxx
```

如果配置成功，Claude 将能够读取并总结文档内容。

## 配置 Claude Code CLI（可选）

如果您也想在 Claude Code CLI 中使用飞书 MCP：

编辑 `~/.claude/config.json`：

```json
{
  "primaryApiKey": "your-api-key",
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=cli_xxxxxxxxxx",
        "--feishu-app-secret=xxxxxxxxxxxxxxxx",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

## 可用功能

配置完成后，您可以让 Claude：

### 📄 文档操作
- 读取文档内容
- 总结文档要点
- 提取特定信息
- 对比多个文档
- 将文档转换为其他格式

### 📁 文件夹操作
- 列出文件夹中的所有文档
- 批量处理多个文档
- 搜索文档

### 🔍 搜索功能
- 在文档中搜索关键词
- 跨文档搜索内容

### 📝 知识库操作
- 浏览知识库结构
- 读取知识库文档
- 搜索知识库内容

## 使用示例

### 示例 1：读取单个文档

```
请读取这个飞书文档的内容并总结主要内容：
https://xxx.feishu.cn/docx/xxxxx
```

### 示例 2：对比文档

```
请对比以下两个飞书文档的差异：
1. https://xxx.feishu.cn/docx/aaa
2. https://xxx.feishu.cn/docx/bbb
```

### 示例 3：转换格式

```
请将这个飞书文档转换为 Markdown 格式：
https://xxx.feishu.cn/docx/xxxxx
```

### 示例 4：批量处理

```
请列出文件夹 <folder_id> 中的所有文档，
并为每个文档生成一个简短的摘要
```

### 示例 5：提取信息

```
从这个飞书文档中提取所有的任务清单：
https://xxx.feishu.cn/docx/xxxxx
```

## 故障排查

### 问题 1：MCP Server 无法启动

**症状**：Claude Desktop 中看不到 feishu server，或显示红色错误状态

**解决方案**：
1. 检查 Node.js 是否已安装：
   ```bash
   node --version  # 应该显示 v18 或更高
   ```
2. 检查配置文件 JSON 格式是否正确
3. 查看 Claude Desktop 日志：
   - 打开 Settings > Developer
   - 点击 "View Logs"
   - 查找错误信息

### 问题 2：权限错误

**症状**：Claude 报告无权访问文档

**解决方案**：
1. 确认飞书应用已获得必要权限（`docx:document`, `docs:read`）
2. 确认应用已添加到目标文档的协作者列表
3. 确认应用状态为"已启用"
4. 尝试在飞书 Web 端手动将应用添加到文档

### 问题 3：凭证错误

**症状**：MCP Server 启动失败，提示认证错误

**解决方案**：
1. 重新检查 App ID 和 App Secret 是否正确
2. 确认没有多余的空格或换行符
3. 尝试重新生成 App Secret
4. 检查飞书应用是否已启用

### 问题 4：文档读取失败

**症状**：MCP Server 正常运行，但无法读取特定文档

**解决方案**：
1. 确认文档 URL 格式正确
2. 确认应用已添加到该文档
3. 检查文档是否已删除或移动
4. 尝试在飞书 Web 端手动打开文档

### 问题 5：配置不生效

**症状**：修改配置后，Claude Desktop 仍使用旧配置

**解决方案**：
1. 确保完全退出 Claude Desktop（Cmd+Q）
2. 等待几秒后重新启动
3. 清除缓存（如果问题持续）：
   ```bash
   rm -rf ~/Library/Application\ Support/Claude/cache
   ```

## 安全最佳实践

### 1. 保护凭证

```bash
# 确保配置文件权限正确
chmod 600 ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### 2. 环境变量（替代方案）

如果担心凭证泄露，可以使用环境变量：

```bash
# 在 ~/.zshrc 或 ~/.bashrc 中添加
export FEISHU_APP_ID="cli_xxxxxxxxxx"
export FEISHU_APP_SECRET="xxxxxxxxxxxxxxxx"
```

然后配置文件可以引用环境变量（如果 MCP Server 支持）。

### 3. 定期轮换凭证

建议每 3-6 个月重新生成一次 App Secret。

### 4. 监控使用情况

定期在飞书开放平台查看 API 调用日志，确保没有异常使用。

## 配置文件示例

### 完整的 claude_desktop_config.json 示例

```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=cli_a1b2c3d4e5f6g7h8",
        "--feishu-app-secret=abc123def456ghi789jkl012mno345pqr678",
        "--feishu-auth-type=tenant"
      ]
    }
  }
}
```

### 多个 MCP Server 配置示例

如果您还使用其他 MCP Server：

```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=cli_xxxxxxxxxx",
        "--feishu-app-secret=xxxxxxxxxxxxxxxx",
        "--feishu-auth-type=tenant"
      ]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/username/Documents"]
    }
  }
}
```

## 下一步

配置完成后：

1. 阅读[使用示例和最佳实践](USAGE_EXAMPLES.md)
2. 查看[常见问题解答](FAQ.md)
3. 开始使用 Claude 处理飞书文档！

## 参考资源

- Claude Desktop MCP 文档：https://support.claude.com/en/articles/10949351
- Feishu-MCP GitHub：https://github.com/cso1z/Feishu-MCP
- Model Context Protocol 规范：https://modelcontextprotocol.io/
