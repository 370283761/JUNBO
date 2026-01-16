#!/bin/bash

# 基于标签的智能批量创编系统 - GitHub 部署脚本
# 使用方法: ./deploy-to-github.sh YOUR_GITHUB_USERNAME

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# 检查参数
if [ -z "$1" ]; then
    print_error "请提供您的 GitHub 用户名"
    echo ""
    echo "使用方法:"
    echo "  ./deploy-to-github.sh YOUR_GITHUB_USERNAME"
    echo ""
    echo "示例:"
    echo "  ./deploy-to-github.sh john-doe"
    exit 1
fi

GITHUB_USERNAME="$1"
REPO_NAME="tag-based-ad-creation"

echo ""
echo "=========================================="
echo "  基于标签的智能批量创编系统"
echo "  GitHub 部署向导"
echo "=========================================="
echo ""

# 步骤1: 检查 Git 状态
print_step "步骤 1/5: 检查 Git 状态..."
if [ -d .git ]; then
    print_success "Git 仓库已初始化"
else
    print_error "未找到 Git 仓库"
    exit 1
fi

# 步骤2: 检查是否有未提交的更改
print_step "步骤 2/5: 检查未提交的更改..."
if [ -n "$(git status --porcelain)" ]; then
    print_warning "发现未提交的更改，正在提交..."
    git add .
    git commit -m "chore: 自动提交部署前的更改"
    print_success "更改已提交"
else
    print_success "没有未提交的更改"
fi

# 步骤3: 检查远程仓库
print_step "步骤 3/5: 配置远程仓库..."
if git remote get-url origin > /dev/null 2>&1; then
    CURRENT_REMOTE=$(git remote get-url origin)
    print_warning "已存在远程仓库: $CURRENT_REMOTE"
    read -p "是否要更新为新的远程仓库? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote remove origin
        git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
        print_success "远程仓库已更新"
    fi
else
    git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
    print_success "远程仓库已添加"
fi

# 步骤4: 推送代码
print_step "步骤 4/5: 推送代码到 GitHub..."
echo ""
print_warning "请确保您已在 GitHub 上创建了仓库: ${REPO_NAME}"
print_warning "仓库地址: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo ""
read -p "仓库已创建？按 Enter 继续，Ctrl+C 取消..."

git branch -M main

echo ""
print_step "正在推送到 GitHub..."
if git push -u origin main; then
    print_success "代码推送成功！"
else
    print_error "推送失败，请检查："
    echo "  1. GitHub 仓库是否已创建"
    echo "  2. 您是否有推送权限"
    echo "  3. 网络连接是否正常"
    exit 1
fi

# 步骤5: 显示后续步骤
print_step "步骤 5/5: 部署完成！"
echo ""
echo "=========================================="
echo "  🎉 代码已成功推送到 GitHub！"
echo "=========================================="
echo ""
echo "📋 后续步骤："
echo ""
echo "1️⃣  启用 GitHub Pages："
echo "   • 访问: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/pages"
echo "   • Source: 选择 'main' 分支"
echo "   • Folder: 选择 '/ (root)'"
echo "   • 点击 'Save'"
echo ""
echo "2️⃣  等待 2-3 分钟后，您的网站将可访问："
echo ""
print_success "演示入口: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/prd_po/H5/tag-flow-demo.html"
echo ""
echo "3️⃣  完整的页面链接："
echo "   • Step 1: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/prd_po/H5/tag-selection-step1.html"
echo "   • Step 2: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/prd_po/H5/tag-selection-step2.html"
echo "   • Step 3: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/prd_po/H5/tag-rule-config.html"
echo "   • Step 4: https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/prd_po/H5/tag-preview-result.html"
echo ""
echo "=========================================="
echo ""
print_success "分享链接已生成，可以发送给其他人查看！"
echo ""

# 可选：自动打开浏览器
read -p "是否要在浏览器中打开 GitHub 仓库? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
fi

echo ""
print_success "部署完成！"
