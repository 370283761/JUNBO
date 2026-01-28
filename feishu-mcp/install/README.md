# 飞书 MCP Server 一键安装包

## 🎯 这是什么？

这是一个让 Claude Desktop 能够读取飞书文档的自动化安装包。

**只需一行命令，30秒完成配置！**

## ⚡ 快速安装（3步）

### 步骤 1：解压安装包

将下载的 zip 文件解压到任意位置。

### 步骤 2：运行安装脚本

打开终端，进入解压后的文件夹：

```bash
cd /path/to/feishu-mcp-install
./install.sh
```

**或者双击运行**（如果系统允许）

### 步骤 3：重启 Claude Desktop

完全退出 Claude Desktop（`Cmd+Q`），等待3秒，然后重新启动。

**完成！** 🎉

## 📋 系统要求

- ✅ **操作系统**: macOS
- ✅ **Node.js**: >= v18.0.0 ([下载](https://nodejs.org/))
- ✅ **Claude Desktop**: 已安装 ([下载](https://claude.ai/download))

## 🧪 验证安装

运行验证脚本：

```bash
./verify-install.sh
```

应该看到所有检查项都通过。

## 🚀 测试功能

在 Claude Desktop 中输入：

```
请读取这个飞书文档：
https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg
```

首次使用时选择：**"Yes, and don't ask again"**

如果成功读取文档内容，说明配置完成！

## 📦 包含文件

```
feishu-mcp-install/
├── README.md                 # 本文件（安装说明）
├── install.sh               # 一键安装脚本 ⭐
├── verify-install.sh        # 验证脚本
├── quick-setup.sh          # 交互式配置（可选）
├── USAGE_GUIDE.md          # 使用指南
├── FAQ.md                  # 常见问题
└── config/
    └── claude_desktop_config.json.example  # 配置示例
```

## 📊 预配置信息

本安装包使用已验证的飞书应用凭证：

- **App ID**: cli_a761f9c6d1ffd00e
- **认证类型**: tenant（应用凭证）
- **状态**: ✅ 已在生产环境测试

## 🎯 功能清单

安装后，Claude 可以：

- ✅ 读取飞书文档（Docs、Wiki、旧版文档）
- ✅ 搜索文档内容
- ✅ 转换文档格式（Markdown、纯文本）
- ✅ 分析文档内容（摘要、关键词）
- ✅ 批量处理多个文档
- ✅ 浏览知识库

## 📝 使用示例

### 读取文档
```
请读取这个飞书文档并总结主要内容
```

### 格式转换
```
将这个飞书文档转换为 Markdown 格式
```

### 内容分析
```
分析这个文档的结构和主要信息
```

更多示例见：[USAGE_GUIDE.md](USAGE_GUIDE.md)

## ❓ 常见问题

### Q: 安装需要多久？
**A:** 约 30 秒（不包括下载时间）

### Q: 需要输入什么信息？
**A:** 不需要！完全自动化。

### Q: 安全吗？
**A:**
- ✅ 配置文件权限自动设置为 600
- ✅ 使用官方 MCP 协议
- ✅ 只需要读取权限

### Q: 如果失败了怎么办？
**A:**
1. 运行 `./verify-install.sh` 查看详情
2. 查看 [FAQ.md](FAQ.md)
3. 重新运行 `./install.sh`

### Q: 可以自定义配置吗？
**A:** 可以！运行 `./quick-setup.sh` 使用自己的飞书应用凭证。

## 🔧 卸载

如需卸载，删除配置文件：

```bash
rm ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

然后重启 Claude Desktop。

## 📞 获取帮助

- **使用指南**: [USAGE_GUIDE.md](USAGE_GUIDE.md)
- **常见问题**: [FAQ.md](FAQ.md)
- **GitHub**: 提交 Issue

## 🎉 开始使用

```bash
./install.sh
```

**30秒后即可在 Claude 中读取飞书文档！** 🚀

---

**版本**: 1.0.0
**更新日期**: 2026-01-20
**测试状态**: ✅ 已验证
