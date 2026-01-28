# 飞书 MCP 配置文件

此目录包含 Claude 配置文件的示例模板。

## 文件说明

- **claude_desktop_config.json.example** - Claude Desktop 配置模板
- **claude_code_config.json.example** - Claude Code CLI 配置模板

## 使用方法

### Claude Desktop

1. 复制示例文件内容
2. 替换占位符：
   - `cli_xxxxxxxxxx` → 您的飞书 App ID
   - `xxxxxxxxxxxxxxxx` → 您的飞书 App Secret
3. 保存到：`~/Library/Application Support/Claude/claude_desktop_config.json`
4. 重启 Claude Desktop

### Claude Code CLI

1. 复制示例文件内容
2. 替换占位符（同上）
3. 保存到：`~/.claude/config.json`
4. 重启 Claude Code CLI

## 快速配置

推荐使用一键配置脚本：

```bash
cd /Users/depp/projects/Prd_PO/feishu-mcp
./setup-feishu-mcp.sh
```

## 注意事项

⚠️ **重要**：
- 不要将包含真实凭证的配置文件提交到版本控制
- 确保配置文件权限为 600：`chmod 600 <config_file>`
- 定期轮换 App Secret

## 更多信息

详细配置说明请参考：
- [Claude Desktop 配置指南](../CLAUDE_DESKTOP_SETUP.md)
