# 🚀 推送到 GitHub 的详细步骤

您的代码已经准备好，只需要完成身份验证即可推送。

## ⚡ 快速推送步骤

### 步骤1: 创建 Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置：
   - Note: `Prd_PO_Deploy`
   - Expiration: `90 days`（或根据需要选择）
   - 勾选权限：
     - ✅ **repo**（所有子选项）
     - ✅ **workflow**
4. 点击 "Generate token"
5. **立即复制** token（只显示一次！）

### 步骤2: 使用 Token 推送

在终端执行：

```bash
cd /Users/depp/projects/Prd_PO

# 推送时会要求输入用户名和密码
git push -u origin main

# 输入：
# Username: 370283761
# Password: <粘贴您的 Personal Access Token>
```

**重要**: Password 处输入的是 Token，不是 GitHub 密码！

---

## 🔑 方案2: 使用 SSH（推荐长期使用）

### 检查是否已有 SSH 密钥

```bash
ls -la ~/.ssh
```

如果看到 `id_rsa.pub` 或 `id_ed25519.pub`，说明已有 SSH 密钥。

### 生成新的 SSH 密钥（如果没有）

```bash
ssh-keygen -t ed25519 -C "370283761@qq.com"
# 按 Enter 使用默认位置
# 可以设置密码或直接按 Enter
```

### 添加 SSH 密钥到 GitHub

```bash
# 复制公钥到剪贴板（Mac）
pbcopy < ~/.ssh/id_ed25519.pub

# 或者查看公钥内容
cat ~/.ssh/id_ed25519.pub
```

然后：
1. 访问 https://github.com/settings/keys
2. 点击 "New SSH key"
3. Title: `MacBook Air`
4. Key: 粘贴刚才复制的公钥
5. 点击 "Add SSH key"

### 修改远程仓库地址为 SSH

```bash
cd /Users/depp/projects/Prd_PO

# 移除旧的远程地址
git remote remove origin

# 添加 SSH 地址
git remote add origin git@github.com:370283761/JUNBO.git

# 推送
git push -u origin main
```

---

## 🌐 方案3: 使用 GitHub Desktop（最简单）

1. 下载并安装 GitHub Desktop: https://desktop.github.com
2. 登录 GitHub 账号
3. File → Add Local Repository → 选择 `/Users/depp/projects/Prd_PO`
4. 点击 "Publish repository"
5. 取消勾选 "Keep this code private"（如果要用 GitHub Pages）
6. 点击 "Publish Repository"

完成！

---

## 📝 推送成功后的步骤

### 启用 GitHub Pages

1. 访问 https://github.com/370283761/JUNBO/settings/pages
2. Source:
   - Branch: `main`
   - Folder: `/ (root)`
3. 点击 "Save"

### 等待 2-3 分钟后访问

您的演示页面将可以通过以下链接访问：

```
https://370283761.github.io/JUNBO/prd_po/H5/tag-flow-demo.html
```

完整的页面链接：
- **演示入口**: https://370283761.github.io/JUNBO/prd_po/H5/tag-flow-demo.html
- **Step 1**: https://370283761.github.io/JUNBO/prd_po/H5/tag-selection-step1.html
- **Step 2**: https://370283761.github.io/JUNBO/prd_po/H5/tag-selection-step2.html
- **Step 3**: https://370283761.github.io/JUNBO/prd_po/H5/tag-rule-config.html
- **Step 4**: https://370283761.github.io/JUNBO/prd_po/H5/tag-preview-result.html

---

## 🎯 推荐方案对比

| 方案 | 难度 | 速度 | 适用场景 |
|------|------|------|----------|
| **Token** | ⭐⭐ | 快 | 首次推送、临时使用 |
| **SSH** | ⭐⭐⭐ | 快 | 长期开发、多次推送 |
| **GitHub Desktop** | ⭐ | 最快 | 不熟悉命令行 |

---

## ❓ 常见问题

### Q: Token 在哪里输入？

A: 执行 `git push` 命令后，会提示输入 Username 和 Password。Password 处输入 Token。

### Q: Token 忘记保存了怎么办？

A: Token 只显示一次。需要重新创建新的 Token。

### Q: 推送成功后看不到页面？

A:
1. 确认仓库是 Public（公开）
2. 确认 GitHub Pages 已启用
3. 等待 2-5 分钟，GitHub Pages 需要构建时间
4. 清除浏览器缓存后重试

---

## 🚀 现在选择一个方案开始推送吧！

推荐：**方案1（Token）** 最快最简单！
