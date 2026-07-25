#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$config_dir"

configs=(
  atuin
  ghostty
  nushell
  nvim
  starship
  television
  wezterm
  zellij
)

for config in "${configs[@]}"; do
  target="$config_dir/$config"
  if [[ -e "$target" && ! -L "$target" ]]; then
    printf 'Skipping %s: %s already exists and is not a symlink\n' "$config" "$target"
    continue
  fi
  ln -sfn "$repo_dir/$config" "$target"
done

mkdir -p "$config_dir/tmux"
for file in tmux.conf tmux.reset.conf; do
  target="$config_dir/tmux/$file"
  if [[ -e "$target" && ! -L "$target" ]]; then
    printf 'Skipping tmux/%s: %s already exists and is not a symlink\n' "$file" "$target"
    continue
  fi
  ln -sfn "$repo_dir/tmux/$file" "$target"
done

if [[ ! -e "$HOME/.zshrc" || -L "$HOME/.zshrc" ]]; then
  ln -sfn "$repo_dir/zsh/.zshrc" "$HOME/.zshrc"
else
  printf 'Skipping Zsh config: %s already exists and is not a symlink\n' "$HOME/.zshrc"
fi

if [[ ! -d "$HOME/.tmux/plugins/tpm/.git" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

printf '%s\n' 'Config links are ready.'
printf '%s\n' 'Start tmux and press prefix + I to install the TPM plugins.'
