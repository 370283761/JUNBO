# 🧪 飞书 MCP 功能测试清单

## ✅ 配置验证结果

### 配置文件状态
- ✅ **配置文件已创建**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- ✅ **文件权限正确**: `-rw-------` (600)
- ✅ **JSON 格式正确**: 验证通过
- ✅ **MCP Server 配置**: feishu-mcp@latest
- ✅ **App ID**: cli_a761f9c6d1ffd00e
- ✅ **认证类型**: tenant（应用凭证）
- ✅ **feishu-mcp 包可访问**: 可以通过 npx 访问

## 📋 下一步：在 Claude Desktop 中测试

### 步骤 1：重启 Claude Desktop（必需）

⚠️ **重要提示**：配置文件已创建，但 Claude Desktop 需要重启才能加载新配置。

1. **完全退出 Claude Desktop**
   - 方法 1：菜单栏 > Claude > Quit Claude
   - 方法 2：按 `Cmd + Q`
   - ⚠️ 不要只是关闭窗口，必须完全退出应用

2. **等待 3-5 秒**
   - 确保应用完全关闭

3. **重新启动 Claude Desktop**
   - 从应用程序文件夹或 Launchpad 打开

### 步骤 2：检查 MCP Server 状态

重启 Claude Desktop 后：

1. 打开 **Settings**（快捷键：`Cmd + ,`）
2. 点击 **Developer** 标签
3. 查看 **MCP Servers** 列表
4. **预期结果**：
   - ✅ 应该看到 "feishu" server
   - ✅ 状态指示器应该是**绿色**
   - ✅ 显示 "Running" 或运行状态

**如果显示红色或错误**：
- 点击 "View Logs" 查看详细错误
- 检查 App ID 和 Secret 是否正确
- 参考 [FAQ.md](FAQ.md) 的故障排查部分

### 步骤 3：基础功能测试

在 Claude Desktop 对话框中进行以下测试：

#### 测试 1：连接测试

**输入提示词**：
```
请测试飞书 MCP 连接是否正常
```

**预期结果**：
- ✅ Claude 确认可以连接到飞书 API
- ✅ 没有报错信息

---

#### 测试 2：读取测试文档

**输入提示词**：
```
请读取这个飞书文档并总结主要内容：
https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
```

**预期结果**：
- ✅ Claude 成功读取文档
- ✅ 返回文档内容摘要
- ✅ 没有权限错误

**如果遇到权限错误**：
1. 打开飞书文档：https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
2. 点击右上角【...】> 【添加应用】
3. 搜索并选择您的应用名称
4. 确认添加后重试

---

#### 测试 3：提取文档信息

**输入提示词**：
```
从这个飞书文档中提取以下信息：
1. 文档标题
2. 主要章节
3. 关键要点（3-5条）

文档链接：https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
```

**预期结果**：
- ✅ 正确识别文档标题
- ✅ 列出主要章节
- ✅ 提取关键要点

---

#### 测试 4：格式转换

**输入提示词**：
```
请将这个飞书文档转换为 Markdown 格式：
https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff

要求：
- 保留标题层级
- 保留列表格式
- 如果有表格，也请保留
```

**预期结果**：
- ✅ 输出格式化的 Markdown
- ✅ 保留文档结构
- ✅ 格式正确

---

#### 测试 5：内容分析

**输入提示词**：
```
分析这个飞书文档，并提供：
1. 文档类型（例如：产品需求、技术方案、会议纪要等）
2. 文档完整性评分（1-10分）
3. 主要优点
4. 改进建议

文档链接：https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
```

**预期结果**：
- ✅ 正确识别文档类型
- ✅ 提供合理评分
- ✅ 给出有价值的分析和建议

---

## 📊 测试结果记录表

完成测试后，请填写以下表格：

| 测试项 | 状态 | 备注 |
|--------|------|------|
| Claude Desktop 已重启 | ⬜ 是 ⬜ 否 | |
| MCP Server 显示绿色运行状态 | ⬜ 是 ⬜ 否 | |
| 测试 1：连接测试 | ⬜ 通过 ⬜ 失败 | |
| 测试 2：读取文档 | ⬜ 通过 ⬜ 失败 | |
| 测试 3：提取信息 | ⬜ 通过 ⬜ 失败 | |
| 测试 4：格式转换 | ⬜ 通过 ⬜ 失败 | |
| 测试 5：内容分析 | ⬜ 通过 ⬜ 失败 | |

## ⏱️ 性能测试（可选）

记录各项操作的响应时间：

| 操作 | 预期时间 | 实际时间 | 状态 |
|------|---------|---------|------|
| 连接测试 | < 3秒 | ___秒 | ⬜ |
| 读取小文档 | < 5秒 | ___秒 | ⬜ |
| 格式转换 | < 10秒 | ___秒 | ⬜ |
| 内容分析 | < 15秒 | ___秒 | ⬜ |

## 🎯 成功标准

全部测试通过的标准：

- ✅ MCP Server 正常运行（绿色状态）
- ✅ 能够连接飞书 API
- ✅ 成功读取测试文档
- ✅ 文档内容提取准确
- ✅ 格式转换功能正常
- ✅ 内容分析合理
- ✅ 响应时间在预期范围内

## 🐛 常见问题排查

### 问题 1：MCP Server 显示红色或未运行

**检查步骤**：
```bash
# 1. 查看配置文件
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json

# 2. 验证 JSON 格式
python3 -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json

# 3. 检查权限
ls -l ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**解决方案**：
- 如果 JSON 格式错误，重新运行 `./quick-setup.sh`
- 如果权限不对，运行 `chmod 600 ~/Library/Application\ Support/Claude/claude_desktop_config.json`
- 查看 Claude Desktop 日志：Settings > Developer > View Logs

### 问题 2：权限错误 "没有权限访问文档"

**解决方案**：
1. 确认应用已授予权限（登录飞书开放平台检查）
2. 将应用添加到文档：
   - 打开文档
   - 右上角【...】> 【添加应用】
   - 选择您的应用
3. 确认应用状态为"已启用"

### 问题 3：找不到文档或文档不存在

**解决方案**：
1. 在浏览器中打开文档链接，确认可以访问
2. 检查链接格式是否正确
3. 确认文档没有被删除或移动

## 📚 更多资源

- [使用示例文档](USAGE_EXAMPLES.md) - 更多高级使用案例
- [FAQ 文档](FAQ.md) - 31个常见问题解答
- [完整测试指南](TESTING.md) - 详细的测试流程
- [故障排查指南](CLAUDE_DESKTOP_SETUP.md#故障排查)

## 🎉 测试完成后

如果所有测试通过：

1. ✅ 恭喜！配置成功
2. 📚 查看 [USAGE_EXAMPLES.md](USAGE_EXAMPLES.md) 了解更多用法
3. 🚀 开始使用 Claude 处理您的飞书文档

如果遇到问题：

1. 📋 查看 [FAQ.md](FAQ.md)
2. 🔍 查看 Claude Desktop 日志
3. 💬 随时询问我

---

**现在请重启 Claude Desktop，然后在 Claude Desktop 中运行上述测试！** 🚀
