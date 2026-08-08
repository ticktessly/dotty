#!/usr/bin/env bash
# Codespaces dotfiles bootstrap.
# Runs automatically when "Automatically install dotfiles" is enabled
# in https://github.com/settings/codespaces and pointed at this repo.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing mise"
if ! command -v mise &> /dev/null; then
  curl -fsSL https://mise.run | sh
fi

# mise installs to ~/.local/bin by default
export PATH="$HOME/.local/bin:$PATH"

# Activate mise for this (non-interactive) script, and make sure it's
# wired into future interactive shells too.
eval "$(mise activate bash --shims)"

SHELL_RC="$HOME/.bashrc"
if [ -n "${ZSH_VERSION:-}" ] || [ "${SHELL:-}" = "/usr/bin/zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
fi
if ! grep -q 'mise activate' "$SHELL_RC" 2>/dev/null; then
  echo 'eval "$(~/.local/bin/mise activate bash)"' >> "$SHELL_RC"
fi

echo "==> Linking mise config"
mkdir -p ~/.config/mise
ln -sf "$DOTFILES_DIR/mise/config.toml" ~/.config/mise/config.toml

echo "==> Installing tools via mise (neovim, ripgrep, herdr, opencode)"
mise trust "$DOTFILES_DIR/mise/config.toml" 2>/dev/null || true
mise install

echo "==> Linking Neovim config"
mkdir -p ~/.config
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.bak."$(date +%s)"
fi
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim

echo "==> Linking tmux config"
if [ -e ~/.tmux.conf ] && [ ! -L ~/.tmux.conf ]; then
  mv ~/.tmux.conf ~/.tmux.conf.bak."$(date +%s)"
fi
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf


echo "==> Done. Open a new shell (or 'source $SHELL_RC') and run 'nvim' to let lazy.nvim install plugins."
