# Figma MCP Server

从 PRD 文档自动生成 Figma 设计稿的 MCP Server

## 功能特性

✅ 自动解析 PRD 文档
✅ 生成可交互的 HTML 设计预览
✅ 应用完整的 UI 设计系统
✅ 支持飞书文档集成
✅ 一键式设计生成

## 快速开始

### 1. 安装依赖

```bash
npm install
```

### 2. 构建项目

```bash
npm run build
```

### 3. 配置 Claude Code

编辑 `~/.config/claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "figma": {
      "command": "node",
      "args": ["/Users/depp/projects/Prd_PO/figma/dist/index.js"]
    }
  }
}
```

### 4. 重启 Claude Code

重启 Claude Code 使配置生效。

## 使用方法

在 Claude Code 中输入:

```
读取 prd_po/广告批量创编功能PRD.md,生成设计预览
```

Claude 将自动:
1. 读取 PRD 文档
2. 解析页面结构和组件
3. 生成 HTML 设计预览
4. 返回文件路径

然后在浏览器中打开生成的 HTML 文件即可查看设计!

## 项目结构

```
figma/
├── package.json          # 项目配置
├── tsconfig.json         # TypeScript 配置
├── design-system.json    # UI 设计规范
├── src/
│   ├── index.ts          # MCP Server 入口
│   ├── design-system.ts  # 设计系统加载器
│   ├── prd-parser.ts     # PRD 解析器
│   ├── html-generator.ts # HTML 生成器
│   └── tools/
│       └── create-design.ts  # 主工具实现
├── dist/                 # 编译输出目录
└── output/              # 生成文件目录
    └── design-preview.html  # 设计预览文件
```

## 设计系统

项目使用 `design-system.json` 定义 UI 规范:

- **颜色**: 主色#1890FF, 成功/警告/错误色
- **字体**: PingFang SC, 14-24px
- **间距**: 8px 基础单位
- **组件**: 按钮/输入框/卡片样式

可以修改此文件自定义设计规范。

## 开发

```bash
# 开发模式
npm run dev

# 构建
npm run build

# 启动
npm start
```

## 测试

### 测试用例 1: 基础功能

在 Claude Code 中测试:

```
读取 prd_po/广告批量创编功能PRD.md 文件内容,
然后调用 figma MCP 的 create_design_from_prd 工具生成设计
```

预期结果:
- 成功解析 PRD
- 生成 HTML 文件
- 浏览器可以打开查看

### 测试用例 2: 飞书文档

```
读取飞书文档中的广告批量创编 PRD,生成设计预览
```

## 故障排查

### MCP Server 无法启动

1. 检查 Node.js 版本 (需要 v18+)
2. 确认项目已构建: `npm run build`
3. 查看 Claude Code 日志

### 无法解析 PRD

1. 确认 PRD 使用 Markdown 格式
2. 使用 `## ` 二级标题定义页面
3. 在列表中包含"按钮"/"输入框"/"卡片"等关键词

### 生成的 HTML 为空

1. 检查 PRD 内容是否正确
2. 查看终端错误信息
3. 确认 `output/` 目录有写权限

## 后续计划

- [ ] 增强 PRD 解析(使用 Claude 理解能力)
- [ ] 生成 Figma Plugin 代码
- [ ] 支持更多组件类型
- [ ] 响应式设计支持
- [ ] 设计规范检查工具

## 许可证

MIT
