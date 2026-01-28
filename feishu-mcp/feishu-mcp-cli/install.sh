#!/bin/bash

##############################################################################
# 飞书 MCP Server 一键安装脚本 (Claude Code CLI 版本)
# 版本: 2.0.1
# 日期: 2026-01-20
# 说明: 自动配置 Claude Code CLI 以支持飞书文档读取
##############################################################################

# 不使用 set -e，改为手动检查每个步骤
# set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置参数（已预设）
FEISHU_APP_ID="cli_a761f9c6d1ffd00e"
FEISHU_APP_SECRET="VNhXgzmowleKU068HSaFqei0ZWrNSqtS"
FEISHU_AUTH_TYPE="tenant"
MCP_SERVER_NAME="feishu"

##############################################################################
# 工具函数
##############################################################################

print_banner() {
    # 安全的清屏 - 检查 TERM 环境变量
    if [ -n "$TERM" ] && [ "$TERM" != "dumb" ]; then
        clear 2>/dev/null || true
    fi
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║       飞书 MCP Server 一键安装脚本 (CLI 版本)                  ║"
    echo "║       Feishu MCP Server Auto Installer (CLI Version)          ║"
    echo "║                                                                ║"
    echo "║       让 Claude Code CLI 能够读取和处理飞书文档                ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

##############################################################################
# 环境检查
##############################################################################

check_environment() {
    print_step "步骤 1/4: 检查系统环境"

    # 检查操作系统
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "此脚本仅支持 macOS 系统"
        exit 1
    fi
    print_success "操作系统: macOS"

    # 检查 Claude Code CLI
    if ! command -v claude &> /dev/null; then
        print_error "Claude Code CLI 未安装"
        echo ""
        echo -e "${YELLOW}⚠️  重要提示：${NC}"
        echo ""
        echo "  Claude Code CLI 是运行飞书 MCP Server 的必要条件。"
        echo ""
        echo -e "${CYAN}如何安装 Claude Code CLI：${NC}"
        echo "  1. 访问 https://claude.ai 登录"
        echo "  2. 下载并安装 Claude 命令行工具"
        echo "  3. 或使用 Homebrew: brew install claude"
        echo ""
        exit 1
    fi

    CLAUDE_VERSION=$(claude --version 2>&1 | head -1)
    print_success "Claude Code CLI 已安装: $CLAUDE_VERSION"

    # 检查 Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js 未安装"
        print_info "请访问 https://nodejs.org/ 下载并安装 Node.js"
        exit 1
    fi

    NODE_VERSION=$(node --version)
    NODE_MAJOR=$(echo $NODE_VERSION | sed 's/v//' | cut -d'.' -f1)

    if [ "$NODE_MAJOR" -lt 18 ]; then
        print_error "Node.js 版本过低: $NODE_VERSION"
        print_info "需要 Node.js >= v18.0.0"
        print_info "请访问 https://nodejs.org/ 下载最新版本"
        exit 1
    fi

    print_success "Node.js: $NODE_VERSION"

    # 检查 npx
    if ! command -v npx &> /dev/null; then
        print_error "npx 未安装（通常随 Node.js 一起安装）"
        exit 1
    fi
    print_success "npx 可用"

    echo ""
}

##############################################################################
# 测试 MCP Server 包
##############################################################################

test_mcp_server() {
    print_step "步骤 2/4: 测试 feishu-mcp 包"

    print_info "检查 feishu-mcp 包可用性..."

    # 测试是否能够访问 NPM registry
    if timeout 10s npx -y feishu-mcp@latest --help > /dev/null 2>&1; then
        print_success "feishu-mcp 包可正常访问"
    else
        print_warning "无法测试 feishu-mcp 包（可能是网络问题）"
        print_info "继续安装，将在运行时下载"
    fi

    echo ""
}

##############################################################################
# 添加 MCP Server
##############################################################################

add_mcp_server() {
    print_step "步骤 3/4: 添加 feishu MCP Server"

    # 检查是否已存在
    if claude mcp list 2>/dev/null | grep -q "^$MCP_SERVER_NAME "; then
        print_warning "feishu MCP Server 已存在"
        echo ""
        read -p "是否覆盖现有配置? [y/N]: " OVERWRITE
        if [[ $OVERWRITE =~ ^[Yy]$ ]]; then
            print_info "移除现有配置..."
            claude mcp remove "$MCP_SERVER_NAME" 2>/dev/null || true
            print_success "已移除现有配置"
        else
            print_info "保留现有配置，跳过安装"
            echo ""
            return 0
        fi
    fi

    echo ""
    print_info "正在添加 feishu MCP Server..."
    echo ""

    # 使用 claude mcp add 命令
    if claude mcp add "$MCP_SERVER_NAME" -- npx -y feishu-mcp@latest \
        "--feishu-app-id=$FEISHU_APP_ID" \
        "--feishu-app-secret=$FEISHU_APP_SECRET" \
        "--feishu-auth-type=$FEISHU_AUTH_TYPE"; then
        echo ""
        print_success "成功添加 feishu MCP Server"
    else
        echo ""
        print_error "添加 MCP Server 失败"
        exit 1
    fi

    echo ""
}

##############################################################################
# 验证安装
##############################################################################

verify_installation() {
    print_step "步骤 4/4: 验证安装"

    print_info "检查 MCP Server 列表..."
    echo ""

    # 运行 claude mcp list
    MCP_LIST=$(claude mcp list 2>&1)

    if echo "$MCP_LIST" | grep -q "$MCP_SERVER_NAME"; then
        print_success "feishu MCP Server 已成功配置"
        echo ""
        echo -e "${CYAN}配置信息：${NC}"
        echo "$MCP_LIST" | grep "$MCP_SERVER_NAME"
    else
        print_error "无法在 MCP 列表中找到 feishu"
        print_info "请手动运行: claude mcp list 查看所有配置"
        exit 1
    fi

    echo ""
}

##############################################################################
# 显示使用说明
##############################################################################

show_instructions() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✓ 安装成功！                                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${YELLOW}📋 下一步操作：${NC}"
    echo ""
    echo -e "1️⃣  ${CYAN}启动 Claude Code CLI${NC}"
    echo -e "   ${BLUE}→${NC} 在终端中运行：${GREEN}claude${NC}"
    echo ""

    echo -e "2️⃣  ${CYAN}测试飞书文档读取${NC}"
    echo -e "   ${BLUE}→${NC} 在 Claude 会话中输入："
    echo ""
    echo -e "   ${GREEN}请读取这个飞书文档：${NC}"
    echo -e "   ${GREEN}https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg${NC}"
    echo ""

    echo -e "3️⃣  ${CYAN}授权 MCP 工具${NC}"
    echo -e "   ${BLUE}→${NC} 首次使用时会提示授权"
    echo -e "   ${BLUE}→${NC} 选择 '${GREEN}Allow for this project${NC}' 或 '${GREEN}Allow always${NC}'"
    echo ""

    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo -e "📚 ${CYAN}更多信息：${NC}"
    echo "   • 查看配置：   ${GREEN}claude mcp list${NC}"
    echo "   • 移除配置：   ${GREEN}claude mcp remove feishu${NC}"
    echo "   • 使用指南：   CLI_USAGE.md"
    echo "   • 常见问题：   FAQ.md"
    echo ""

    echo -e "${GREEN}✨ 祝使用愉快！${NC}"
    echo ""
}

##############################################################################
# 主函数
##############################################################################

main() {
    print_banner

    echo -e "${CYAN}此脚本将配置 Claude Code CLI 以支持飞书文档读取。${NC}"
    echo ""
    echo -e "${YELLOW}配置信息：${NC}"
    echo "  • App ID: $FEISHU_APP_ID"
    echo "  • Auth Type: $FEISHU_AUTH_TYPE"
    echo "  • MCP Server: $MCP_SERVER_NAME"
    echo ""

    read -p "是否继续安装？[Y/n]: " CONFIRM
    if [[ $CONFIRM =~ ^[Nn]$ ]]; then
        echo "已取消安装"
        exit 0
    fi

    echo ""

    # 执行安装步骤
    check_environment
    test_mcp_server
    add_mcp_server
    verify_installation
    show_instructions
}

# 运行主函数
main
