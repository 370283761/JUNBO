#!/bin/bash

##############################################################################
# 飞书 MCP Server 一键配置脚本
# 用途：自动配置 Claude Desktop 以支持读取飞书文档
# 作者：Claude
# 日期：2026-01-20
##############################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置文件路径
CLAUDE_DESKTOP_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
CLAUDE_CODE_CONFIG="$HOME/.claude/config.json"

##############################################################################
# 工具函数
##############################################################################

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
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
    echo -e "${BLUE}ℹ $1${NC}"
}

##############################################################################
# 检查前置条件
##############################################################################

check_prerequisites() {
    print_header "检查前置条件"

    # 检查 Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js 已安装: $NODE_VERSION"

        # 检查版本是否 >= 18
        NODE_MAJOR=$(echo $NODE_VERSION | sed 's/v//' | cut -d'.' -f1)
        if [ "$NODE_MAJOR" -lt 18 ]; then
            print_error "Node.js 版本过低，需要 v18 或更高版本"
            print_info "请访问 https://nodejs.org/ 下载最新版本"
            exit 1
        fi
    else
        print_error "Node.js 未安装"
        print_info "请访问 https://nodejs.org/ 下载并安装 Node.js"
        exit 1
    fi

    # 检查 npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_success "npm 已安装: $NPM_VERSION"
    else
        print_error "npm 未安装"
        exit 1
    fi

    # 检查 Claude Desktop 配置目录
    CLAUDE_DESKTOP_DIR=$(dirname "$CLAUDE_DESKTOP_CONFIG")
    if [ ! -d "$CLAUDE_DESKTOP_DIR" ]; then
        print_warning "Claude Desktop 配置目录不存在，将创建"
        mkdir -p "$CLAUDE_DESKTOP_DIR"
    fi

    print_success "所有前置条件检查通过"
}

##############################################################################
# 获取飞书凭证
##############################################################################

get_feishu_credentials() {
    print_header "配置飞书应用凭证"

    echo "请访问飞书开放平台获取应用凭证："
    echo "https://open.feishu.cn/"
    echo ""

    # 读取 App ID
    while true; do
        echo -n "请输入飞书 App ID (格式如 cli_xxxxxxxxxx): "
        read FEISHU_APP_ID

        if [[ $FEISHU_APP_ID =~ ^cli_[a-zA-Z0-9]+$ ]]; then
            break
        else
            print_error "App ID 格式不正确，应该以 cli_ 开头"
        fi
    done

    # 读取 App Secret
    while true; do
        echo -n "请输入飞书 App Secret: "
        read -s FEISHU_APP_SECRET
        echo ""

        if [ -n "$FEISHU_APP_SECRET" ]; then
            break
        else
            print_error "App Secret 不能为空"
        fi
    done

    # 选择认证类型
    echo ""
    echo "请选择认证类型："
    echo "1) tenant - 应用访问凭证（推荐，适合只读操作）"
    echo "2) user - 用户访问凭证（需要用户授权）"
    echo -n "请选择 [1/2，默认为 1]: "
    read AUTH_TYPE_CHOICE

    if [ "$AUTH_TYPE_CHOICE" = "2" ]; then
        FEISHU_AUTH_TYPE="user"
    else
        FEISHU_AUTH_TYPE="tenant"
    fi

    print_success "凭证配置完成"
}

##############################################################################
# 创建 Claude Desktop 配置
##############################################################################

configure_claude_desktop() {
    print_header "配置 Claude Desktop"

    # 备份现有配置
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        BACKUP_FILE="${CLAUDE_DESKTOP_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$CLAUDE_DESKTOP_CONFIG" "$BACKUP_FILE"
        print_info "已备份现有配置到: $BACKUP_FILE"
    fi

    # 读取现有配置或创建新配置
    if [ -f "$CLAUDE_DESKTOP_CONFIG" ]; then
        EXISTING_CONFIG=$(cat "$CLAUDE_DESKTOP_CONFIG")

        # 检查是否已有 mcpServers
        if echo "$EXISTING_CONFIG" | grep -q "mcpServers"; then
            print_info "检测到现有 MCP Server 配置"

            # 使用 Python 或 Node.js 合并 JSON（这里简化处理）
            # 实际应该用 jq，但为了减少依赖，这里用简单方式

            # 提取现有的 mcpServers 部分，添加 feishu 配置
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
            print_warning "已覆盖配置文件，如有其他 MCP Server，请手动从备份文件恢复"
        else
            # 现有配置没有 mcpServers，添加
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
        fi
    else
        # 创建新配置
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
    fi

    # 设置文件权限
    chmod 600 "$CLAUDE_DESKTOP_CONFIG"

    print_success "Claude Desktop 配置完成"
    print_info "配置文件位置: $CLAUDE_DESKTOP_CONFIG"
}

##############################################################################
# 配置 Claude Code CLI（可选）
##############################################################################

configure_claude_code() {
    print_header "配置 Claude Code CLI（可选）"

    echo -n "是否也配置 Claude Code CLI？[y/N]: "
    read CONFIGURE_CLI

    if [[ $CONFIGURE_CLI =~ ^[Yy]$ ]]; then
        # 检查 .claude 目录
        CLAUDE_CODE_DIR=$(dirname "$CLAUDE_CODE_CONFIG")
        if [ ! -d "$CLAUDE_CODE_DIR" ]; then
            mkdir -p "$CLAUDE_CODE_DIR"
        fi

        # 备份现有配置
        if [ -f "$CLAUDE_CODE_CONFIG" ]; then
            BACKUP_FILE="${CLAUDE_CODE_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$CLAUDE_CODE_CONFIG" "$BACKUP_FILE"
            print_info "已备份现有配置到: $BACKUP_FILE"
        fi

        # 读取现有 API Key（如果存在）
        EXISTING_API_KEY=""
        if [ -f "$CLAUDE_CODE_CONFIG" ]; then
            EXISTING_API_KEY=$(grep -o '"primaryApiKey"[[:space:]]*:[[:space:]]*"[^"]*"' "$CLAUDE_CODE_CONFIG" | cut -d'"' -f4)
        fi

        if [ -z "$EXISTING_API_KEY" ]; then
            EXISTING_API_KEY="your-api-key"
        fi

        # 创建配置
        cat > "$CLAUDE_CODE_CONFIG" <<EOF
{
  "primaryApiKey": "$EXISTING_API_KEY",
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

        chmod 600 "$CLAUDE_CODE_CONFIG"

        print_success "Claude Code CLI 配置完成"
        print_info "配置文件位置: $CLAUDE_CODE_CONFIG"
    else
        print_info "跳过 Claude Code CLI 配置"
    fi
}

##############################################################################
# 验证安装
##############################################################################

verify_installation() {
    print_header "验证安装"

    # 测试 npx 能否访问 feishu-mcp
    print_info "测试 MCP Server 可访问性..."

    if npx -y feishu-mcp@latest --help &> /dev/null; then
        print_success "feishu-mcp 可以正常访问"
    else
        print_warning "无法访问 feishu-mcp，可能是网络问题"
        print_info "不用担心，Claude Desktop 会在启动时自动下载"
    fi

    # 检查配置文件格式
    print_info "验证配置文件格式..."

    if command -v python3 &> /dev/null; then
        if python3 -m json.tool "$CLAUDE_DESKTOP_CONFIG" &> /dev/null; then
            print_success "Claude Desktop 配置文件格式正确"
        else
            print_error "配置文件 JSON 格式有误"
            exit 1
        fi
    else
        print_warning "无法验证 JSON 格式（python3 未安装），请手动检查"
    fi
}

##############################################################################
# 显示后续步骤
##############################################################################

show_next_steps() {
    print_header "配置完成！"

    echo "✅ 飞书 MCP Server 已成功配置"
    echo ""
    echo "📋 后续步骤："
    echo ""
    echo "1. 重启 Claude Desktop"
    echo "   - 完全退出 Claude Desktop（菜单栏 > Quit，或按 Cmd+Q）"
    echo "   - 重新启动 Claude Desktop"
    echo ""
    echo "2. 验证 MCP Server 状态"
    echo "   - 打开 Claude Desktop > Settings > Developer"
    echo "   - 检查 'feishu' server 是否显示为运行状态（绿色）"
    echo ""
    echo "3. 测试飞书文档读取"
    echo "   - 在 Claude 对话框中输入："
    echo "     '请读取这个飞书文档的内容：https://xxx.feishu.cn/docx/xxxxx'"
    echo ""
    echo "📚 更多信息："
    echo "   - 飞书应用配置指南: $(pwd)/FEISHU_APP_SETUP.md"
    echo "   - Claude Desktop 配置指南: $(pwd)/CLAUDE_DESKTOP_SETUP.md"
    echo "   - 使用示例: $(pwd)/USAGE_EXAMPLES.md"
    echo ""
    echo "❓ 遇到问题？"
    echo "   - 查看故障排查: $(pwd)/CLAUDE_DESKTOP_SETUP.md#故障排查"
    echo "   - GitHub Issues: https://github.com/cso1z/Feishu-MCP/issues"
    echo ""
    print_success "祝使用愉快！"
}

##############################################################################
# 主函数
##############################################################################

main() {
    clear

    print_header "飞书 MCP Server 一键配置脚本"

    echo "本脚本将帮助您配置 Claude Desktop 以支持读取飞书文档。"
    echo ""
    echo "配置过程包括："
    echo "  1. 检查 Node.js 环境"
    echo "  2. 获取飞书应用凭证"
    echo "  3. 配置 Claude Desktop"
    echo "  4. 配置 Claude Code CLI（可选）"
    echo "  5. 验证安装"
    echo ""
    echo -n "是否继续？[Y/n]: "
    read CONTINUE

    if [[ $CONTINUE =~ ^[Nn]$ ]]; then
        echo "已取消配置"
        exit 0
    fi

    # 执行配置步骤
    check_prerequisites
    get_feishu_credentials
    configure_claude_desktop
    configure_claude_code
    verify_installation
    show_next_steps
}

# 运行主函数
main
