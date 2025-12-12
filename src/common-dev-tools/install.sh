#!/bin/bash
set -e

USERNAME=${_REMOTE_USER:-"vscode"}
HOME_DIR="/home/${USERNAME}"

echo "Installing common development tools..."

export DEBIAN_FRONTEND=noninteractive

# Essential packages
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    gnupg2 \
    build-essential \
    procps \
    lsof \
    htop \
    net-tools \
    psmisc \
    sudo \
    vim \
    nano \
    less \
    jq \
    zip \
    unzip \
    tar \
    rsync \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Setup sudo for vscode user
if ! grep -q "^${USERNAME}" /etc/sudoers; then
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Git configuration helpers
cat << 'EOF' > /usr/local/bin/git-setup
#!/bin/bash
# Helper script to configure git
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: git-setup <name> <email>"
    exit 1
fi
git config --global user.name "$1"
git config --global user.email "$2"
git config --global init.defaultBranch main
git config --global pull.rebase false
echo "Git configured for $1 <$2>"
EOF
chmod +x /usr/local/bin/git-setup

# Create useful aliases
cat << 'EOF' >> "${HOME_DIR}/.bashrc"

# Common aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --decorate --graph'

# Docker aliases
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlogs='docker logs -f'

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Better history
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Color prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

EOF

# Setup directories
mkdir -p "${HOME_DIR}/.local/bin"
mkdir -p "${HOME_DIR}/.local/state"

# Add .local/bin to PATH if not already there
if ! grep -q ".local/bin" "${HOME_DIR}/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "${HOME_DIR}/.bashrc"
fi

# Fix permissions
chown -R "${USERNAME}:${USERNAME}" "${HOME_DIR}/.local"
chown "${USERNAME}:${USERNAME}" "${HOME_DIR}/.bashrc"

echo "Common development tools installed successfully!"