#!/bin/sh
set -e

echo "=== Setting up Dotfiles with GNU Stow ==="

# 1. Install GNU Stow if not present
if ! command -v stow >/dev/null 2>&1; then
    echo "GNU Stow not found. Installing..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v apk >/dev/null 2>&1; then
        sudo apk add stow
    fi
fi

# 2. Navigate to the dotfiles directory (POSIX standard for $0)
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# 3. Stow packages
# This repo is NOT organized into per-tool subfolders (git/, bash/, nvim/, etc.) —
# the dotfiles (.config/, .p10k.zsh, .zshrc, ...) live directly in the repo root,
# so it must be stowed as a single package, excluding repo-management files.
echo "Stowing package: $(basename "$DOTFILES_DIR")"
stow --restow --target="$HOME" --ignore='^install\.sh$' --ignore='^README\.md$' --ignore='^\.git$' .

echo "=== Dotfiles setup complete! ==="
