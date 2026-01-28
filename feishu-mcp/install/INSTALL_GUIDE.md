# Feishu MCP Server Installation Guide

## 📦 Package Info

**File**: feishu-mcp-install-v1.0.0.zip
**Size**: 17 KB
**System**: macOS
**Requires**:
- ✅ Node.js >= v18.0.0
- ✅ **Claude Desktop** (Required)

⚠️ **Important**: Claude Desktop is required to run MCP Server.
If not installed, download first: 👉 https://claude.ai/download

## 🚀 Quick Install (3 Steps)

### Step 1: Extract the file

Double-click `feishu-mcp-install-v1.0.0.zip` to extract.

### Step 2: Run installation script

Open Terminal and run **any** of the following:

#### Method A: Using wrapper (Recommended, auto-fix permissions)

```bash
cd install
bash install_wrapper.sh
```

#### Method B: Direct run (requires bash)

```bash
cd install
bash install.sh
```

#### Method C: Traditional way (requires manual permission setup)

```bash
cd install
chmod +x install.sh
./install.sh
```

Wait for "Installation successful" message.

### Step 3: Restart Claude Desktop

1. Press `Cmd+Q` to quit Claude Desktop completely
2. Wait 3 seconds
3. Restart Claude Desktop

✅ **Installation Complete!**

## 🧪 Test the Feature

In Claude Desktop chat, type:

```
Please read this Feishu document:
https://gz-junbo.feishu.cn/wiki/WsWowfLJoiiQKkk7RQOcMuewnlg
```

**First time**: Select `Yes, and don't ask again`

If Claude successfully reads and returns document content, you're all set!

## ❓ FAQ

### Q: How to open Terminal?

**A**: Press `Cmd+Space`, type "Terminal", press Enter.

### Q: "Permission denied" error?

**A**: Use either method to solve:

**Method 1 (Recommended)**: Run with bash

```bash
bash install.sh
# or
bash install_wrapper.sh
```

**Method 2**: Add execute permission manually

```bash
chmod +x install.sh
./install.sh
```

### Q: MCP Server not running?

**A**:
1. Open Claude Desktop
2. Settings > Developer
3. Check if "feishu" shows green status

If red, check "View Logs" for errors.

### Q: Cannot read document?

**A**:
1. Open document in Feishu
2. Click `...` > `Add App`
3. Search and add your app
4. Retry reading

## 📚 Usage Examples

### Read Document

```
Please read and summarize this Feishu document
```

### Format Conversion

```
Convert this Feishu document to Markdown format
```

### Content Analysis

```
Analyze the structure and main content of this document
```

## 🆘 Need Help?

- See `FAQ.md` - Detailed FAQ
- See `USAGE_GUIDE.md` - Usage guide
- See `快速参考.md` - Quick reference card
- Optional: Run `./verify-install.sh` to diagnose issues

## 🔄 Uninstall

Remove config file:

```bash
rm ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

Then restart Claude Desktop.

---

**Version**: v1.0.0
**Updated**: 2026-01-20
**Support**: See FAQ.md
