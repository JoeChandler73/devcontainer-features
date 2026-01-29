#!/bin/bash
set -e

# Variables automatically injected by the Dev Container engine
USERNAME=${_REMOTE_USER:-"vscode"}
HOME_DIR="/home/${USERNAME}"

CATPPUCCIN_FLAVOUR=${FLAVOUR:-"frappe"}

# --- Step 1: Clone zsh-syntax-highlighting plugin---

# Define installation directory
INSTALL_DIR="${HOME_DIR}/.zsh/plugins/zsh-syntax-highlighting"

# 1. Clone the repository if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Cloning zsh-syntax-highlighting..."
    mkdir -p "${HOME_DIR}/.zsh/plugins"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$INSTALL_DIR"
else
    echo "zsh-syntax-highlighting already cloned at $INSTALL_DIR"
fi

# --- Step 2: Clone catppuccin-syntax-highlighting plugin

CATPPUCCIN_INSTALL_DIR="${HOME_DIR}/.zsh/plugins/catppuccin-syntax-highlighting"
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git "$CATPPUCCIN_INSTALL_DIR"

# --- Step 3: Write to .zshrc to specify which catppuccin flavour to use

ZSHRC="${HOME_DIR}/.zshrc"
SOURCE_CMD="source $CATPPUCCIN_INSTALL_DIR/themes/catppuccin_$FLAVOUR-zsh-syntax-highlighting.zsh"
echo -e "\n# Catppuccin Syntax Highlighting\n$SOURCE_CMD" >> "$ZSHRC"

# --- Step 4: Write to .zshrc to get syntax highlighting 

SOURCE_CMD="source $INSTALL_DIR/zsh-syntax-highlighting.zsh"

if grep -Fxq "$SOURCE_CMD" "$ZSHRC"; then
    echo "Syntax highlighting is already configured in .zshrc"
else
    echo "Adding syntax highlighting to .zshrc..."
    echo -e "\n# Zsh Syntax Highlighting\n$SOURCE_CMD" >> "$ZSHRC"
fi

echo "Done! Restart your terminal or run 'source ~/.zshrc' to apply changes."
