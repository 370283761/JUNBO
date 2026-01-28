#!/bin/bash

##############################################################################
# 飞书 MCP Server 一键安装脚本
# 版本: 1.0.0
# 日期: 2026-01-20
# 说明: 自动配置 Claude Desktop 以支持飞书文档读取
##############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 配置参数（已预设）
FEISHU_APP_ID="cli_a761f9c6d1ffd00e"
FEISHU_APP_SECRET="VNhXgzmowleKU068HSaFqei0ZWrNSqtS"
FEISHU_AUTH_TYPE="tenant"

# 路径配置
CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
CLAUDE_DESKTOP_DIR=$(dirname "$CLAUDE_DESKTOP_CONFIG")

##############################################################################
# 工具函数
##############################################################################

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║          飞书 MCP Server 一键安装脚本                          ║"
    echo "║          Feishu MCP Server Auto Installer                     ║"
    echo "║                                                                ║"
    echo "║          让 Claude 能够读取和处理飞书文档                       ║"
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
    print_step "步骤 1/5: 检查系统环境"

    # 检查操作系统
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "此脚本仅支持 macOS 系统"
        exit 1
    fi
    print_success "操作系统: macOS"

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
        print_info "请访问 https://nodejs.org/ 升级 Node.js"
        exit 1
    fi
    print_success "Node.js: $NODE_VERSION"

    # 检查 npm
    if ! command -v npm &> /dev/null; then
        print_error "npm 未安装"
        exit 1
    fi
    NPM_VERSION=$(npm --version)
    print_success "npm: v$NPM_VERSION"

    # 检查 Claude Desktop 是否安装
    if [ ! -d "/Applications/Claude.app" ]; then
        print_warning "未检测到 Claude Desktop 应用"
        print_info "请确保已安装 Claude Desktop"
        read -p "是否继续安装？[y/N]: " CONTINUE
        if [[ ! $CONTINUE =~ ^[Yy]$ ]]; then
            echo "已取消安装"
            exit 0
        fi
    else
        print_success "Claude Desktop: 已安装"
    fi

    echo ""
}

##############################################################################
# 测试 MCP Server 可访问性
##############################################################################

test_mcp_server() {
    print_step "步骤 2/5: 验证 feishu-mcp 包"

    print_info "正在测试 feishu-mcp 包的可访问性..."

    if npx -y feishu-mcp@latest --help &> /dev/null; then
        print_success "feishu-mcp 包可正常访问"
    else
        print_warning "无法预先验证 feishu-mcp 包"
        print_info "将在配置时自动下载"
    fi

    echo ""
}

##############################################################################
# 创建配置文件
##############################################################################

create_config() {
    print_step "步骤 3/5: 创建配置文件"

    # 创建配置目录
    if [ ! -d "$CLAUDE_DESKTOP_DIR" ]; then
        print_info "创建配置目录..."
        mkdir -p "$CLAUDE_DESKTOP_DIR"
        print_success "配置目录已创建"
    else
        print_success "配置目录已存在"
    fi

    # 备份现有配置
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        BACKUP_FILE="${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$CLAUDE_DESKTOP_CONFIG" "$BACKUP_FILE"
        print_success "已备份现有配置到: $(basename $BACKUP_FILE)"
    fi

    # 创建配置文件
    print_info "生成配置文件..."
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

    # 设置文件权限
    chmod 600 "$CLAUDE_DESKTOP_CONFIG"
    print_success "配置文件权限已设置为 600"

    # 验证 JSON 格式
    if python3 -m json.tool "$CLAUDE_DESKTOP_CONFIG" > /dev/null 2>&1; then
        print_success "配置文件 JSON 格式正确"
    else
        print_error "配置文件 JSON 格式错误"
        exit 1
    fi

    echo ""
}

##############################################################################
# 显示配置信息
##############################################################################

show_config_info() {
    print_step "步骤 4/5: 配置信息确认"

    echo -e "${CYAN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║            配置信息                         ║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC} App ID:      $FEISHU_APP_ID"
    echo -e "${CYAN}║${NC} Auth Type:   $FEISHU_AUTH_TYPE"
    echo -e "${CYAN}║${NC} Config File: $(basename "$CLAUDE_DESKTOP_CONFIG")"
    echo -e "${CYAN}╚════════════════════════════════════════════╝${NC}"
    echo ""
}

##############################################################################
# 显示使用说明
##############################################################################

show_instructions() {
    print_step "步骤 5/5: 完成安装"

    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ✓ 安装成功！                                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    echo -e "${YELLOW}📋 下一步操作：${NC}"
    echo ""
    echo "1️⃣  ${CYAN}重启 Claude Desktop${NC}"
    echo "   ${BLUE}→${NC} 完全退出 Claude Desktop（菜单栏 > Quit，或按 Cmd+Q）"
    echo "   ${BLUE}→${NC} 等待 3-5 秒"
    echo "   ${BLUE}→${NC} 重新启动 Claude Desktop"
    echo ""

    echo "2️⃣  ${CYAN}验证 MCP Server 状态${NC}"
    echo "   ${BLUE}→${NC} 打开 Settings (Cmd+,) > Developer"
    echo "   ${BLUE}→${NC} 检查 'feishu' server 是否显示为${GREEN}绿色运行状态${NC}"
    echo ""

    echo "3️⃣  ${CYAN}测试飞书文档读取${NC}"
    echo "   ${BLUE}→${NC} 在 Claude 对话框中输入："
    echo ""
    echo "   ${GREEN}请读取这个飞书文档：${NC}"
    echo "   ${GREEN}https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg${NC}"
    echo ""

    echo "4️⃣  ${CYAN}授权 MCP 工具${NC}"
    echo "   ${BLUE}→${NC} 首次使用时会提示授权"
    echo "   ${BLUE}→${NC} 选择 '${GREEN}Yes, and don't ask again${NC}'"
    echo ""

    echo "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    echo "📚 ${CYAN}更多资源：${NC}"
    echo "   • 使用示例：   $(dirname "$0")/USAGE_EXAMPLES.md"
    echo "   • 常见问题：   $(dirname "$0")/FAQ.md"
    echo "   • 测试指南：   $(dirname "$0")/TESTING.md"
    echo "   • 完整文档：   $(dirname "$0")/README.md"
    echo ""

    echo "❓ ${CYAN}遇到问题？${NC}"
    echo "   • 查看日志：Settings > Developer > View Logs"
    echo "   • 查看 FAQ：$(dirname "$0")/FAQ.md"
    echo ""

    echo -e "${GREEN}✨ 祝使用愉快！${NC}"
    echo ""
}

##############################################################################
# 主函数
##############################################################################

main() {
    print_banner

    echo -e "${CYAN}此脚本将自动配置 Claude Desktop 以支持飞书文档读取。${NC}"
    echo ""
    echo -e "${YELLOW}配置信息：${NC}"
    echo "  • App ID: $FEISHU_APP_ID"
    echo "  • Auth Type: $FEISHU_AUTH_TYPE"
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
    create_config
    show_config_info
    show_instructions
}

# 运行主函数
main
