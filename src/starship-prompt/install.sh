#!/bin/bash
set -e

# Variables automatically injected by the Dev Container engine
USERNAME=${_REMOTE_USER:-"vscode"}
HOME_DIR="/home/${USERNAME}"

STARSHIP_PRESET=${STARSHIPPRESET:-"catppuccin-powerline"}

# --- Step 1: Install Starship Prompt---
echo "Installing Starship prompt..."
if curl -fsSL https://starship.rs/install.sh | sh -s -- -y; then
    echo "Starship installed successfully."
else
    echo "Error: Starship installation failed."
    exit 1
fi

# --- Step 2: Configure Starship Preset
echo "Configuring Starship with preset: ${STARSHIP_PRESET}..."

# Add Starship initialization to .zshrc if not already present
if ! grep -q "starship init zsh" "${HOME_DIR}/.zshrc" 2>/dev/null; then
    cat << 'EOF' >> "${HOME_DIR}/.zshrc"

# --- Starship Prompt Configuration ---
eval "$(starship init zsh)"
EOF
    echo "Added Starship to .zshrc"
else
    echo "Starship already configured in .zshrc"
fi

# Set up Starship config
mkdir -p "${HOME_DIR}/.config"
if command -v starship >/dev/null 2>&1; then
    starship preset "${STARSHIP_PRESET}" -o "${HOME_DIR}/.config/starship.toml"
    echo "Starship preset '${STARSHIP_PRESET}' configured."
fi

# Remove end of line prompt from vscode terminal as it will get in the way
echo -e "\n# Remove EOL prompt\nPROMPT_EOL_MARK=''" >> "${HOME_DIR}/.zshrc"

# --- Step 3: Fix permissions ---
echo "Fixing permissions..."
chown -R "${USERNAME}:${USERNAME}" "${HOME_DIR}/.config" 2>/dev/null || true

echo "Dev container customization complete!"
echo "Preset: ${STARSHIP_PRESET}"