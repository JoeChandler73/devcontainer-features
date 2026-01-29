#!/bin/bash
set -e

# Variables automatically injected by the Dev Container engine
USERNAME=${_REMOTE_USER:-"vscode"}
HOME_DIR="/home/${USERNAME}"

# --- Step 1: Clone git repo to local oh-my-zsh themes driectory ---
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME_DIR}/.oh-my-zsh/custom/themes/powerlevel10k"

# --- Step 1: Update the ZSH_THEME in .zshrc to use poerlevel10k ---
sed -i 's/ZSH_THEME="devcontainers"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "${HOME_DIR}/.zshrc"

# --- Step 3: Remove vscodes terminal prompt as it will no be required now ---
echo -e "\n# Remove EOL prompt\nPROMPT_EOL_MARK=''" >> "${HOME_DIR}/.zshrc"