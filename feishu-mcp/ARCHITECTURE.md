# 飞书 MCP 项目架构

## 系统架构图

```
┌─────────────────────────────────────────────────────────────┐
│                        用户层                                 │
│  ┌──────────────────┐          ┌──────────────────┐        │
│  │  Claude Desktop  │          │  Claude Code CLI │        │
│  │   (Mac 应用)      │          │   (终端工具)      │        │
│  └────────┬─────────┘          └────────┬─────────┘        │
└───────────┼──────────────────────────────┼─────────────────┘
            │                              │
            │  配置文件                     │  配置文件
            │  claude_desktop_config.json  │  config.json
            │                              │
┌───────────┼──────────────────────────────┼─────────────────┐
│           │      MCP 协议层               │                 │
│  ┌────────▼──────────────────────────────▼────────┐        │
│  │         Model Context Protocol (MCP)          │        │
│  │         标准化的 AI 工具通信协议               │        │
│  └────────┬──────────────────────────────────────┘        │
└───────────┼─────────────────────────────────────────────────┘
            │
            │  NPX 启动
            │
┌───────────▼─────────────────────────��───────────────────────┐
│                    MCP Server 层                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Feishu-MCP Server                       │   │
│  │        (cso1z/Feishu-MCP from NPM)                  │   │
│  │                                                       │   │
│  │  功能模块：                                           │   │
│  │  • 文档读取        • 知识库浏览                       │   │
│  │  • 内容搜索        • 格式转换                         │   │
│  │  • 批量处理        • 权限管理                         │   │
│  └────────┬─────────────────────────────────────────────┘   │
└───────────┼─────────────────────────────────────────────────┘
            │
            │  认证: App ID + App Secret
            │  认证类型: tenant (应用凭证) / user (用户凭证)
            │
┌───────────▼─────────────────────────────────────────────────┐
│                    飞书 API 层                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              飞书开放平台 OpenAPI                     │   │
│  │         https://open.feishu.cn/open-apis             │   │
│  │                                                       │   │
│  │  核心 API：                                           │   │
│  │  • /docx/v1/documents/{doc_id}/raw_content          │   │
│  │  • /drive/v1/files                                  │   │
│  │  • /wiki/v2/spaces                                  │   │
│  │  • /auth/v3/tenant_access_token/internal            │   │
│  └────────┬─────────────────────────────────────────────┘   │
└───────────┼─────────────────────────────────────────────────┘
            │
            │  返回文档内容
            │
┌───────────▼─────────────────────────────────────────────────┐
│                    数据层                                     │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                 飞书云文档系统                        │   │
│  │                                                       │   │
│  │  • 新版文档 (Docs)                                    │   │
│  │  • 旧版文档                                           │   │
│  │  • 知识库 (Wiki)                                      │   │
│  │  • 多维表格 (Bitable)                                 │   │
│  │  • 云空间文件                                         │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 数据流程

### 1. 读取文档流程

```
用户请求 (Claude Desktop)
    │
    ▼
提示词: "读取文档 https://xxx.feishu.cn/docx/xxxxx"
    │
    ▼
Claude 解析请求 → 调用 Feishu MCP Server
    │
    ▼
MCP Server 处理:
    1. 解析文档链接，提取 doc_id
    2. 使用 App ID/Secret 获取 tenant_access_token
    3. 调用飞书 API: GET /docx/v1/documents/{doc_id}/raw_content
    │
    ▼
飞书 API 验证:
    1. 检查 token 有效性
    2. 检查应用权限 (docx:document, docs:read)
    3. 检查文档访问权限
    │
    ▼
返回文档数据 (JSON格式):
    {
      "content": "文档原始内容",
      "title": "文档标题",
      "revision": "版本号",
      ...
    }
    │
    ▼
MCP Server 处理响应 → 转换为 Claude 可读格式
    │
    ▼
Claude 处理内容 → 生成回复
    │
    ▼
展示给用户
```

### 2. 认证流程

```
MCP Server 启动
    │
    ▼
读取配置:
    • FEISHU_APP_ID
    • FEISHU_APP_SECRET
    • FEISHU_AUTH_TYPE (tenant/user)
    │
    ▼
[tenant 模式]                    [user 模式]
    │                                │
    ▼                                ▼
请求应用访问凭证:                用户授权流程:
POST /auth/v3/                  1. 获取授权码
tenant_access_token/internal    2. 换取 user_access_token
    │                                │
    ▼                                ▼
获得 tenant_access_token         获得 user_access_token
(有效期: 2小时)                   (需定期刷新)
    │                                │
    └────────────┬───────────────────┘
                 ▼
         缓存 token，用于后续 API 调用
                 │
                 ▼
         token 过期前自动刷新
```

## 目录结构

```
feishu-mcp/
│
├── 📄 README.md                      # 项目总览，快速入门
├── 📄 QUICKSTART.md                  # 3 步快速开始指南
├── 📄 FEISHU_APP_SETUP.md           # 飞书应用配置详细步骤
├── 📄 CLAUDE_DESKTOP_SETUP.md       # Claude 配置详细步骤
├── 📄 USAGE_EXAMPLES.md             # 丰富的使用示例和提示词
├── 📄 FAQ.md                        # 常见问题解答（31个问题）
├── 📄 TESTING.md                    # 完整的测试验证指南
├── 📄 .gitignore                    # Git 忽略规则
│
├── 🔧 setup-feishu-mcp.sh          # 一键配置脚本（推荐使用）
│
└── 📁 config/                       # 配置文件目录
    ├── 📄 README.md                 # 配置说明
    ├── 📄 claude_desktop_config.json.example  # Claude Desktop 配置模板
    └── 📄 claude_code_config.json.example     # Claude Code 配置模板
```

## 配置文件关系

```
~/Library/Application Support/Claude/
└── claude_desktop_config.json       ← Claude Desktop 配置
    {
      "mcpServers": {
        "feishu": {
          "command": "npx",
          "args": [
            "-y",
            "feishu-mcp@latest",
            "--feishu-app-id=cli_xxxx",      ← 飞书 App ID
            "--feishu-app-secret=xxxx",      ← 飞书 App Secret
            "--feishu-auth-type=tenant"      ← 认证类型
          ]
        }
      }
    }

~/.claude/
└── config.json                      ← Claude Code CLI 配置
    {
      "primaryApiKey": "sk-ant-...",
      "mcpServers": {
        "feishu": { ... }              ← 同上配置
      }
    }
```

## 权限映射

```
飞书开放平台应用权限
    │
    ├── docx:document ────────┐
    │   (查看、评论和编辑文档)  │
    │                         ├──→ 允许读取新版文档内容
    ├── docs:read ────────────┘
    │   (查看文档)
    │
    ├── drive:drive.readonly ─────→ 允许列出文件夹和文档
    │   (查看云空间文件)
    │
    ├── wiki:wiki.readonly ───────→ 允许访问知识库
    │   (查看知识库)
    │
    └── im:message ───────────────→ 允许读取消息（可选）
        (获取与发送消息)
```

## 安全架构

```
┌─────────────────────────────────────────────────────────┐
│                     安全层                               │
│                                                         │
│  1. 凭证保护                                            │
│     • App Secret 不提交到 Git (.gitignore)              │
│     • 配置文件权限 600 (仅所有者可读写)                  │
│     • 定期轮换 Secret (3-6个月)                         │
│                                                         │
│  2. 权限最小化                                          │
│     • 使用 tenant 模式（应用凭证）而非 user 模式         │
│     • 只申请必需的 API 权限                             │
│     • 只读场景不授予编辑权限                            │
│                                                         │
│  3. 访问控制                                            │
│     • 应用需要被添加到文档的协作者列表                   │
│     • 飞书 API 速率限制：10 QPS (应用级别)              │
│     • Token 自动刷新机制                                │
│                                                         │
│  4. 审计和监控                                          │
│     • 飞书开放平台提供 API 调用日志                     │
│     • 异常调用告警机制                                  │
│     • 定期审查权限和使用情况                            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 使用流程

### 首次配置流程

```
1. 准备阶段
   ├─ 确认 Mac 系统
   ├─ 安装 Node.js (v18+)
   ├─ 安装 Claude Desktop
   └─ 拥有飞书企业账号

2. 飞书配置
   ├─ 访问 https://open.feishu.cn/
   ├─ 创建企业自建应用
   ├─ 获取 App ID 和 App Secret
   ├─ 申请必需权限
   └─ 启用应用

3. MCP 配置
   ├─ 运行 ./setup-feishu-mcp.sh
   ├─ 或手动编辑配置文件
   └─ 重启 Claude Desktop

4. 测试验证
   ├─ 检查 MCP Server 状态
   ├─ 测试连接
   ├─ 读取测试文档
   └─ 验证功能

5. 开始使用
   └─ 在 Claude 中处理飞书文档
```

### 日常使用流程

```
打开 Claude Desktop
    │
    ▼
MCP Server 自动启动 (通过 npx)
    │
    ▼
输入包含飞书文档链接的提示词
    │
    ▼
Claude 自动调用 Feishu MCP
    │
    ▼
获取并处理文档内容
    │
    ▼
返回处理结果
```

## 扩展性

### 当前支持的 MCP Servers

```
Claude Desktop
    │
    ├── feishu (飞书文档)
    ├── github (GitHub 仓库)          ← 可同时配置
    ├── filesystem (本地文件系统)     ← 可同时配置
    └── ... (其他 MCP Servers)        ← 可扩展
```

### 与现有工具集成

```
飞书 MCP Server
    │
    ├──→ Claude Desktop ──→ 交互式处理文档
    │
    ├──→ Claude Code CLI ──→ 命令行自动化
    │
    └──→ 现有 Python 工具 (quanyi/feishu_to_prd.py)
         └──→ 可以互补使用
              • MCP: 实时交互式处理
              • Python: 批量自动化处理
```

## 参考资源

- **Model Context Protocol**: https://modelcontextprotocol.io/
- **Feishu-MCP GitHub**: https://github.com/cso1z/Feishu-MCP
- **飞书开放平台**: https://open.feishu.cn/
- **Claude 官方文档**: https://support.claude.com/

---

**此架构图帮助理解整个系统的工作原理和各组件之间的关系。**
