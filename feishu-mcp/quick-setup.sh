#!/bin/bash

##############################################################################
# 快速配置脚本 - Claude Desktop 飞书 MCP
##############################################################################

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}飞书 MCP 快速配置${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 配置文件路径
CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
CLAUDE_DESKTOP_DIR=$(dirname "$CLAUDE_DESKTOP_CONFIG")

# 创建目录
if [ ! -d "$CLAUDE_DESKTOP_DIR" ]; then
    echo -e "${YELLOW}创建 Claude Desktop 配置目录...${NC}"
    mkdir -p "$CLAUDE_DESKTOP_DIR"
fi

# 备份现有配置
if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
    BACKUP_FILE="${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$CLAUDE_DESKTOP_CONFIG" "$BACKUP_FILE"
    echo -e "${GREEN}✓ 已备份现有配置到: $BACKUP_FILE${NC}"
fi

# 获取凭证
echo ""
echo "请输入飞书应用凭证："
echo ""
read -p "飞书 App ID (格式如 cli_xxxxxxxxxx): " FEISHU_APP_ID
echo ""
read -sp "飞书 App Secret: " FEISHU_APP_SECRET
echo ""
echo ""

# 验证输入
if [[ ! $FEISHU_APP_ID =~ ^cli_ ]]; then
    echo -e "${YELLOW}⚠ 警告: App ID 格式可能不正确，通常应该以 cli_ 开头${NC}"
    read -p "是否继续？[y/N]: " CONTINUE
    if [[ ! $CONTINUE =~ ^[Yy]$ ]]; then
        echo "已取消配置"
        exit 0
    fi
fi

if [ -z "$FEISHU_APP_SECRET" ]; then
    echo -e "${RED}错误: App Secret 不能为空${NC}"
    exit 1
fi

# 选择认证类型
echo ""
echo "选择认证类型："
echo "1) tenant - 应用访问凭证（推荐，适合只读操作）"
echo "2) user - 用户访问凭证（需要用户授权）"
read -p "请选择 [1/2，默认为 1]: " AUTH_CHOICE

if [ "$AUTH_CHOICE" = "2" ]; then
    FEISHU_AUTH_TYPE="user"
else
    FEISHU_AUTH_TYPE="tenant"
fi

# 创建配置文件
echo ""
echo -e "${BLUE}正在创建配置文件...${NC}"

cat > "$CLAUDE_DESKTOP_CONFIG" <<EOF
{
  "mcpServers": {
    "feishu": {
      "command": "npx",
      "args": [
        "-y",
        "feishu-mcp@latest",
        "--feishu-app-id=$FEISHU_APP_ID",
        "--feishu-app-secret=$FEISHU_APP_SECRET",
        "--feishu-auth-type=$FEISHU_AUTH_TYPE"
      ]
    }
  }
}
EOF

# 设置权限
chmod 600 "$CLAUDE_DESKTOP_CONFIG"

# 验证 JSON 格式
if python3 -m json.tool "$CLAUDE_DESKTOP_CONFIG" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ 配置文件创建成功！${NC}"
else
    echo -e "${RED}✗ 配置文件格式错误${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}配置完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "📝 配置信息："
echo "   - App ID: $FEISHU_APP_ID"
echo "   - 认证类型: $FEISHU_AUTH_TYPE"
echo "   - 配置文件: $CLAUDE_DESKTOP_CONFIG"
echo ""
echo "🔄 下一步操作："
echo ""
echo "1. 重启 Claude Desktop"
echo "   - 完全退出 Claude Desktop（菜单栏 > Quit，或按 Cmd+Q）"
echo "   - 等待 3-5 秒"
echo "   - 重新启动 Claude Desktop"
echo ""
echo "2. 验证配置"
echo "   - 打开 Claude Desktop"
echo "   - Settings > Developer"
echo "   - 检查 'feishu' server 是否显示为运行状态（绿色）"
echo ""
echo "3. 测试功能"
echo "   在 Claude 对话框中输入："
echo "   '请读取这个飞书文档：https://gz-junbo.feishu.cn/docx/Yba9dCWlKofqxIxjJZmcT7vanff'"
echo ""
echo -e "${GREEN}✨ 祝使用愉快！${NC}"
echo ""
