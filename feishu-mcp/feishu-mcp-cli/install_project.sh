#!/bin/bash
# 项目级 MCP Server 安装脚本
# 在当前项目创建 .mcp.json 配置文件

set -e

FEISHU_APP_ID="cli_a761f9c6d1ffd00e"
FEISHU_APP_SECRET="VNhXgzmowleKU068HSaFqei0ZWrNSqtS"
FEISHU_AUTH_TYPE="tenant"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}飞书 MCP Server 项目级安装${NC}"
echo ""

if [ -f ".mcp.json" ]; then
    echo -e "${YELLOW}⚠ .mcp.json 已存在${NC}"
    read -p "是否覆盖? [y/N]: " OVERWRITE
    if [[ ! $OVERWRITE =~ ^[Yy]$ ]]; then
        echo "已取消"
        exit 0
    fi
fi

cat > .mcp.json << 'EOF'
{
  "feishu": {
    "command": "npx",
    "args": [
      "-y",
      "feishu-mcp@latest",
      "--feishu-app-id=cli_a761f9c6d1ffd00e",
      "--feishu-app-secret=VNhXgzmowleKU068HSaFqei0ZWrNSqtS",
      "--feishu-auth-type=tenant"
    ]
  }
}
EOF

echo -e "${GREEN}✓ 已创建 .mcp.json${NC}"
echo ""
echo -e "${CYAN}使用方法：${NC}"
echo "  claude  # 在此项目目录运行"
echo ""
echo -e "${YELLOW}注意：${NC}"
echo "  • .mcp.json 包含密钥，不要提交到公共仓库"
echo "  • 建议添加到 .gitignore"
echo ""
