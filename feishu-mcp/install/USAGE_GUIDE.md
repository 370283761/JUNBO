# 飞书 MCP 使用指南

## 🎯 基础使用

### 读取单个文档

```
请读取这个飞书文档：
https://xxx.feishu.cn/docx/xxxxx
```

### 读取 Wiki 文档

```
请读取这个飞书 Wiki：
https://xxx.feishu.cn/wiki/xxxxx
```

### 总结文档内容

```
请读取这个飞书文档并总结主要内容：
https://xxx.feishu.cn/docx/xxxxx
```

## 📝 常用功能

### 1. 提取信息

```
从这个飞书文档中提取：
1. 文档标题
2. 主要章节
3. 关键要点

文档链接：https://xxx.feishu.cn/docx/xxxxx
```

### 2. 格式转换

```
将这个飞书文档转换为 Markdown 格式：
https://xxx.feishu.cn/docx/xxxxx

要求：
- 保留标题层级
- 保留列表格式
```

### 3. 内容分析

```
分析这个飞书文档：
1. 文档类型（需求/方案/会议纪要）
2. 完整性评分（1-10分）
3. 改进建议

文档链接：https://xxx.feishu.cn/docx/xxxxx
```

### 4. 对比文档

```
对比以下两个版本的文档：
1. V1: https://xxx.feishu.cn/docx/aaa
2. V2: https://xxx.feishu.cn/docx/bbb

分析主要变化
```

## 🚀 高级用法

### 批量处理

```
列出这个文件夹中的所有文档：
https://xxx.feishu.cn/drive/folder/xxxxx

并为每个文档生成摘要
```

### 知识提取

```
从这个飞书文档提取知识点：
- 核心概念及定义
- 操作步骤
- 最佳实践
- 注意事项

文档：https://xxx.feishu.cn/docx/xxxxx
```

### 生成报告

```
基于这个飞书需求文档：
https://xxx.feishu.cn/docx/xxxxx

生成技术方案，包括：
- 系统架构
- 数据模型
- 接口设计
```

## 💡 实用技巧

### 技巧 1：指定输出格式

```
请按以下 JSON 格式输出文档摘要：

{
  "title": "文档标题",
  "summary": "摘要内容",
  "keywords": ["关键词1", "关键词2"]
}

文档：https://xxx.feishu.cn/docx/xxxxx
```

### 技巧 2：分段处理长文档

```
这是一个很长的文档，请分三次处理：
1. 第一次：读取前 1/3
2. 第二次：读取中间 1/3
3. 第三次：读取最后 1/3

文档：https://xxx.feishu.cn/docx/xxxxx
```

### 技巧 3：结合现有信息

```
基于以下背景信息：
[你的背景信息]

分析这个飞书文档：
https://xxx.feishu.cn/docx/xxxxx
```

## 🎯 实际示例

### 示例 1：产品需求分析

**输入**：
```
分析这个产品需求文档，提取：
- 目标用户
- 核心功能
- 技术要求
- 上线时间

文档：https://xxx.feishu.cn/docx/xxxxx
```

### 示例 2：会议纪要整理

**输入**：
```
从这个会议纪要中提取：
- 讨论议题
- 决策事项
- 待办任务（负责人、截止时间）

文档：https://xxx.feishu.cn/docx/xxxxx
```

### 示例 3：技术文档学习

**输入**：
```
学习这个技术文档，生成：
- 知识点总结
- 示例代码
- 最佳实践

文档：https://xxx.feishu.cn/wiki/xxxxx
```

## ⚠️ 注意事项

### 文档访问权限

确保飞书应用已添加到文档：
1. 打开飞书文档
2. 点击右上角【...】
3. 选择【添加应用】
4. 搜索并添加应用

### 首次使用授权

首次读取文档时，选择：
```
✓ Yes, and don't ask again for junbo-feishu-mcp commands
```

### 文档链接格式

支持的链接格式：
- `https://xxx.feishu.cn/docx/xxxxx` - 新版文档
- `https://xxx.feishu.cn/docs/xxxxx` - 旧版文档
- `https://xxx.feishu.cn/wiki/xxxxx` - Wiki 文档

## 📊 性能提示

- **小文档**（< 5页）：通常 < 5 秒
- **中文档**（5-20页）：通常 5-15 秒
- **大文档**（> 20页）：建议分段处理

## 🆘 遇到问题？

### 权限错误
- 检查应用是否已添加到文档
- 确认应用权限是否充足

### 读取超时
- 尝试分段处理
- 检查网络连接

### 内容不完整
- 检查原始文档是否完整
- 尝试重新读取

更多问题查看：[FAQ.md](FAQ.md)

---

**开始使用这些提示词，让 Claude 帮您处理飞书文档！** 🚀
