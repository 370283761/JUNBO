#!/bin/bash

##############################################################################
# 飞书 MCP 安装验证脚本
# 用于验证一键安装是否成功
##############################################################################

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}  飞书 MCP Server 安装验证${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# 检查配置文件
echo -n "检查配置文件是否存在... "
if [ -f "$HOME/Library/Application Support/Claude/claude_desktop_config.json" ]; then
    echo -e "${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

# 检查文件权限
echo -n "检查配置文件权限... "
PERMS=$(stat -f "%A" "$HOME/Library/Application Support/Claude/claude_desktop_config.json" 2>/dev/null)
if [ "$PERMS" = "600" ]; then
    echo -e "${GREEN}✓ 通过 (600)${NC}"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ 警告 ($PERMS，建议 600)${NC}"
fi

# 检查 JSON 格式
echo -n "检查 JSON 格式... "
if python3 -m json.tool "$HOME/Library/Application Support/Claude/claude_desktop_config.json" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

# 检查 Node.js
echo -n "检查 Node.js 环境... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ 通过 ($NODE_VERSION)${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

# 检查 MCP Server 配置
echo -n "检查 MCP Server 配置... "
if grep -q "feishu-mcp" "$HOME/Library/Application Support/Claude/claude_desktop_config.json" 2>/dev/null; then
    echo -e "${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

# 检查 App ID
echo -n "检查 App ID 配置... "
if grep -q "cli_a761f9c6d1ffd00e" "$HOME/Library/Application Support/Claude/claude_desktop_config.json" 2>/dev/null; then
    echo -e "${GREEN}✓ 通过${NC}"
    ((PASS_COUNT++))
else
    echo -e "${RED}✗ 失败${NC}"
    ((FAIL_COUNT++))
fi

# 检查认证类型
echo -n "检查认证类型... "
if grep -q "tenant" "$HOME/Library/Application Support/Claude/claude_desktop_config.json" 2>/dev/null; then
    echo -e "${GREEN}✓ 通过 (tenant)${NC}"
    ((PASS_COUNT++))
else
    echo -e "${YELLOW}⚠ 警告（非 tenant）${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "总计: ${GREEN}$PASS_COUNT 通过${NC}, ${RED}$FAIL_COUNT 失败${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ 安装验证成功！${NC}"
    echo ""
    echo "下一步："
    echo "1. 重启 Claude Desktop"
    echo "2. 在 Settings > Developer 中检查 MCP Server 状态"
    echo "3. 测试读取飞书文档"
    echo ""
else
    echo -e "${RED}✗ 安装验证失败${NC}"
    echo ""
    echo "请重新运行安装脚本："
    echo "./install.sh"
    echo ""
fi
