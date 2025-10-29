# My Development Environment Setup

Welcome to my personal development setup — a fully tuned environment built for speed, clarity, and modern workflows.
It combines **WezTerm**, **Neovim (CyberNvim)**, and a set of CLI tools that make development smooth across languages like Go, C++, TypeScript, and Python.

---

## 🧩 Features

- ⚡ **CyberNvim** – a high-performance Neovim configuration with Lazy loading and LSP support
- 💻 **WezTerm** – a fast GPU-accelerated terminal with Lua-based customization
- 🧠 **Language Server Protocol (LSP)** and autocompletion
- 🎨 **Custom keymaps**, themes, and UI tweaks for productivity
- 🧰 Optimized for **Go**, **TypeScript**, **C++**, and **Python**

---

## 🚀 Prerequisites

Before setting up, make sure you have the following installed:

| Tool                | Description            | Install Command (macOS)       |
| ------------------- | ---------------------- | ----------------------------- |
| **Neovim** (≥0.9)   | Text editor core       | `brew install neovim`         |
| **WezTerm**         | Terminal emulator      | `brew install --cask wezterm` |
| **Git**             | Version control        | `brew install git`            |
| **Node.js** + npm   | Required for LSPs      | `brew install node`           |
| **Python 3** + pip  | For Python tooling     | `brew install python`         |
| **ripgrep**, **fd** | Telescope dependencies | `brew install ripgrep fd`     |

> 🧰 Linux users can install equivalents using `apt`, `dnf`, or `pacman`.
> Windows users can use [scoop](https://scoop.sh/) or [winget](https://learn.microsoft.com/en-us/windows/package-manager/).

---

## ⚙️ Setup

### 1. Clone This Repo

```bash
git clone https://github.com/johnsongdev/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. 🧩 Setup WezTerm

Copy the WezTerm configuration:

```bash
cp wezterm-config.lua ~/.wezterm.lua
```

Or, if you prefer to keep things under .config:

```mkdir -p ~/.config/wezterm
cp wezterm-config.lua ~/.config/wezterm/wezterm.lua
```
