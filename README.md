# My Development Environment Setup

My personal development environment: **WezTerm** + **Neovim (LazyVim)**.

The base configs are borrowed (WezTerm config from Omer Hamerman's / DevOps Toolbox's dotfiles, Neovim from the [LazyVim starter](https://github.com/LazyVim/starter)) and tweaked to taste.

---

## 🧩 What's Here

```
├── wezterm/wezterm.lua   # WezTerm terminal config
└── nvim/                 # Full Neovim (LazyVim) config
```

### 💻 WezTerm

- **Catppuccin Mocha** color scheme
- **JetBrains Mono**, 16pt
- Tab bar disabled, `RESIZE`-only window decorations, subtle macOS background blur
- `Ctrl+Q` → toggle fullscreen, `Ctrl+'` → clear scrollback, `Ctrl+Click` → open link under cursor

### ⚡ Neovim (LazyVim)

Built on the LazyVim starter with these **extras** enabled: aerial, harpoon2, mini-files, mini-surround, DAP core, and language support for **Go, C/C++ (clangd), TypeScript, Python, Terraform, Docker, Helm, YAML, JSON, Markdown**.

Personal tweaks on top:

- **Go** (`lua/plugins/go.lua`) – gopls with `staticcheck`, `gofumpt`, unused-param analysis, auto-imports, and placeholders
- **YAML** (`lua/plugins/conform.lua`) – format with `yamlfmt` (K8s-friendly: basic formatter, indentless arrays)
- **AI** (`lua/plugins/opencode.lua`) – [opencode.nvim](https://github.com/NickvanDyke/opencode.nvim) with `<leader>o*` keymaps for ask/explain/prompt workflows
- **Surround** (`lua/plugins/surround.lua`) – mini.surround with `sa`/`sd`/`gsr`-style mappings
- **Keymaps** – `jj` and `jk` to escape insert mode
- **Options** – line wrap on, manual folding

Plugin versions are pinned in `nvim/lazy-lock.json`.

---

## 🚀 Prerequisites

| Tool                | Description            | Install Command (macOS)       |
| ------------------- | ---------------------- | ----------------------------- |
| **Neovim** (≥0.9)   | Text editor core       | `brew install neovim`         |
| **WezTerm**         | Terminal emulator      | `brew install --cask wezterm` |
| **Git**             | Version control        | `brew install git`            |
| **Node.js** + npm   | Required for LSPs      | `brew install node`           |
| **Python 3** + pip  | For Python tooling     | `brew install python`         |
| **ripgrep**, **fd** | Picker dependencies    | `brew install ripgrep fd`     |
| **yamlfmt**         | YAML formatter         | `brew install yamlfmt`        |
| **JetBrains Mono**  | Terminal font          | `brew install --cask font-jetbrains-mono` |

> 🧰 Linux users can install equivalents using `apt`, `dnf`, or `pacman`.

---

## ⚙️ Setup

### 1. Clone this repo

```bash
git clone https://github.com/jsongga/coding-env.git ~/coding-env
cd ~/coding-env
```

### 2. WezTerm

```bash
mkdir -p ~/.config/wezterm
cp wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

### 3. Neovim

Back up any existing config first, then copy this one in:

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
cp -R nvim ~/.config/nvim
```

Launch `nvim` — lazy.nvim will bootstrap itself and install all plugins on first run.
