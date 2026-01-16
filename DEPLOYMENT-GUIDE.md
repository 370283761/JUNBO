# 🚀 部署指南 - 基于标签的智能批量创编系统

## 方案1：GitHub Pages 部署（推荐）

### 步骤1：创建 GitHub 仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `tag-based-ad-creation`（或您喜欢的名称）
   - **Description**: `基于标签的智能批量创编系统 - 革命性的广告投放管理体验`
   - **Visibility**: 选择 Public（公开仓库才能使用免费的 GitHub Pages）
3. 点击 "Create repository"

### 步骤2：推送代码到 GitHub

在终端执行以下命令：

```bash
# 进入项目目录
cd /Users/depp/projects/Prd_PO

# 添加远程仓库（替换 YOUR_USERNAME 为您的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/tag-based-ad-creation.git

# 推送代码
git branch -M main
git push -u origin main
```

### 步骤3：启用 GitHub Pages

1. 进入仓库的 Settings 页面
2. 在左侧菜单找到 "Pages"
3. 在 "Source" 下：
   - Branch: 选择 `main`
   - Folder: 选择 `/ (root)`
4. 点击 "Save"

### 步骤4：获取分享链接

几分钟后，GitHub Pages 会生成您的网站链接：

```
https://YOUR_USERNAME.github.io/tag-based-ad-creation/prd_po/H5/tag-flow-demo.html
```

**这就是您可以分享给其他人的链接！** 🎉

---

## 方案2：使用 Vercel/Netlify 部署（更快）

### 使用 Vercel

1. 访问 https://vercel.com
2. 使用 GitHub 账号登录
3. 点击 "Import Project"
4. 选择您的 GitHub 仓库
5. 配置：
   - **Root Directory**: `prd_po/H5`
   - **Framework Preset**: Other
6. 点击 "Deploy"

几秒钟后，您会得到一个链接：
```
https://your-project.vercel.app/tag-flow-demo.html
```

### 使用 Netlify

1. 访问 https://netlify.com
2. 拖拽 `prd_po/H5` 文件夹到页面上
3. 等待部署完成

您会得到一个链接：
```
https://random-name-123.netlify.app/tag-flow-demo.html
```

---

## 方案3：本地分享（适合内网或临时演示）

### 使用 Python HTTP Server

```bash
cd /Users/depp/projects/Prd_PO/prd_po/H5
python3 -m http.server 8000
```

然后访问：`http://localhost:8000/tag-flow-demo.html`

### 使用 Node.js http-server

```bash
# 安装 http-server
npm install -g http-server

# 启动服务器
cd /Users/depp/projects/Prd_PO/prd_po/H5
http-server -p 8000
```

### 使用 ngrok（将本地服务暴露到公网）

```bash
# 先启动本地服务器（端口8000）
python3 -m http.server 8000

# 在另一个终端启动 ngrok
ngrok http 8000
```

ngrok 会生成一个公网可访问的临时链接：
```
https://abc123.ngrok.io/tag-flow-demo.html
```

**注意**：ngrok 生成的链接是临时的，关闭后失效。

---

## 方案4：使用 Cloudflare Pages（推荐专业用户）

1. 访问 https://pages.cloudflare.com
2. 连接 GitHub 账号
3. 选择您的仓库
4. 配置：
   - **Build directory**: `prd_po/H5`
   - **Build command**: 留空
5. 点击 "Save and Deploy"

您会得到一个自定义域名：
```
https://your-project.pages.dev/tag-flow-demo.html
```

---

## 📁 文件结构说明

如果使用 GitHub Pages，完整的分享链接应该是：

```
https://YOUR_USERNAME.github.io/REPO_NAME/prd_po/H5/tag-flow-demo.html
```

### 关键文件路径

- **演示入口**: `/prd_po/H5/tag-flow-demo.html`
- **Step 1**: `/prd_po/H5/tag-selection-step1.html`
- **Step 2**: `/prd_po/H5/tag-selection-step2.html`
- **Step 3**: `/prd_po/H5/tag-rule-config.html`
- **Step 4**: `/prd_po/H5/tag-preview-result.html`
- **文档**: `/prd_po/H5/TAG-FLOW-README.md`

---

## 🔧 配置 .gitignore

建议添加以下文件到 `.gitignore`：

```
# macOS
.DS_Store

# Editor
.vscode/
.idea/

# Logs
*.log

# Local config
config.local.json
```

---

## 🌐 自定义域名（可选）

如果您有自己的域名，可以配置 CNAME：

### GitHub Pages

1. 在仓库根目录创建 `CNAME` 文件
2. 内容为您的域名：`demo.yourdomain.com`
3. 在域名提供商处添加 CNAME 记录指向 `YOUR_USERNAME.github.io`

### Vercel/Netlify

在平台设置中直接添加自定义域名，平台会提供详细的配置指南。

---

## 📊 推荐方案对比

| 方案 | 速度 | 稳定性 | 免费 | 自定义域名 | 推荐度 |
|------|------|--------|------|------------|--------|
| **GitHub Pages** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| **Vercel** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| **Netlify** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ⭐⭐⭐⭐ |
| **Cloudflare Pages** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| **本地 + ngrok** | ⭐⭐⭐ | ⭐⭐ | ✅ | ❌ | ⭐⭐⭐ |

---

## 🎯 快速开始（推荐流程）

### 最简单的方案：GitHub Pages

1. **创建 GitHub 仓库**（5分钟）
   ```bash
   # 执行下面的命令
   git remote add origin https://github.com/YOUR_USERNAME/tag-based-ad-creation.git
   git push -u origin main
   ```

2. **启用 GitHub Pages**（2分钟）
   - 进入仓库 Settings → Pages
   - Source: main 分支
   - 点击 Save

3. **获取链接并分享**（1分钟）
   ```
   https://YOUR_USERNAME.github.io/tag-based-ad-creation/prd_po/H5/tag-flow-demo.html
   ```

**总计：8分钟即可获得一个永久可分享的链接！**

---

## 📞 遇到问题？

### 常见问题

**Q1: GitHub Pages 显示 404**
- 检查仓库是否为 Public
- 确认 Pages 设置中的分支和文件夹正确
- 等待几分钟，GitHub Pages 需要构建时间

**Q2: 页面显示但样式错误**
- 检查浏览器控制台的错误信息
- 确认所有 HTML 文件中的资源路径正确

**Q3: 如何更新部署的内容**
```bash
# 修改文件后
git add .
git commit -m "更新：描述您的修改"
git push

# GitHub Pages 会自动重新部署
```

---

## 🚀 下一步

部署完成后，您可以：

1. ✅ 将链接分享给团队成员查看
2. ✅ 在产品演示中使用
3. ✅ 收集用户反馈
4. ✅ 持续迭代和改进

祝您部署顺利！🎉
