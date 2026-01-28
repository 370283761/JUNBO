#!/bin/bash
# 飞书 MCP Server 验证脚本

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}飞书 MCP Server 验证${NC}"
echo ""

# 检查 Claude CLI
if ! command -v claude &> /dev/null; then
    echo -e "${RED}✗ Claude Code CLI 未安装${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Claude Code CLI 已安装${NC}"

# 检查 feishu MCP
if claude mcp list 2>/dev/null | grep -q "^feishu "; then
    echo -e "${GREEN}✓ feishu MCP Server 已配置${NC}"
    echo ""
    echo -e "${CYAN}配置信息：${NC}"
    claude mcp list | grep "feishu"
else
    echo -e "${RED}✗ feishu MCP Server 未配置${NC}"
    echo ""
    echo -e "${YELLOW}运行以下命令安装：${NC}"
    echo "  ./install.sh"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ 所有检查通过！${NC}"
