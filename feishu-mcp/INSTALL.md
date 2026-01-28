# 🚀 飞书 MCP Server 一键安装包

## 📦 包含内容

这是一个完全自动化的安装包，可以一键配置 Claude Desktop 以支持飞书文档读取。

**预配置的凭证**：
- **App ID**: `cli_a761f9c6d1ffd00e`
- **App Secret**: 已内置
- **认证类型**: `tenant`（应用凭证）

## ⚡ 快速安装

### 一行命令安装

在终端中运行：

```bash
cd /Users/depp/projects/Prd_PO/feishu-mcp && ./install.sh
```

或者从任何位置：

```bash
/Users/depp/projects/Prd_PO/feishu-mcp/install.sh
```

### 安装过程

脚本会自动：
1. ✅ 检查系统环境（macOS、Node.js、npm）
2. ✅ 验证 feishu-mcp 包可访问性
3. ✅ 创建配置文件
4. ✅ 设置正确权限（600）
5. ✅ 验证 JSON 格式
6. ✅ 备份现有配置

## 📋 系统要求

- **操作系统**: macOS
- **Node.js**: >= v18.0.0
- **Claude Desktop**: 已安装

## 🎯 安装后步骤

### 1. 重启 Claude Desktop

```
完全退出（Cmd+Q）→ 等待 3-5 秒 → 重新启动
```

### 2. 验证状态

打开 Claude Desktop：
- Settings > Developer
- 检查 "feishu" server 是否为绿色运行状态

### 3. 测试功能

在 Claude 对话框中输入：

```
请读取这个飞书文档：
https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg
```

### 4. 授权工具

首次使用时选择：
```
✓ Yes, and don't ask again
```

## 📁 文件说明

```
feishu-mcp/
├── install.sh                      # 一键安装脚本（主要使用）
├── quick-setup.sh                  # 交互式配置脚本
├── setup-feishu-mcp.sh            # 完整配置脚本
├── README.md                       # 项目总览
├── QUICKSTART.md                   # 快速开始指南
├── USAGE_EXAMPLES.md               # 使用示例
├── FAQ.md                          # 常见问题
├── TESTING.md                      # 测试指南
└── ACTUAL_TEST_REPORT.md          # 实际测试报告
```

## 🔧 卸载

如果需要卸载，删除配置文件即可：

```bash
rm ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

然后重启 Claude Desktop。

## 🔄 更新凭证

如果需要使用不同的飞书应用凭证：

### 方法 1：修改脚本（推荐）

编辑 `install.sh`，修改这些行：

```bash
FEISHU_APP_ID="你的_APP_ID"
FEISHU_APP_SECRET="你的_APP_SECRET"
FEISHU_AUTH_TYPE="tenant"  # 或 "user"
```

### 方法 2：使用交互式脚本

```bash
./quick-setup.sh
```

会提示您输入新的凭证。

### 方法 3：手动编辑配置文件

```bash
open ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

## ⚠️ 安全提醒

- ✅ 配置文件权限已自动设置为 600（仅所有者可读写）
- ✅ 不要将配置文件提交到公共代码仓库
- ✅ 定期更换 App Secret（建议 3-6 个月）
- ✅ 使用 `tenant` 认证类型（应用凭证）而非 `user`

## 📊 功能特性

安装后，您可以让 Claude：

- 📄 **读取飞书文档** - Docs、Wiki、旧版文档
- 🔍 **搜索内容** - 在文档和知识库中搜索
- 📝 **格式转换** - 转换为 Markdown、纯文本
- 📊 **内容分析** - 提取要点、生成摘要
- 📁 **批量处理** - 同时处理多个文档
- 📚 **知识库管理** - 浏览和搜索知识库

## 🐛 故障排查

### 问题 1：权限错误

```bash
chmod +x /Users/depp/projects/Prd_PO/feishu-mcp/install.sh
```

### 问题 2：Node.js 版本过低

访问 https://nodejs.org/ 下载最新版本

### 问题 3：MCP Server 未运行

查看日志：
```
Claude Desktop > Settings > Developer > View Logs
```

### 问题 4：无法读取文档

1. 在飞书中打开文档
2. 添加应用为协作者
3. 重试

更多问题查看：[FAQ.md](FAQ.md)

## 📞 获取帮助

- **使用示例**: [USAGE_EXAMPLES.md](USAGE_EXAMPLES.md)
- **常见问题**: [FAQ.md](FAQ.md)
- **测试指南**: [TESTING.md](TESTING.md)
- **实际测试**: [ACTUAL_TEST_REPORT.md](ACTUAL_TEST_REPORT.md)

## 🎉 成功案例

本配置已在以下环境测试成功：

- ✅ macOS (Darwin 25.1.0)
- ✅ Node.js v24.12.0
- ✅ Claude Desktop (最新版本)
- ✅ 成功读取 Wiki 和 Docs 文档
- ✅ 格式转换功能正常
- ✅ 内容分析功能正常

测试文档：https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg

---

**一键安装，立即使用！** 🚀

有问题随时查看文档或联系支持。
