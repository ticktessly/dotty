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

# 3. Back up any pre-existing real files that would conflict with stow.
# Codespaces images often ship a default .zshrc (etc.) as a plain file, which
# makes `stow` abort with a conflict on first run. Simulate with --no, and for
# any conflicting target, move the real file aside before stowing for real.
STOW_ARGS="--restow --target=$HOME --ignore=^install\.sh$ --ignore=^README\.md$ --ignore=^\.git$ ."
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

# --restow's dry-run reports each conflict once per internal pass (unstow + stow),
# so the same path can appear more than once here — dedupe before acting on it.
conflicts="$(stow --no --verbose=2 $STOW_ARGS 2>&1 \
    | sed -n 's/^.*existing target is neither a link nor a directory: //p' \
    | sort -u)"

if [ -n "$conflicts" ]; then
    echo "Found pre-existing dotfiles that conflict with stow. Backing them up to $BACKUP_DIR"
    echo "$conflicts" | while IFS= read -r rel; do
        [ -z "$rel" ] && continue
        src="$HOME/$rel"
        # Already moved (e.g. duplicate report, or parent dir moved already) — skip.
        [ -e "$src" ] || continue
        dest="$BACKUP_DIR/$rel"
        mkdir -p "$(dirname "$dest")"
        echo "  backing up $src -> $dest"
        mv "$src" "$dest"
    done
fi

# 4. Stow packages
# This repo is NOT organized into per-tool subfolders (git/, bash/, nvim/, etc.) —
# the dotfiles (.config/, .p10k.zsh, .zshrc, ...) live directly in the repo root,
# so it must be stowed as a single package, excluding repo-management files.
echo "Stowing package: $(basename "$DOTFILES_DIR")"
stow $STOW_ARGS

echo "=== Dotfiles setup complete! ==="
