# 常见问题解答（FAQ）

本文档收集了使用飞书 MCP Server 时的常见问题和解决方案。

## 目录

- [安装和配置](#安装和配置)
- [连接和认证](#连接和认证)
- [文档访问](#文档访问)
- [性能和限制](#性能和限制)
- [故障排查](#故障排查)
- [安全和权限](#安全和权限)

## 安装和配置
 
### Q1: 需要什么前置条件？

**A:** 您需要：
- Mac 系统
- Node.js v18 或更高版本
- Claude Desktop 应用或 Claude Code CLI
- 飞书企业账号
- 飞书应用的 App ID 和 App Secret

### Q2: 如何检查 Node.js 版本？

**A:** 在终端运行：

```bash
node --version
```

如果版本低于 v18，请访问 [nodejs.org](https://nodejs.org/) 下载最新版本。

### Q3: 配置文件在哪里？

**A:**
- **Claude Desktop**：`~/Library/Application Support/Claude/claude_desktop_config.json`
- **Claude Code CLI**：`~/.claude/config.json`

可以通过以下方式打开：

```bash
# 打开 Claude Desktop 配置
open ~/Library/Application\ Support/Claude/claude_desktop_config.json

# 打开 Claude Code 配置
open ~/.claude/config.json
```

### Q4: 配置后需要重启 Claude Desktop 吗？

**A:** 是的，必须**完全退出**并重启 Claude Desktop：

1. 菜单栏 > Claude > Quit（或按 `Cmd+Q`）
2. 等待几秒
3. 重新启动 Claude Desktop

仅关闭窗口不会重新加载配置。

### Q5: 一键配置脚本支持哪些功能？

**A:** 脚本会自动：
- 检查 Node.js 环境
- 引导输入飞书凭证
- 生成配置文件
- 验证配置格式
- 可选配置 Claude Code CLI

运行方式：

```bash
cd /Users/depp/projects/Prd_PO/feishu-mcp
./setup-feishu-mcp.sh
```

## 连接和认证

### Q6: tenant 和 user 认证有什么区别？

**A:**

| 特性 | tenant（应用凭证） | user（用户凭证） |
|------|------------------|----------------|
| **配置难度** | 简单，只需 App ID/Secret | 需要用户授权流程 |
| **适用场景** | 只读操作，批量处理 | 需要用户身份的操作 |
| **权限范围** | 应用权限 | 用户权限 |
| **推荐场景** | ✅ 读取文档（推荐） | 编辑文档、发送消息 |

**建议**：对于只读文档的场景，使用 `tenant` 模式。

### Q7: 如何获取飞书 App ID 和 Secret？

**A:** 详细步骤请参考 [飞书��用配置指南](FEISHU_APP_SETUP.md)。

简要步骤：
1. 访问 https://open.feishu.cn/
2. 创建企业自建应用
3. 在【凭证与基础信息】中查看 App ID 和 Secret

### Q8: App Secret 泄露了怎么办？

**A:**
1. 立即登录飞书开放平台
2. 进入应用管理
3. 重新生成 App Secret
4. 更新所有配置文件中的 Secret
5. 排查泄露原因，防止再次发生

⚠️ **不要**将包含真实凭证的配置文件提交到 Git！

### Q9: 如何验证 MCP Server 是否正常运行？

**A:**

**方法 1**：通过 Claude Desktop UI
1. Settings > Developer
2. 查看 MCP Servers 列表
3. "feishu" 应显示绿色运行状态

**方法 2**：在对话中测试
```
请测试飞书 MCP 连接
```

**方法 3**：查看日志
1. Settings > Developer > View Logs
2. 搜索 "feishu" 相关日志

## 文档访问

### Q10: 无法读取某个飞书文档？

**A:** 请检查：

1. **应用是否已添加到文档**
   - 打开飞书文档
   - 点击右上角【...】> 【添加应用】
   - 搜索并添加您的应用

2. **应用权限是否足够**
   - 检查是否已授予 `docx:document` 和 `docs:read` 权限
   - 在飞书开放平台 > 权限管理 中查看

3. **文档链接格式是否正确**
   - 支持格式：
     - `https://xxx.feishu.cn/docx/xxxxx`
     - `https://xxx.feishu.cn/docs/xxxxx`
     - `https://xxx.feishu.cn/wiki/xxxxx`

4. **应用是否已启用**
   - 在飞书开放平台检查应用状态

### Q11: 支持哪些类型的飞书文档？

**A:** 支持：
- ✅ 新版文档（Docs）
- ✅ 旧版文档
- ✅ 知识库（Wiki）
- ✅ 多维表格（需要相应权限）
- ✅ 文档评论

不支持：
- ❌ 飞书视频
- ❌ 飞书表单（部分功能）

### Q12: 如何批量处理文档？

**A:** 示例提示词：

```
请处理文件夹 <folder_token> 中的所有文档：
1. 读取每个文档
2. 提取标题和摘要
3. 输出为表格格式
```

详细示例见 [使用示例文档](USAGE_EXAMPLES.md#批量操作)。

### Q13: 文档很长，读取超时怎么办？

**A:** 分段处理：

```
这个文档很长，请分三次处理：
1. 第一次：读取前 1/3
2. 第二次：读取中间 1/3
3. 第三次：读取最后 1/3
最后整合结果

文档：https://xxx.feishu.cn/docx/xxxxx
```

### Q14: 如何搜索文档内容？

**A:** 使用搜索功能：

```
在文件夹 <folder_token> 中搜索包含"API 设计"的所有文档
```

或者：

```
在知识库 <wiki_id> 中搜索关于"性能优化"的内容
```

## 性能和限制

### Q15: 飞书 API 有速率限制吗？

**A:** 是的，飞书 API 有速率限制：
- 应用级别：10 QPS（每秒请求数）
- 租户级别：50 QPS

**建议**：
- 批量操作时适当限速
- 使用分批处理策略
- 避免短时间内大量请求

### Q16: 单次能处理多少个文档？

**A:**
- **理论上**：无限制
- **实践中**：建议每批 10-20 个文档
- **超过限制**：分批处理，避免超时

示例：

```
请分批处理，每批 10 个文档：
- 第 1 批：文档 1-10
- 第 2 批：文档 11-20
...
```

### Q17: MCP Server 的性能如何？

**A:**
- **启动时间**：通常 2-5 秒
- **单文档读取**：通常 1-3 秒
- **影响因素**：
  - 文档大小
  - 网络速度
  - API 响应时间

### Q18: 能缓存文档内容吗？

**A:**
- MCP Server 本身不缓存内容
- 每次请求都会实时获取最新内容
- 优点：确保数据最新
- 缺点：可能较慢

如需缓存，可以自己实现：

```
# 读取并保存到本地
请读取这个文档并保存为 Markdown：
https://xxx.feishu.cn/docx/xxxxx

保存为：document.md
```

## 故障排查

### Q19: MCP Server 无法启动？

**A:** 依次检查：

1. **Node.js 版本**
```bash
node --version  # 应 >= v18
```

2. **配置文件格式**
```bash
# 验证 JSON 格式
python3 -m json.tool ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

3. **查看日志**
- Claude Desktop > Settings > Developer > View Logs
- 搜索错误信息

4. **手动测试**
```bash
# 测试 MCP Server 是否可访问
npx -y feishu-mcp@latest --help
```

### Q20: 提示 "权限不足" 错误？

**A:**

1. **检查应用权限**
   - 登录飞书开放平台
   - 进入【权限管理】
   - 确认已授予必要权限

2. **必需权限**：
   - `docx:document` - 文档操作
   - `docs:read` - 读取文档
   - `drive:drive.readonly` - 访问云空间

3. **重新获取 token**
   - 重启 MCP Server
   - 重启 Claude Desktop

### Q21: 提示 "文档不存在" 错误？

**A:** 可能原因：

1. **文档已删除或移动**
   - 在飞书 Web 端确认文档是否存在

2. **应用未添加到文档**
   - 在文档中添加应用为协作者

3. **链接格式错误**
   - 检查链接格式是否正确
   - 尝试重新复制链接

### Q22: 配置正确但不生效？

**A:**

1. **确保完全重启**
```bash
# 完全退出 Claude Desktop
killall "Claude Desktop"

# 等待几秒后重启
open -a "Claude Desktop"
```

2. **清除缓存**
```bash
rm -rf ~/Library/Application\ Support/Claude/cache
```

3. **检查配置文件权限**
```bash
ls -l ~/Library/Application\ Support/Claude/claude_desktop_config.json
# 应该是 -rw------- (600)

# 如果不是，修改权限
chmod 600 ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Q23: 如何查看详细日志？

**A:**

**Claude Desktop 日志**：
1. Settings > Developer > View Logs
2. 或直接查看日志文件：
```bash
tail -f ~/Library/Logs/Claude/app.log
```

**MCP Server 日志**：
- 在 Claude Desktop 的开发者工具中查看

**飞书 API 日志**：
- 登录飞书开放平台
- 进入【日志查询】
- 查看 API 调用记录

## 安全和权限

### Q24: 如何保护 App Secret？

**A:**

1. **不要硬编码**
   - ❌ 不要将 Secret 写在代码中
   - ✅ 使用配置文件

2. **设置文件权限**
```bash
chmod 600 ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

3. **不要提交到 Git**
```bash
# 添加到 .gitignore
echo "claude_desktop_config.json" >> .gitignore
```

4. **定期轮换**
   - 建议每 3-6 个月更换一次
   - 在飞书开放平台重新生成

### Q25: 需要给应用授予哪些权限？

**A:**

**最小权限（只读）**：
- `docx:document` - 查看文档
- `docs:read` - 读取文档
- `drive:drive.readonly` - 访问云空间

**扩展权限（可选）**：
- `wiki:wiki.readonly` - 访问知识库
- `im:message` - 读取消息
- `bitable:app` - 访问多维表格

**原则**：只授予必需的最小权限。

### Q26: tenant 和 user 认证哪个更安全？

**A:**

**tenant（应用凭证）** - 推荐用于只读场景
- ✅ 权限范围受限于应用
- ✅ 无需用户授权
- ✅ 更易管理
- ❌ 不能以用户身份操作

**user（用户凭证）**
- ✅ 可以执行用户级操作
- ❌ 需要用户授权流程
- ❌ 权限范围更广

**建议**：对于只读文档，使用 tenant 更安全。

### Q27: 如何监控 API 使用情况？

**A:**

1. **飞书开放平台**
   - 登录 https://open.feishu.cn/
   - 进入【数据统计】
   - 查看 API 调用量和错误率

2. **设置告警**
   - 在飞书开放平台配置异常告警
   - 监控异常调用模式

3. **定期审查**
   - 每周检查一次使用情况
   - 识别异常调用模式

## 其他问题

### Q28: 支持 Windows 系统吗？

**A:**
- ✅ Claude Desktop 的 Windows 版本理论上支持
- ❌ 本配置脚本专为 Mac 设计
- ℹ️ Windows 用户需要手动配置

Windows 配置文件路径：
```
%APPDATA%\Claude\claude_desktop_config.json
```

### Q29: 可以同时配置多个 MCP Server 吗？

**A:** 可以！示例：

```json
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": ["-y", "feishu-mcp@latest", ...]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"]
    }
  }
}
```

### Q30: 如何更新 feishu-mcp 到最新版本？

**A:**

**使用 NPX（推荐）**：
- 自动使用最新版本，无需手动更新

**全局安装方式**：
```bash
npm update -g feishu-mcp
```

**本地开发方式**：
```bash
cd /path/to/Feishu-MCP
git pull
npm install
npm run build
```

### Q31: 遇到其他问题怎么办？

**A:**

1. **查看文档**
   - [飞书应用配置指南](FEISHU_APP_SETUP.md)
   - [Claude Desktop 配置指南](CLAUDE_DESKTOP_SETUP.md)
   - [使用示例](USAGE_EXAMPLES.md)

2. **检查日志**
   - Claude Desktop 日志
   - 飞书 API 日志

3. **提交 Issue**
   - [Feishu-MCP GitHub Issues](https://github.com/cso1z/Feishu-MCP/issues)

4. **联系支持**
   - 飞书开放平台工单系统
   - Claude 官方支持

---

**找不到答案？** 欢迎提交 Issue 或在社区讨论！
