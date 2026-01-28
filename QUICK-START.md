# 🚀 快速部署 - 3分钟获取分享链接

## 方式1: 使用一键部署脚本（最简单）⭐

### 步骤1: 在 GitHub 创建仓库

1. 访问 https://github.com/new
2. Repository name: `tag-based-ad-creation`
3. 设为 **Public**（公开）
4. 点击 "Create repository"

### 步骤2: 运行部署脚本

```bash
cd /Users/depp/projects/Prd_PO
./deploy-to-github.sh 370283761
```

**替换 `YOUR_GITHUB_USERNAME` 为您的 GitHub ���户名！**

例如：`./deploy-to-github.sh john-doe`

### 步骤3: 启用 GitHub Pages

1. 访问 https://github.com/YOUR_USERNAME/tag-based-ad-creation/settings/pages
2. Source: 选择 `main`
3. Folder: 选择 `/ (root)`
4. 点击 **Save**

### 步骤4: 获取分享链接 🎉

等待 2-3 分钟后，您的网站将可访问：

```
https://YOUR_USERNAME.github.io/tag-based-ad-creation/prd_po/H5/tag-flow-demo.html
```

**这就是您可以分享的链接！**

---

## 方式2: 手动推送（适合熟悉 Git 的用户）

```bash
# 1. 添加远程仓库
git remote add origin https://github.com/YOUR_USERNAME/tag-based-ad-creation.git

# 2. 推送代码
git branch -M main
git push -u origin main
```

然后按照方式1的步骤3和步骤4操作。

---

## 方式3: 使用 Vercel（秒级部署）⚡

### 适合快速演示

1. 访问 https://vercel.com
2. 使用 GitHub 登录
3. 点击 "Import Project"
4. 选择您的仓库
5. Root Directory: 设置为 `prd_po/H5`
6. 点击 "Deploy"

**10秒后得到链接：**
```
https://your-project.vercel.app/tag-flow-demo.html
```

---

## 🎯 推荐顺序

1. **首选**: 方式1（一键脚本）- 最简单，永久链接
2. **备选**: 方式3（Vercel）- 最快，适合演示
3. **高级**: 方式2（手动）- 完全掌控

---

## ❓ 常见问题

### Q: 我没有 GitHub 账号怎么办？

访问 https://github.com/signup 免费注册一个。

### Q: 推送时要求输入密码？

GitHub 已不支持密码验证，需要使用 Personal Access Token：

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选 `repo` 权限
4. 复制生成的 token
5. 推送时使用 token 作为密码

或者配置 SSH：https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### Q: GitHub Pages 显示 404？

- 确保仓库是 **Public**（公开）
- 等待 2-5 分钟，GitHub Pages 需要构建时间
- 检查 Settings → Pages 中的配置

### Q: 链接太长了，可以缩短吗？

可以使用短链接服务：
- https://bit.ly
- https://tinyurl.com

或者配置自定义域名（需要购买域名）。

---

## 📞 需要帮助？

查看完整文档：[DEPLOYMENT-GUIDE.md](./DEPLOYMENT-GUIDE.md)

---

**现在开始部署吧！** 🚀
