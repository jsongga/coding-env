# Coding environment

My macOS terminal and editor setup. The repository contains the publishable
configuration; credentials, shell history, generated caches, and machine-local
environment variables stay outside Git.

## Stack

| Area | Tools |
| --- | --- |
| Terminals | Ghostty and WezTerm |
| Shell | Zsh, with optional Nushell configuration |
| Prompt and history | Starship, Atuin |
| Multiplexers | tmux and Zellij |
| Editor | Neovim with LazyVim |
| Navigation and search | fzf, fd, ripgrep, zoxide, Television |
| Terminal utilities | bat, eza, lazygit, yazi, xh, direnv |

Ghostty is the compact daily-driver configuration: 19-point text, background
blur, hidden mouse while typing, and macOS Option-as-Alt. WezTerm provides the
same Catppuccin-oriented setup with JetBrains Mono, no tab bar, resize-only
decorations, fullscreen on `Ctrl+Q`, scrollback clearing on `Ctrl+'`, and
Ctrl-click link opening.

## tmux

tmux uses `Ctrl+A` as its prefix, vi copy-mode keys, mouse support, one-based
window indexes, automatic renumbering, a large scrollback, clipboard
integration, and a Catppuccin status line.

Plugins are installed through [TPM](https://github.com/tmux-plugins/tpm):

| Plugin | Purpose |
| --- | --- |
| `tmux-plugins/tmux-sensible` | practical tmux defaults |
| `tmux-plugins/tmux-yank` | system clipboard integration |
| `tmux-plugins/tmux-resurrect` | save and restore sessions |
| `tmux-plugins/tmux-continuum` | automatic session persistence |
| `fcsonline/tmux-thumbs` | hint-based text selection |
| `sainnhe/tmux-fzf` | fuzzy tmux commands |
| `wfxr/tmux-fzf-url` | find and open URLs from pane history |
| `omerxx/catppuccin-tmux` | Catppuccin status-line theme |
| `omerxx/tmux-sessionx` | fuzzy session management with zoxide |
| `omerxx/tmux-floax` | floating terminal panes |

Inside tmux, press `Ctrl+A`, then `I`, to install or refresh every plugin.

## Shell

The Zsh configuration provides:

- Starship prompt initialization and Atuin history search
- zsh-autosuggestions with explicit execute, accept, and toggle bindings
- vi-style command mode with `jj`
- fzf-backed file and directory helpers
- zoxide and direnv hooks
- completions for kubectl and AWS CLI
- aliases for Git, Docker, Kubernetes, eza, Neovim, and common navigation
- `~/.zshrc.local` as the untracked location for secrets and machine-only setup

Nushell and Zellij are included as alternate shell/multiplexer environments.
The Zellij config uses modal pane, tab, resize, scroll, search, and session
keymaps plus the bundled Catppuccin theme.

## Neovim

Neovim is based on LazyVim. Enabled extras cover:

- aerial, harpoon2, mini-files, and mini-surround
- DAP core
- C/C++, Docker, Go, Helm, JSON, Markdown, Python, Terraform, TypeScript, and
  YAML

Personal plugin configuration includes:

- `gopls` with staticcheck, gofumpt, analyses, imports, and placeholders
- `yamlfmt` with Kubernetes-friendly formatting
- `opencode.nvim` and `<leader>o*` AI workflow mappings
- `mini.surround` with `sa`, `sd`, and `gsr`-style mappings
- `mini.diff`, with selectable Git comparison bases shared across Gitsigns,
  Neo-tree, and MiniDiff
- `diffview.nvim` for working-tree and file/branch history views

Diff shortcuts:

| Mapping | Action |
| --- | --- |
| `<leader>gm` | toggle comparison against the default branch merge base |
| `<leader>gx` | pick a comparison branch |
| `<leader>gc` | clear the comparison base |
| `<leader>gvo` / `<leader>gvc` | open or close Diffview |
| `<leader>gvh` / `<leader>gvH` | current-file or branch history |

Plugin revisions are pinned in `nvim/lazy-lock.json`.

## Repository layout

```text
.
├── atuin/       # interactive shell history
├── ghostty/     # primary terminal
├── nushell/     # alternate shell
├── nvim/        # LazyVim configuration
├── starship/    # cross-shell prompt
├── television/  # fuzzy-search channels
├── tmux/        # multiplexer and TPM plugin declarations
├── wezterm/     # alternate terminal
├── zellij/      # alternate multiplexer and themes
├── zsh/         # primary interactive shell
├── Brewfile     # macOS packages
└── setup.sh     # safe symlink bootstrap
```

## Install

The automated path targets macOS with Homebrew:

```bash
git clone https://github.com/jsongga/coding-env.git ~/coding-env
cd ~/coding-env
brew bundle
./setup.sh
```

The setup script only replaces links. If a destination already contains a real
file or directory, it reports and preserves it. Review or back up existing
configuration, then rerun the script after moving any intended destination.

Launch Neovim once to let lazy.nvim install pinned plugins. Start tmux and press
`Ctrl+A`, then `I`, to install the TPM plugin list.

## Local-only configuration

Put secrets, private paths, SDK initialization, and host-specific environment
variables in `~/.zshrc.local`. Do not add Atuin databases, session tokens, SSH
configuration, cloud credentials, generated process snapshots, or shell
completion caches to this repository.
