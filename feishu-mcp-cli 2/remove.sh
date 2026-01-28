#!/bin/bash
# 飞书 MCP Server 卸载脚本

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}飞书 MCP Server 卸载${NC}"
echo ""

if ! claude mcp list 2>/dev/null | grep -q "^feishu "; then
    echo "feishu MCP Server 未安装"
    exit 0
fi

claude mcp remove feishu

echo ""
echo -e "${GREEN}✓ 已移除 feishu MCP Server${NC}"
echo ""
