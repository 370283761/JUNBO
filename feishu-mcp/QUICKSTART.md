# 飞书 MCP Server 快速开始指南

## 🎯 目标

让 Claude 能够读取飞书文档，只需 3 步，10 分钟完成！

## ⚡ 三步配置

### 步骤 1️⃣：获取飞书凭证（5 分钟）

1. 访问 https://open.feishu.cn/
2. 创建企业自建应用
3. 获取 App ID 和 App Secret
4. 申请权限：`docx:document`, `docs:read`, `drive:drive.readonly`
5. 启用应用

📖 详细步骤：[飞书应用配置指南](FEISHU_APP_SETUP.md)

### 步骤 2️⃣：运行配置脚本（3 分钟）

```bash
cd /Users/depp/projects/Prd_PO/feishu-mcp
./setup-feishu-mcp.sh
```

按提示输入：
- App ID
- App Secret
- 认证类型（选择 tenant）

### 步骤 3️⃣：重启 Claude Desktop（2 分钟）

1. 完全退出 Claude Desktop（Cmd+Q）
2. 重新启动
3. 在对话中测试：

```
请测试飞书 MCP 连接是否正常
```

## ✅ 验证成功

如果看到类似这样的回复：

```
✓ 飞书 MCP Server 运行正常
✓ 可以访问飞书 API
✓ 已准备好读取飞书文档
```

恭喜！配置成功！🎉

## 🚀 开始使用

试试这些功能：

```
# 读取文档
请读取这个飞书文档：
https://xxx.feishu.cn/docx/xxxxx

# 搜索文档
搜索包含"产品需求"的飞书文档

# 格式转换
将这个飞书文档转换为 Markdown 格式：
https://xxx.feishu.cn/docx/xxxxx
```

## 📚 完整文档

- [README](README.md) - 项目总览
- [飞书应用配置](FEISHU_APP_SETUP.md) - 飞书端配置
- [Claude 配置](CLAUDE_DESKTOP_SETUP.md) - Claude 端配置
- [使用示例](USAGE_EXAMPLES.md) - 丰富的使用案例
- [FAQ](FAQ.md) - 常见问题解答

## ❓ 遇到问题？

查看 [FAQ 文档](FAQ.md) 或提交 Issue。

---

**开始探索 Claude + 飞书的强大组合吧！** 🚀
