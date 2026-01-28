#!/bin/bash

##############################################################################
# 飞书 MCP Server 诊断脚本
# Feishu MCP Server Diagnostic Script
##############################################################################

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║           飞书 MCP Server 诊断工具 v1.0                         ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

##############################################################################
# 1. 检查 Claude CLI 配置位置
##############################################################################

echo -e "${YELLOW}▶ 检查 1/8: Claude CLI 配置位置${NC}"
echo ""

CLAUDE_CLI_CONFIG_LOCATIONS=(
    "$HOME/.config/claude/config.json"
    "$HOME/.claude/config.json"
    "$HOME/Library/Application Support/Claude/config.json"
)

echo "正在搜索 Claude CLI 配置文件..."
for config in "${CLAUDE_CLI_CONFIG_LOCATIONS[@]}"; do
    if [ -f "$config" ]; then
        echo -e "${GREEN}✓ 找到:${NC} $config"
        echo "内容预览:"
        cat "$config" | head -20
        echo ""
    fi
done

##############################################################################
# 2. 检查 Claude Desktop 配置位置
##############################################################################

echo -e "${YELLOW}▶ 检查 2/8: Claude Desktop 配置位置${NC}"
echo ""

CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
    echo -e "${GREEN}✓ 找到 Claude Desktop 配置文件${NC}"
    echo "位置: $CLAUDE_DESKTOP_CONFIG"
    echo ""
    echo "完整内容:"
    cat "$CLAUDE_DESKTOP_CONFIG"
    echo ""

    # 检查是否包含 feishu
    if grep -q "feishu" "$CLAUDE_DESKTOP_CONFIG"; then
        echo -e "${GREEN}✓ 配置文件中包含 feishu${NC}"
    else
        echo -e "${RED}✗ 配置文件中未找到 feishu${NC}"
    fi
else
    echo -e "${RED}✗ 未找到 Claude Desktop 配置文件${NC}"
fi

echo ""

##############################################################################
# 3. 检查是否有多个配置文件
##############################################################################

echo -e "${YELLOW}▶ 检查 3/8: 搜索所有可能的配置文件${NC}"
echo ""

echo "搜索所有 claude_desktop_config.json 文件..."
find "$HOME/Library" -name "claude_desktop_config.json" 2>/dev/null | while read -r file; do
    echo -e "${CYAN}找到:${NC} $file"
    echo "内容:"
    cat "$file"
    echo ""
done

##############################################################################
# 4. 检查 Claude CLI MCP 配置
##############################################################################

echo -e "${YELLOW}▶ 检查 4/8: Claude CLI MCP 列表${NC}"
echo ""

if command -v claude &> /dev/null; then
    echo "运行: claude mcp list"
    claude mcp list
    echo ""
else
    echo -e "${YELLOW}⚠ claude 命令未找到${NC}"
fi

##############################################################################
# 5. 检查 Node.js 和 npx
##############################################################################

echo -e "${YELLOW}▶ 检查 5/8: Node.js 环境${NC}"
echo ""

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ Node.js:${NC} $NODE_VERSION"
else
    echo -e "${RED}✗ Node.js 未安装${NC}"
fi

if command -v npx &> /dev/null; then
    NPX_PATH=$(which npx)
    echo -e "${GREEN}✓ npx:${NC} $NPX_PATH"
else
    echo -e "${RED}✗ npx 未找到${NC}"
fi

echo ""

##############################################################################
# 6. 测试 feishu-mcp 包
##############################################################################

echo -e "${YELLOW}▶ 检查 6/8: 测试 feishu-mcp 包${NC}"
echo ""

echo "尝试运行: npx -y feishu-mcp@latest --help"
timeout 10s npx -y feishu-mcp@latest --help 2>&1 || echo -e "${RED}✗ 无法运行 feishu-mcp${NC}"
echo ""

##############################################################################
# 7. 检查 Claude Desktop 进程
##############################################################################

echo -e "${YELLOW}▶ 检查 7/8: Claude Desktop 进程${NC}"
echo ""

if ps aux | grep -i "[C]laude" > /dev/null; then
    echo -e "${GREEN}✓ Claude Desktop 正在运行${NC}"
    ps aux | grep -i "[C]laude"
else
    echo -e "${YELLOW}⚠ Claude Desktop 未运行${NC}"
fi

echo ""

##############################################################################
# 8. 生成诊断报告
##############################################################################

echo -e "${YELLOW}▶ 检查 8/8: 系统信息${NC}"
echo ""

echo "操作系统: $(sw_vers -productName) $(sw_vers -productVersion)"
echo "用户目录: $HOME"
echo "当前用户: $(whoami)"
echo ""

##############################################################################
# 诊断结果总结
##############################################################################

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                     诊断结果总结                                ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${YELLOW}【可能的问题】${NC}"
echo ""
echo "1️⃣  配置文件位置不正确"
echo "   Claude CLI 和 Claude Desktop 使用不同的配置文件"
echo "   • Claude CLI: ~/.config/claude/config.json"
echo "   • Claude Desktop: ~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""

echo "2️⃣  需要重启 Claude Desktop"
echo "   配置文件修改后，必须完全重启 Claude Desktop"
echo ""

echo "3️⃣  Claude CLI 可能使用独立配置"
echo "   'claude mcp list' 读取的是 CLI 配置，不是 Desktop 配置"
echo ""

echo -e "${YELLOW}【建议的解决方案】${NC}"
echo ""
echo "▶ 方案 1: 检查 Claude CLI 配置位置"
echo "  运行以下命令查看 CLI 实际使用的配置:"
echo -e "  ${CYAN}claude config show${NC}"
echo ""

echo "▶ 方案 2: 直接在 Claude Desktop 中验证"
echo "  不要依赖 'claude mcp list' 命令，而是:"
echo "  1. 完全退出 Claude Desktop (Cmd+Q)"
echo "  2. 等待 5 秒"
echo "  3. 重新启动 Claude Desktop"
echo "  4. 打开 Settings > Developer"
echo "  5. 查看是否有 'feishu' MCP Server"
echo ""

echo "▶ 方案 3: 为 Claude CLI 也添加配置"
echo "  如果需要在 CLI 中使用，需要额外配置 CLI 的 MCP 设置"
echo ""

echo -e "${GREEN}诊断完成！${NC}"
echo ""
echo "如需保存诊断结果，运行:"
echo "  ./diagnose.sh > diagnostic_report.txt"
echo ""