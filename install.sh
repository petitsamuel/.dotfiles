#!/bin/zsh
#
# Dotfiles installation script

set -e

DOTFILES_DIR="${0:a:h}"

echo "Creating symbolic links..."

declare -A links

# We are now defining the keys WITHOUT quotes around them.
# This is a more robust syntax for this specific case.
links[$DOTFILES_DIR/.zshrc]=$HOME/.zshrc
links[$DOTFILES_DIR/.aliases]=$HOME/.aliases
links[$DOTFILES_DIR/.p10k.zsh]=$HOME/.p10k.zsh
links[$DOTFILES_DIR/tmux/.tmux.conf]=$HOME/.tmux.conf
links[$DOTFILES_DIR/nvim]=$HOME/.config/nvim

for source in "${(@k)links}"; do
    dest="${links[$source]}"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing file: $dest"
        mv "$dest" "$dest.bak"
    fi

    mkdir -p "$(dirname "$dest")"
    
    echo "Creating symlink: ${source} -> ${dest}"
    ln -s "${source}" "${dest}"
done

echo "Dotfiles installation complete!"
echo "Please run 'source ~/.zshrc' or restart your shell."
