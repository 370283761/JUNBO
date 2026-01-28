# 飞书文档 MCP Server for Claude

让 Claude 能够无缝读取和处理飞书文档的完整解决方案。

## 🌟 功能特性

- ✅ **文档读取**：读取飞书文档（Docs）、旧版文档、Wiki 等所有内容
- ✅ **智能搜索**：在文档和知识库中快速搜索关键信息
- ✅ **批量处理**：同时处理多个文档，提高效率
- ✅ **格式转换**：将飞书文档转换为 Markdown、纯文本等格式
- ✅ **知识库管理**：浏览和搜索飞书知识库内容
- ✅ **一键配置**：自动化配置脚本，快速上手
- ✅ **安全可靠**：基于官方 API，支持应用和用户凭证

## 📋 适用场景

- 📄 **文档总结**：快速提取飞书文档核心内容
- 🔄 **格式转换**：将飞书文档转换为 PRD、技术文档等标准格��
- 🔍 **信息提取**：从大量文档中提取关键信息
- 📊 **数据分析**：分析文档内容，生成洞察
- 🤝 **团队协作**：整合文档评论和反馈
- 📚 **知识管理**：构建和维护企业知识库

## 🚀 快速开始

### 前提条件

- ✅ Mac 系统（支持 macOS）
- ✅ Node.js v18 或更高版本
- ✅ Claude Desktop 应用或 Claude Code CLI
- ✅ 飞书企业账号

### 方式一：一键配置（推荐）

1. **克隆或下载本项目**

```bash
cd /Users/depp/projects/Prd_PO/feishu-mcp
```

2. **运行配置脚本**

```bash
./setup-feishu-mcp.sh
```

3. **按照提示输入**
   - 飞书 App ID
   - 飞书 App Secret
   - 选择认证类型

4. **重启 Claude Desktop**

就这么简单！🎉

### 方式二：手动配置

详细步骤请参考：

1. [飞书应用配置指南](FEISHU_APP_SETUP.md)
2. [Claude Desktop 配置指南](CLAUDE_DESKTOP_SETUP.md)

## 📖 文档导航

| 文档 | 说明 |
|------|------|
| [飞书应用配置指南](FEISHU_APP_SETUP.md) | 如何在飞书开放平台创建应用并获取凭证 |
| [Claude Desktop 配置指南](CLAUDE_DESKTOP_SETUP.md) | 如何配置 Claude Desktop 使用飞书 MCP |
| [使用示例与最佳实践](USAGE_EXAMPLES.md) | 丰富的使用示例和提示词模板 |
| [FAQ 常见问题](FAQ.md) | 常见问题解答和故障排查 |

## 💡 使用示例

### 示例 1：读取并总结文档

```
请读取这个飞书文档并总结主要内容：
https://xxx.feishu.cn/docx/doxcnxxxxxxxxxxxxxx
```

### 示例 2：批量文档分析

```
请分析文件夹 <folder_token> 中的所有文档，
并生成一个内容索引
```

### 示例 3：格式转换

```
将这个飞书需求文档转换为标准的 PRD Markdown 格式：
https://xxx.feishu.cn/docx/doxcnxxxxxxxxxxxxxx
```

### 示例 4：知识库搜索

```
在技术文档知识库中搜索关于"API 设计"的所有内容
```

更多示例请查看 [使用示例文档](USAGE_EXAMPLES.md)。

## 🔧 项目结构

```
feishu-mcp/
├── README.md                    # 本文件
├── FEISHU_APP_SETUP.md         # 飞书应用配置指南
├── CLAUDE_DESKTOP_SETUP.md     # Claude Desktop 配置指南
├── USAGE_EXAMPLES.md           # 使用示例和最佳实践
├── FAQ.md                      # 常见问题解答
├── setup-feishu-mcp.sh         # 一键配置脚本
└── config/
    ├── claude_desktop_config.json.example  # Claude Desktop 配置模板
    └── claude_code_config.json.example     # Claude Code 配置模板
```

## 🔑 配置说明

### 飞书应用凭证

您需要在飞书开放平台获取：

- **App ID**：应用标识，格式如 `cli_xxxxxxxxxx`
- **App Secret**：应用密钥

详细步骤请参考 [飞书应用配置指南](FEISHU_APP_SETUP.md)。

### 认证类型

| 类型 | 说明 | 适用场景 |
|------|------|---------|
| `tenant` | 应用访问凭证 | **推荐**：只读操作，无需用户授权 |
| `user` | 用户访问凭证 | 需要以用户身份操作的场景 |

## 🛡️ 安全建议

- ✅ 使用 `tenant` 认证类型（应用凭证）
- ✅ 不要将 App Secret 提交到版本控制
- ✅ 定期轮换 App Secret
- ✅ 只授予必需的最小权限
- ✅ 设置配置文件权限为 600

```bash
chmod 600 ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

## 🧪 验证安装

### 检查 MCP Server 状态

1. 打开 Claude Desktop
2. 进入 Settings > Developer
3. 查看 MCP Servers 列表
4. 确认 "feishu" 显示为运行状态（绿色指示器）

### 测试文档读取

在 Claude 对话框中输入：

```
请测试飞书 MCP 连接是否正常
```

如果配置成功，Claude 会确认可以访问飞书 API。

## ❓ 常见问题

### Q1: MCP Server 无法启动？

**解决方案**：
1. 检查 Node.js 版本（需要 v18+）
2. 验证配置文件 JSON 格式
3. 查看 Claude Desktop 日志

详细排查步骤请查看 [FAQ](FAQ.md)。

### Q2: 无法读取某些文档？

**解决方案**：
1. 确认应用已添加到文档的协作者列表
2. 检查应用权限配置
3. 验证文档链接格式

### Q3: 权限错误？

**解决方案**：
1. 在飞书开放平台申请必要权限：
   - `docx:document`
   - `docs:read`
   - `drive:drive.readonly`
2. 确保应用状态为"已启用"

更多问题请查看 [常见问题解答](FAQ.md)。

## 🔗 相关资源

### 官方文档

- [飞书开放平台](https://open.feishu.cn/)
- [Claude Desktop MCP 文档](https://support.claude.com/en/articles/10949351)
- [Model Context Protocol 规范](https://modelcontextprotocol.io/)

### 社区项目

- [cso1z/Feishu-MCP](https://github.com/cso1z/Feishu-MCP) - 核心 MCP Server 实现
- [飞书 API 文档](https://open.feishu.cn/document/server-docs/docs/docs-overview)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🙏 致谢

- [cso1z/Feishu-MCP](https://github.com/cso1z/Feishu-MCP) - 提供了优秀的 MCP Server 实现
- [Anthropic](https://www.anthropic.com/) - 开发了强大的 Claude AI 和 MCP 协议
- [飞书开放平台](https://open.feishu.cn/) - 提供了完善的 API 支持

## 📞 支持

如果您遇到问题或有任何建议：

1. 查看 [FAQ 文档](FAQ.md)
2. 查看 [使用示例](USAGE_EXAMPLES.md)
3. 提交 GitHub Issue

---

**开始使用 Claude 处理飞书文档，提升您的工作效率！** 🚀
