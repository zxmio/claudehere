# 🔍 claudehere

**One-click to launch Claude Code from any folder.**

Works on **macOS** (Finder toolbar) and **Windows** (right-click context menu).

[English](#english) | [中文](#中文)

🌐 [claudehere.com](https://claudehere.com)

---

## English

### What is this?

`claudehere` adds a **one-click shortcut** to your file manager — click it, and Claude Code launches instantly in the current folder.

No more `cd`-ing into directories. No more copy-pasting paths.

| Method | Steps |
|--------|-------|
| Manual | Open Terminal → cd → claude |
| **claudehere** | **One click** ✨ |

### macOS — Finder Toolbar Button

**Install:**

```bash
git clone https://github.com/todaylabs/claudehere.git
cd claudehere
bash scripts/install.sh
```

**Add to Finder Toolbar:**

1. Open any folder in Finder
2. Right-click the toolbar → **"Customize Toolbar..."**
3. Open `/Applications` in another Finder window
4. Drag **Claude Here** onto the toolbar
5. Done!

**Use iTerm2 instead of Terminal.app:**

```bash
# Add to ~/.zshrc or ~/.bashrc
export CLAUDEHERE_TERMINAL=iterm
```

**Uninstall:**

```bash
bash scripts/uninstall.sh
```

### Windows — Right-Click Context Menu

Adds **"Open Claude Code Here"** to the File Explorer right-click menu.

**Install (run PowerShell as Administrator):**

```powershell
git clone https://github.com/todaylabs/claudehere.git
cd claudehere
powershell -ExecutionPolicy Bypass -File scripts\install-windows.ps1
```

**How to use:**

1. Open any folder in File Explorer
2. Right-click on empty space
3. Click **"Open Claude Code Here"**

> On Windows 11, click "Show more options" first to see the entry.

Auto-detects Windows Terminal — falls back to cmd.exe if not installed.

**Uninstall (run PowerShell as Administrator):**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\uninstall-windows.ps1
```

### Requirements

- [Claude Code CLI](https://docs.claude.com/en/docs/claude-code) installed
- **macOS:** 10.13+
- **Windows:** Windows 10/11, PowerShell 5.1+

### License

MIT

---

## 中文

### 这是什么？

`claudehere` 给你的文件管理器加一个**一键启动 Claude Code** 的快捷入口。

支持 **macOS**（Finder 工具栏按钮）和 **Windows**（右键菜单）。

不用再手动 `cd`，不用再复制粘贴路径。

🌐 [claudehere.com](https://claudehere.com)

### macOS — Finder 工具栏按钮

**安装：**

```bash
git clone https://github.com/todaylabs/claudehere.git
cd claudehere
bash scripts/install.sh
```

**添加到 Finder 工具栏：**

1. 在 Finder 中打开任意文件夹
2. 右键点击工具栏 → **「自定义工具栏…」**
3. 打开另一个 Finder 窗口，进入 `/Applications`
4. 把 **Claude Here** 拖到工具栏上
5. 完成！

**使用 iTerm2 替代系统终端：**

```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
export CLAUDEHERE_TERMINAL=iterm
```

**卸载：**

```bash
bash scripts/uninstall.sh
```

### Windows — 右键菜单

在资源管理器右键菜单中添加 **「Open Claude Code Here」**。

**安装（以管理员身份运行 PowerShell）：**

```powershell
git clone https://github.com/todaylabs/claudehere.git
cd claudehere
powershell -ExecutionPolicy Bypass -File scripts\install-windows.ps1
```

**使用方法：**

1. 在资源管理器中打开任意文件夹
2. 在空白处右键
3. 点击 **「Open Claude Code Here」**

> Windows 11 需要先点「显示更多选项」才能看到。

会自动检测 Windows Terminal，如果没有则使用 cmd.exe。

**卸载（以管理员身份运行 PowerShell）：**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\uninstall-windows.ps1
```

### 系统要求

- 已安装 [Claude Code CLI](https://docs.claude.com/en/docs/claude-code)
- **macOS:** 10.13+
- **Windows:** Windows 10/11, PowerShell 5.1+

### 许可证

MIT
