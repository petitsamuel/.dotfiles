#!/bin/bash
#
# Dotfiles installation script

set -e # Exit immediately if a command exits with a non-zero status.

# The directory where this script is
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Creating symbolic links..."

# List of files/dirs to symlink
# Format: "source in dotfiles -> destination in home"
declare -A links=(
    ["$DOTFILES_DIR/.zshrc"]="$HOME/.zshrc"
    ["$DOTFILES_DIR/.p10k.zsh"]="$HOME/.p10k.zsh"
    ["$DOTFILES_DIR/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
)

# Loop over the array and create symlinks
for source in "${!links[@]}"; do
    dest="${links[$source]}"
    
    # If the destination exists, back it up
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing file: $dest"
        mv "$dest" "$dest.bak"
    fi

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"
    
    echo "Creating symlink: $source -> $dest"
    ln -s "$source" "$dest"
done

echo "Dotfiles installation complete!"
echo "Please run 'source ~/.zshrc' or restart your shell."

