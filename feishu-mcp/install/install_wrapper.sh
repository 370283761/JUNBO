#!/bin/bash

##############################################################################
# 飞书 MCP Server ���装包装器
# 版本: 1.0.0
# 日期: 2026-01-20
# 说明: 自动修复权限并调用安装脚本
##############################################################################

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║         飞书 MCP Server 安装包装器 v1.0                        ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

##############################################################################
# 1. 修复所有脚本权限
##############################################################################

echo -e "${BLUE}▶ 步骤 1/2: 检查并���复脚本权限${NC}"
echo ""

SCRIPTS=(
    "install.sh"
    "verify-install.sh"
    "diagnose.sh"
    "quick-setup.sh"
)

FIXED_COUNT=0

for script in "${SCRIPTS[@]}"; do
    script_path="$SCRIPT_DIR/$script"

    if [ -f "$script_path" ]; then
        if [ ! -x "$script_path" ]; then
            echo -e "  ${YELLOW}修复:${NC} $script"
            chmod +x "$script_path" 2>/dev/null
            if [ $? -eq 0 ]; then
                ((FIXED_COUNT++))
            else
                echo -e "  ${RED}✗ 无法修复 $script 的权限${NC}"
            fi
        else
            echo -e "  ${GREEN}✓${NC} $script (权限正常)"
        fi
    fi
done

echo ""

if [ $FIXED_COUNT -gt 0 ]; then
    echo -e "${GREEN}已修复 $FIXED_COUNT 个脚本的权限${NC}"
    echo ""
fi

##############################################################################
# 2. 执行安装脚本
##############################################################################

echo -e "${BLUE}▶ 步骤 2/2: 启动安装程序${NC}"
echo ""

INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"

if [ ! -f "$INSTALL_SCRIPT" ]; then
    echo -e "${RED}✗ 错误: 找不到 install.sh 文件${NC}"
    echo "  预期位置: $INSTALL_SCRIPT"
    exit 1
fi

# 确保安装脚本可执行
chmod +x "$INSTALL_SCRIPT" 2>/dev/null

# 执行安装脚本
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exec "$INSTALL_SCRIPT"
