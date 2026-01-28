# 测试验证指南

本文档提供完整的测试步骤，帮助您验证飞书 MCP Server 配置是否成功。

## 📋 测试清单

### ✅ 阶段 1：环境检查

**1.1 检查 Node.js 环境**

```bash
node --version
# 预期输出：v18.0.0 或更高
```

**1.2 检查配置文件存在**

```bash
ls -l ~/Library/Application\ Support/Claude/claude_desktop_config.json
# 预期：文件存在，权限为 -rw-------
```

**1.3 验证配置文件格式**

```bash
python3 -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json
# 预期：输出格式化的 JSON，无错误
```

### ✅ 阶段 2：MCP Server 状态检查

**2.1 通过 Claude Desktop UI 检查**

1. 打开 Claude Desktop
2. Settings（Cmd+,）> Developer
3. 查看 MCP Servers 列表
4. ✅ 确认 "feishu" 显示绿色运行状态

**2.2 查看日志**

1. Settings > Developer > View Logs
2. 搜索 "feishu"
3. ✅ 确认没有错误信息

### ✅ 阶段 3：基础功能测试

**3.1 连接测试**

在 Claude 对话框中输入：

```
请测试飞书 MCP 连接是否正常
```

**预期结果**：
- ✅ Claude 确认可以连接到飞书 API
- ✅ 没有报错信息

**3.2 文档读取测试**

使用测试文档链接：

```
请读取这个飞书文档并总结主要内容：
https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
```

**预期结果**：
- ✅ Claude 能够成功读取文档
- ✅ 返回文档内容摘要
- ✅ 没有权限错误

**可能的问题**：
- ❌ 权限错误 → 应用未添加到文档，参考 [故障排查](#故障排查)
- ❌ 文档不存在 → 检查链接是否正确
- ❌ 连接超时 → 检查网络连接

**3.3 文档信息提取测试**

```
从这个飞书文档中提取以下信息：
1. 文档标题
2. 主要章节
3. 关键要点（3-5条）

文档链接：https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
```

**预期结果**：
- ✅ 正确提取标题
- ✅ 识别章节结构
- ✅ 总结关键要点

### ✅ 阶段 4：高级功能测试

**4.1 格式转换测试**

```
请将这个飞书文档转换为 Markdown 格式：
https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff

要求：
- 保留标题层级
- 保留列表格式
- 保留代码块（如果有）
```

**预期结果**：
- ✅ 输出格式化的 Markdown
- ✅ 保留文档结构
- ✅ 格式正确

**4.2 内容分析测试**

```
分析这个飞书文档：
https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff

提供：
1. 文档类型（产品需求/技术方案/会议纪要等）
2. 完整性评分（1-10分）
3. 改进建议
```

**预期结果**：
- ✅ 正确识别文档类型
- ✅ 提供合理评分
- ✅ 给出有价值的建议

**4.3 批量操作测试（如果有多个文档）**

```
请对比以下两个版本的文档，总结主要变化：
1. https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff
2. [另一个文档链接]
```

**预期结果**：
- ✅ 成功读取两个文档
- ✅ 识别差异
- ✅ 清晰呈现变化

### ✅ 阶段 5：性能和稳定性测试

**5.1 响应时间测试**

记录以下操作的响应时间：

| 操作 | 预期时间 | 实际时间 | 状态 |
|------|---------|---------|------|
| 连接测试 | < 3秒 | | |
| 读取小文档 | < 5秒 | | |
| 读取大文档 | < 15秒 | | |
| 格式转换 | < 10秒 | | |

**5.2 错误处理测试**

测试错误场景：

```
# 测试无效链接
请读取这个文档：
https://xxx.feishu.cn/docx/invalid_document_id
```

**预期结果**：
- ✅ 返回清晰的错误信息
- ✅ 不会导致 MCP Server 崩溃

## 🔧 故障排查

### 问题 1：MCP Server 未运行

**症状**：
- Claude Desktop Developer 界面中 feishu server 显示红色或不存在

**排查步骤**：

1. **检查配置文件**
```bash
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

2. **验证 JSON 格式**
```bash
python3 -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

3. **检查 Node.js**
```bash
node --version
npm --version
```

4. **手动测试 MCP Server**
```bash
npx -y feishu-mcp@latest --help
```

5. **查看详细日志**
- Settings > Developer > View Logs
- 搜索 "error" 或 "feishu"

### 问题 2：权限错误

**症状**：
- 提示 "没有权限访问文档"
- API 返回 403 错误

**解决方案**：

1. **检查应用权限**
   - 登录 https://open.feishu.cn/
   - 进入应用 > 权限管理
   - 确认已授予：`docx:document`, `docs:read`, `drive:drive.readonly`

2. **将应用添加到文档**
   - 打开飞书文档
   - 点击右上角 【...】 > 【添加应用】
   - 选择您的应用

3. **确认应用已启用**
   - 在飞书开放平台检查应用状态
   - 应该显示"已启用"

### 问题 3：文档读取失败

**症状**：
- Claude 报告无法读取文档
- 返回空内容或错误

**排查步骤**：

1. **验证文档链接**
   - 在浏览器中打开链接
   - 确认文档存在且可访问

2. **检查链接格式**
   - 支持的格式：
     - `https://xxx.feishu.cn/docx/xxxxx`
     - `https://xxx.feishu.cn/docs/xxxxx`
     - `https://xxx.feishu.cn/wiki/xxxxx`

3. **确认应用访问权限**
   - 文档协作者列表中应包含您的应用

4. **测试 API 访问**
   - 在飞书开放平台 > API Explorer 中测试相同的 API 调用

## 📊 测试报告模板

完成测试后，填写以下报告：

```markdown
# 飞书 MCP Server 测试报告

## 测试环境
- 操作系统：macOS [版本]
- Node.js：v[版本]
- Claude Desktop：v[版本]
- 测试日期：[日期]

## 测试结果

### 环境检查
- [ ] Node.js 版本符合要求
- [ ] 配置文件存在且格式正确
- [ ] 文件权限设置正确

### MCP Server 状态
- [ ] Server 正常启动
- [ ] 状态显示为运行中
- [ ] 日志无错误信息

### 基础功能
- [ ] 连接测试通过
- [ ] 文档读取成功
- [ ] 信息提取正确

### 高级功能
- [ ] 格式转换正常
- [ ] 内容分析准确
- [ ] 批量操作成功

### 性能指标
- 连接响应时间：[X]秒
- 文档读取时间：[X]秒
- 整体性能：[优秀/良好/一般]

## 遇到的问题
[列出测试中遇到的问题及解决方法]

## 总体评价
[测试总结和建议]

## 签名
测试人员：[姓名]
日期：[日期]
```

## 🎯 成功标准

所有测试通过的标准：

- ✅ MCP Server 正常运行
- ✅ 能够连接飞书 API
- ✅ 成功读取测试文档
- ✅ 格式转换功能正常
- ✅ 响应时间在预期范围内
- ✅ 错误处理符合预期
- ✅ 无严重性能问题

## 📝 测试检查清单

打印此清单，逐项验证：

```
□ Node.js 环境检查
□ 配置文���格式验证
□ MCP Server 启动确认
□ 连接测试通过
□ 测试文档读取成功
□ 文档内容提取准确
□ Markdown 转换正常
□ 内容分析功能正常
□ 错误处理符合预期
□ 性能指标达标
```

## 🚀 下一步

测试通过后：

1. ✅ 开始正式使用
2. 📚 阅读 [使用示例文档](USAGE_EXAMPLES.md)
3. 💡 探索更多高级功能
4. 🔄 定期检查更新

---

**祝测试顺利！如有问题，请查看 [FAQ](FAQ.md)**
