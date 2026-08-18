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
# Option A: If your repo is organized into package directories (git/, bash/, nvim/, etc.)
for dir in */; do
    # Ensure it's an actual directory (and not an unmatched glob)
    [ -d "$dir" ] || continue

    # Strip trailing slash
    dir="${dir%/}"

    # Skip hidden directories (like .git)
    case "$dir" in
        .*) continue ;;
    esac

    echo "Stowing package: $dir"
    stow --restow --target="$HOME" "$dir"
done

# Option B: If your repo is NOT organized in subfolders, use this instead of the loop above:
# stow --restow --target="$HOME" .

echo "=== Dotfiles setup complete! ==="
