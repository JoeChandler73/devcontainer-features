#!/bin/bash
set -e

# Variables automatically injected by the Dev Container engine
USERNAME=${_REMOTE_USER:-"vscode"}
HOME_DIR="/home/${USERNAME}"

# Feature options (injected as environment variables with uppercase names)
NERD_FONT=${NERDFONT:-"Hack"}
FONT_VERSION=${FONTVERSION:-"v3.4.0"}

echo "Starting dev container customization for user: ${USERNAME}"
echo "Configuration: Font=${NERD_FONT}"

# --- Step 1: Install dependencies ---
echo "Installing fontconfig and unzip..."
export DEBIAN_FRONTEND=noninteractive
apt-get update && \
apt-get install -y --no-install-recommends \
        fontconfig \
        unzip \
        curl \
        && rm -rf /var/lib/apt/lists/*

# --- Step 2: Install Nerd Fonts ---
echo "Installing Nerd Font: ${NERD_FONT}..."
FONT_DIR="${HOME_DIR}/.local/share/fonts"
mkdir -p "${FONT_DIR}"

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/${NERD_FONT}.zip"

if curl -fsSL "${FONT_URL}" -o "${FONT_DIR}/${NERD_FONT}.zip"; then
    unzip -q "${FONT_DIR}/${NERD_FONT}.zip" -d "${FONT_DIR}"
    rm "${FONT_DIR}/${NERD_FONT}.zip"
    # Remove Windows-specific files if any
    find "${FONT_DIR}" -name "*Windows Compatible*" -delete
    fc-cache -fv
    echo "Nerd Font '${NERD_FONT}' installed successfully."
else
    echo "Warning: Failed to download Nerd Font '${NERD_FONT}'. Continuing anyway..."
fi

# --- Step 5: Fix permissions ---
echo "Fixing permissions..."
chown -R "${USERNAME}:${USERNAME}" "${HOME_DIR}/.local" 2>/dev/null || true

echo "Dev container customization complete!"
echo "Font: ${NERD_FONT}"