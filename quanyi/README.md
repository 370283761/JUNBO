# 飞书文档转产品设计规范工具

一个轻量级的工具，可以将飞书文档自动转换为标准化的产品需求文档（PRD）Markdown 格式。

## 功能特点

- ✅ 支持飞书文档链接直接转换
- ✅ 使用 Claude AI 智能提取和结构化内容
- ✅ 输出符合产品设计规范的标准 PRD 格式
- ✅ 支持自定义 Prompt 模板
- ✅ 配置简单，使用方便

## 前置要求

### 1. 飞书开放平台配置

1. 访问 [飞书开放平台](https://open.feishu.cn/)
2. 创建企业自建应用
3. 获取 `App ID` 和 `App Secret`
4. 开通以下权限：
   - `docx:document` - 查看、评论和编辑文档
   - `docs:read` - 查看文档

### 2. Claude API Key

1. 访问 [Anthropic Console](https://console.anthropic.com/)
2. 创建 API Key
3. 确保账户有足够的额度

### 3. Python 环境

- Python 3.8 及以上版本

## 安装步骤

### 1. 克隆或下载项目

```bash
cd /Users/depp/projects/Prd_PO/quanyi
```

### 2. 安装依赖

```bash
pip install -r requirements.txt
```

### 3. 配置密钥

#### 方式 A：使用配置文件（推荐）

复制配置文件模板：

```bash
cp config.json.example config.json
```

编辑 `config.json`，填入你的密钥：

```json
{
  "feishu_app_id": "cli_xxxxxxxxxx",
  "feishu_app_secret": "xxxxxxxxxxxxxxxx",
  "claude_api_key": "sk-ant-xxxxxxxxxxxxx",
  "output_dir": "../doc",
  "prompt_template_path": "prompt_template.txt"
}
```

#### 方式 B：使用环境变量

```bash
export FEISHU_APP_ID="cli_xxxxxxxxxx"
export FEISHU_APP_SECRET="xxxxxxxxxxxxxxxx"
export CLAUDE_API_KEY="sk-ant-xxxxxxxxxxxxx"
export OUTPUT_DIR="../doc"
```

## 使用方法

### 基础用法

```bash
python feishu_to_prd.py "https://xxx.feishu.cn/docx/xxxxx"
```

### 指定输出文件名

```bash
python feishu_to_prd.py "https://xxx.feishu.cn/docx/xxxxx" -o "我的产品PRD.md"
```

### 指定配置文件路径

```bash
python feishu_to_prd.py "https://xxx.feishu.cn/docx/xxxxx" -c "/path/to/config.json"
```

### 支持的飞书链接格式

工具支持多种飞书文档链接格式：

- `https://xxx.feishu.cn/docx/xxxxx` - 新版文档
- `https://xxx.feishu.cn/docs/xxxxx` - 旧版文档
- `https://xxx.feishu.cn/wiki/xxxxx` - Wiki 文档
- 直接使用文档 ID: `xxxxx`

## 输出示例

转换后的 PRD 文档将包含以下标准章节：

1. 文档信息
2. 需求背景
3. 需求目标
4. 目标用户
5. 功能设计
6. 交互设计
7. 技术方案
8. 上线计划
9. 验收标准
10. 风险评估
11. 附录

## 自定义 Prompt 模板

如果需要调整 PRD 生成的格式和内容，可以编辑 `prompt_template.txt` 文件。

模板中支持以下变量：
- `{doc_title}` - 文档标题
- `{doc_content}` - 文档内容
- `{current_date}` - 当前日期

## 项目结构

```
quanyi/
├── feishu_to_prd.py       # 主程序
├── prompt_template.txt     # Prompt 模板
├── config.json.example     # 配置文件示例
├── requirements.txt        # Python 依赖
├── .gitignore             # Git 忽略文件
└── README.md              # 使用说明
```

## 常见问题

### Q1: 提示 "获取 token 失败"

**原因**: App ID 或 App Secret 配置错误

**解决**:
1. 检查飞书开放平台的应用凭证
2. 确认 `config.json` 中的配置正确
3. 确保应用状态为"已启用"

### Q2: 提示 "获取文档内容失败"

**原因**: 应用权限不足或文档 ID 错误

**解决**:
1. 确认应用已开通 `docx:document` 和 `docs:read` 权限
2. 检查飞书文档链接是否正确
3. 确认应用已添加到对应的飞书文档可见范围

### Q3: 提示 Claude API 错误

**原因**: API Key 无效或额度不足

**解决**:
1. 检查 API Key 是否正确
2. 访问 Anthropic Console 查看账户状态
3. 确认 API 额度充足

### Q4: 生成的 PRD 内容不完整

**原因**: 原始文档结构不规范或信息缺失

**解决**:
1. 检查原始飞书文档是否包含完整信息
2. 可以编辑 `prompt_template.txt` 调整提取规则
3. 手动补充生成的 PRD 中标注为 "[待补充]" 的部分

## 高级用法

### 批量转换

创建一个包含多个文档链接的文件 `docs.txt`:

```
https://xxx.feishu.cn/docx/doc1
https://xxx.feishu.cn/docx/doc2
https://xxx.feishu.cn/docx/doc3
```

编写批处理脚本 `batch_convert.sh`:

```bash
#!/bin/bash
while IFS= read -r url; do
  echo "Processing: $url"
  python feishu_to_prd.py "$url"
done < docs.txt
```

运行：

```bash
chmod +x batch_convert.sh
./batch_convert.sh
```

### 集成到工作流

可以将此工具集成到 CI/CD 流程或定时任务中：

```bash
# 每天定时转换指定文档
0 9 * * * cd /path/to/quanyi && python feishu_to_prd.py "https://xxx.feishu.cn/docx/xxxxx"
```

## 注意事项

1. **API 费用**: 使用 Claude API 会产生费用，请根据文档长度和转换频率预估成本
2. **权限管理**: 确保飞书应用只授予必要的最小权限
3. **敏感信息**: `config.json` 包含敏感信息，请勿提交到代码仓库
4. **文档质量**: 原始文档的质量直接影响生成 PRD 的质量，建议飞书文档尽量结构化

## 更新日志

### v1.0.0 (2026-01-16)
- ✨ 初始版本发布
- ✅ 支持飞书文档内容获取
- ✅ 支持 Claude AI 智能转换
- ✅ 标准化 PRD 模板输出

## 许可证

MIT License

## 技术支持

如遇问题或有改进建议，欢迎提交 Issue。
