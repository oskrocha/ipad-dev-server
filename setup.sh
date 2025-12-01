#!/bin/bash
# Don't exit on errors - we'll handle them individually
set +e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run as root. Run as a regular user with sudo privileges."
    exit 1
fi

print_info "Starting VPS setup script for Fedora 42..."

# Detect OS
if [ -f /etc/fedora-release ]; then
    OS="fedora"
    print_success "Detected Fedora"
elif [ -f /etc/debian_version ]; then
    OS="debian"
    print_success "Detected Debian"
else
    print_error "Unsupported OS. This script supports Fedora and Debian."
    exit 1
fi

# Update system
print_info "Updating system packages..."
if [ "$OS" = "fedora" ]; then
    sudo dnf upgrade -y --refresh
else
    sudo apt update && sudo apt upgrade -y
fi
print_success "System updated"

# Install essential packages
print_info "Installing essential packages..."
if [ "$OS" = "fedora" ]; then
    sudo dnf install -y --skip-unavailable \
        curl \
        wget \
        git \
        gcc \
        gcc-c++ \
        make \
        ca-certificates \
        gnupg \
        htop \
        tmux \
        unzip \
        net-tools \
        openssl \
        hostname \
        util-linux \
        fastfetch || true
    # neofetch is deprecated, fastfetch is the modern replacement
else
    sudo apt install -y \
        curl \
        wget \
        git \
        build-essential \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        htop \
        tmux \
        unzip \
        net-tools \
        fastfetch || sudo apt install -y neofetch || true
fi
print_success "Essential packages installed"

# ===================================
# VIRTUAL MEMORY (SWAP) SETUP
# ===================================
print_info "Setting up virtual memory (swap)..."

# Check if swap already exists
if swapon --show | grep -q '/swapfile'; then
    print_info "Swap file already exists, skipping..."
else
    # Calculate optimal swap size based on available RAM
    TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    TOTAL_RAM_GB=$((TOTAL_RAM_KB / 1024 / 1024))
    
    # Swap size logic:
    # RAM <= 2GB  -> Swap = 2x RAM
    # RAM 2-8GB   -> Swap = RAM
    # RAM 8-16GB  -> Swap = 8GB
    # RAM > 16GB  -> Swap = 4GB
    
    if [ $TOTAL_RAM_GB -le 2 ]; then
        SWAP_SIZE_GB=$((TOTAL_RAM_GB * 2))
        if [ $SWAP_SIZE_GB -lt 2 ]; then
            SWAP_SIZE_GB=2
        fi
    elif [ $TOTAL_RAM_GB -le 8 ]; then
        SWAP_SIZE_GB=$TOTAL_RAM_GB
    elif [ $TOTAL_RAM_GB -le 16 ]; then
        SWAP_SIZE_GB=8
    else
        SWAP_SIZE_GB=4
    fi
    
    SWAP_SIZE="${SWAP_SIZE_GB}G"
    SWAP_SIZE_MB=$((SWAP_SIZE_GB * 1024))
    
    print_info "Detected ${TOTAL_RAM_GB}GB RAM, creating ${SWAP_SIZE} swap..."
    
    # Detect filesystem type
    FS_TYPE=$(df -T / | tail -1 | awk '{print $2}')
    
    # Create swap file (method depends on filesystem)
    if [ "$FS_TYPE" = "btrfs" ]; then
        # Btrfs requires special handling
        print_info "Detected Btrfs filesystem, using dd for swap creation..."
        sudo truncate -s 0 /swapfile
        sudo chattr +C /swapfile 2>/dev/null || true  # Disable COW on Btrfs
        sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE_MB status=progress
    elif ! sudo fallocate -l $SWAP_SIZE /swapfile 2>/dev/null; then
        # Fallback to dd if fallocate fails
        print_info "Using dd for swap creation..."
        sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE_MB status=progress
    fi
    
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    
    # Make swap permanent
    if ! grep -q '/swapfile' /etc/fstab; then
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    fi
    
    # Optimize swap settings based on RAM
    # Less RAM = higher swappiness (use swap more)
    # More RAM = lower swappiness (use swap less)
    if [ $TOTAL_RAM_GB -le 2 ]; then
        SWAPPINESS=60
        VFS_CACHE=100
    elif [ $TOTAL_RAM_GB -le 4 ]; then
        SWAPPINESS=30
        VFS_CACHE=50
    else
        SWAPPINESS=10
        VFS_CACHE=50
    fi
    
    sudo sysctl vm.swappiness=$SWAPPINESS
    sudo sysctl vm.vfs_cache_pressure=$VFS_CACHE
    
    # Make sysctl settings permanent
    if ! grep -q 'vm.swappiness' /etc/sysctl.conf; then
        echo "vm.swappiness=$SWAPPINESS" | sudo tee -a /etc/sysctl.conf
        echo "vm.vfs_cache_pressure=$VFS_CACHE" | sudo tee -a /etc/sysctl.conf
    else
        # Update existing values
        sudo sed -i "s/^vm.swappiness=.*/vm.swappiness=$SWAPPINESS/" /etc/sysctl.conf
        sudo sed -i "s/^vm.vfs_cache_pressure=.*/vm.vfs_cache_pressure=$VFS_CACHE/" /etc/sysctl.conf
    fi
    
    print_success "Virtual memory (${SWAP_SIZE} swap) configured with swappiness=$SWAPPINESS"
fi

# ===================================
# DOCKER INSTALLATION
# ===================================
print_info "Installing Docker..."

if command -v docker &> /dev/null; then
    print_info "Docker already installed"
else
    if [ "$OS" = "fedora" ]; then
        # Remove old versions
        sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest \
            docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine 2>/dev/null || true
        
        # Add Docker's official repository
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
        
        # Install Docker Engine
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        # Start and enable Docker
        sudo systemctl start docker
        sudo systemctl enable docker
        
    else
        # Remove old versions
        sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
        
        # Add Docker's official GPG key
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        
        # Set up the repository
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Install Docker Engine
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    print_success "Docker installed"
fi

# ===================================
# CODE-SERVER SETUP
# ===================================
print_info "Setting up code-server with Docker..."

# Create code-server directory
CODESERVER_DIR="$HOME/code-server"
mkdir -p "$CODESERVER_DIR"/{config,projects}

# Move uploaded docker-compose.yml and nginx.conf if they exist in home directory
if [ -f "$HOME/docker-compose.yml" ]; then
    mv "$HOME/docker-compose.yml" "$CODESERVER_DIR/"
    print_success "Moved docker-compose.yml to $CODESERVER_DIR"
fi

if [ -f "$HOME/nginx.conf" ]; then
    mv "$HOME/nginx.conf" "$CODESERVER_DIR/"
    print_success "Moved nginx.conf to $CODESERVER_DIR"
fi

# Generate a random password for code-server
CODESERVER_PASSWORD=$(openssl rand -base64 32)

# Create .env file for docker-compose
cat > "$CODESERVER_DIR/.env" << EOF
# Code-server configuration
CODESERVER_PASSWORD=$CODESERVER_PASSWORD
PUID=$(id -u)
PGID=$(id -g)
TZ=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "UTC")
EOF

# Generate self-signed SSL certificate
print_info "Generating self-signed SSL certificate..."
sudo mkdir -p /etc/ssl/code-server
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/code-server/privkey.pem \
    -out /etc/ssl/code-server/fullchain.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=$(hostname -I | awk '{print $1}')"
sudo chmod 644 /etc/ssl/code-server/*.pem

print_success "SSL certificate generated"

# Save password to file for user reference
echo "$CODESERVER_PASSWORD" > "$CODESERVER_DIR/PASSWORD.txt"
chmod 600 "$CODESERVER_DIR/PASSWORD.txt"

print_success "Code-server directory structure created"

# ===================================
# ZSH AND OH-MY-ZSH
# ===================================
print_info "Installing Zsh and Oh My Zsh..."

if command -v zsh &> /dev/null; then
    print_info "Zsh already installed"
else
    if [ "$OS" = "fedora" ]; then
        sudo dnf install -y zsh
    else
        sudo apt install -y zsh
    fi
    print_success "Zsh installed"
fi

# Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_info "Oh My Zsh already installed"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
fi

# Install Nerd Fonts for Powerlevel10k
print_info "Installing Nerd Fonts for Powerlevel10k..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    cd /tmp || exit
    curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    mv MesloLGS*.ttf "$FONT_DIR/"
    
    # Update font cache
    if command -v fc-cache &> /dev/null; then
        fc-cache -fv "$FONT_DIR" 2>/dev/null || true
    fi
    
    cd - > /dev/null || exit
    print_success "Nerd Fonts installed (for SSH: configure terminal to use 'MesloLGS NF')"
else
    print_info "Nerd Fonts already installed"
fi

# Install Powerlevel10k theme
print_info "Installing Powerlevel10k theme..."
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_info "Powerlevel10k already installed"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    print_success "Powerlevel10k installed"
fi

# Install useful Zsh plugins
print_info "Installing Zsh plugins..."

# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Update .zshrc
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
sed -i 's/plugins=(git)/plugins=(git docker docker-compose node npm rust golang python pip zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"

# Add useful aliases and configurations
if ! grep -q "# Custom aliases" "$HOME/.zshrc"; then
    cat >> "$HOME/.zshrc" << 'EOF'

# Custom aliases
alias ls='eza --icons --group-directories-first' 2>/dev/null || alias ls='exa --icons --group-directories-first' 2>/dev/null || alias ls='ls --color=auto'
alias ll='eza -lah --icons --group-directories-first' 2>/dev/null || alias ll='exa -lah --icons --group-directories-first' 2>/dev/null || alias ll='ls -lah'
alias lt='eza --tree --level=2 --icons' 2>/dev/null || alias lt='exa --tree --level=2 --icons' 2>/dev/null || alias lt='tree -L 2'
alias cat='bat --paging=never' 2>/dev/null || alias cat='cat'
alias lg='lazygit'
alias v='nvim'
alias vim='nvim'
alias dc='docker compose'
alias dps='docker ps'
alias di='docker images'
alias weather='curl wttr.in'
alias myip='curl ifconfig.me'

# Useful functions
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# PATH additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
EOF
fi

print_success "Zsh plugins and aliases configured"

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
    print_success "Default shell changed to Zsh (restart session to apply)"
fi

# ===================================
# LAZYGIT INSTALLATION
# ===================================
print_info "Installing LazyGit..."

if command -v lazygit &> /dev/null; then
    print_info "LazyGit already installed"
else
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    print_success "LazyGit installed"
fi

# ===================================
# NEOVIM AND LAZYVIM
# ===================================
print_info "Installing Neovim..."

if command -v nvim &> /dev/null; then
    print_info "Neovim already installed"
else
    if [ "$OS" = "fedora" ]; then
        # Fedora has a recent Neovim in repos
        sudo dnf install -y neovim
    else
        # For Debian, use AppImage to get latest version
        sudo apt install -y fuse libfuse2
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
    fi
    print_success "Neovim installed"
fi

# Install LazyVim
print_info "Installing LazyVim..."

if [ -d "$HOME/.config/nvim" ]; then
    print_info "Neovim config already exists, backing up..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)"
    mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
    mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
    mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
fi

# Install LazyVim starter
git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"

print_success "LazyVim installed"

# Install required dependencies for LazyVim
print_info "Installing LazyVim dependencies..."
if [ "$OS" = "fedora" ]; then
    sudo dnf install -y ripgrep fd-find
else
    sudo apt install -y ripgrep fd-find
    # Create symlinks for fd on Debian (LazyVim expects 'fd' command)
    if [ ! -f /usr/local/bin/fd ]; then
        sudo ln -s "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
    fi
fi

print_success "LazyVim dependencies installed"

# ===================================
# ADDITIONAL USEFUL TOOLS
# ===================================
print_info "Installing additional useful tools..."

if [ "$OS" = "fedora" ]; then
    # bat (better cat)
    if ! command -v bat &> /dev/null; then
        sudo dnf install -y bat
    fi

    # exa/eza (better ls) - try eza first, fallback to exa
    if ! command -v eza &> /dev/null && ! command -v exa &> /dev/null; then
        sudo dnf install -y eza 2>/dev/null || sudo dnf install -y exa 2>/dev/null || true
    fi

    # ncdu (disk usage analyzer)
    sudo dnf install -y ncdu

    # tldr (simplified man pages)
    sudo dnf install -y tldr
    
    # btop (better htop)
    sudo dnf install -y btop 2>/dev/null || true
    
    # jq (JSON processor)
    sudo dnf install -y jq
    
    # tree (directory viewer)
    sudo dnf install -y tree
else
    # bat (better cat)
    if ! command -v bat &> /dev/null; then
        sudo apt install -y bat
        mkdir -p "$HOME/.local/bin"
        ln -s /usr/bin/batcat "$HOME/.local/bin/bat" 2>/dev/null || true
    fi

    # exa/eza (better ls)
    if ! command -v eza &> /dev/null && ! command -v exa &> /dev/null; then
        sudo apt install -y eza 2>/dev/null || sudo apt install -y exa 2>/dev/null || true
    fi

    # ncdu (disk usage analyzer)
    sudo apt install -y ncdu

    # tldr (simplified man pages)
    sudo apt install -y tldr
    
    # btop (better htop)
    sudo apt install -y btop 2>/dev/null || true
    
    # jq (JSON processor)
    sudo apt install -y jq
    
    # tree (directory viewer)
    sudo apt install -y tree
fi

# fzf (fuzzy finder) - same for both
if ! command -v fzf &> /dev/null; then
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        "$HOME/.fzf/install" --all
    else
        print_info "fzf directory exists, running install..."
        "$HOME/.fzf/install" --all
    fi
fi

# delta (better git diff)
if ! command -v delta &> /dev/null; then
    print_info "Installing git-delta..."
    DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -n "$DELTA_VERSION" ]; then
        if [ "$OS" = "fedora" ]; then
            curl -Lo delta.rpm "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta-${DELTA_VERSION}-1.x86_64.rpm"
            sudo dnf install -y ./delta.rpm
            rm delta.rpm
        else
            curl -Lo delta.deb "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
            sudo dpkg -i delta.deb
            rm delta.deb
        fi
    else
        print_info "Could not fetch delta version, skipping..."
    fi
fi

print_success "Additional tools installed"

# ===================================
# PROGRAMMING LANGUAGES & RUNTIMES
# ===================================
print_info "Installing programming languages and runtimes..."

if [ "$OS" = "fedora" ]; then
    # Python 3 and pip
    sudo dnf install -y python3 python3-pip python3-devel
    
    # Node.js and npm
    sudo dnf install -y nodejs npm
    
    # Go
    sudo dnf install -y golang 2>/dev/null || true
    
    # Rust (via rustup)
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        source "$HOME/.cargo/env" 2>/dev/null || true
    fi
else
    # Python 3 and pip
    sudo apt install -y python3 python3-pip python3-venv python3-dev
    
    # Node.js and npm (use NodeSource for latest)
    if ! command -v node &> /dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
    
    # Go
    sudo apt install -y golang 2>/dev/null || true
    
    # Rust (via rustup)
    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        source "$HOME/.cargo/env" 2>/dev/null || true
    fi
fi

print_success "Programming languages installed"

# ===================================
# GIT CONFIGURATION
# ===================================
print_info "Configuring Git..."

# Configure delta for better git diffs
git config --global core.pager "delta" 2>/dev/null || true
git config --global interactive.diffFilter "delta --color-only" 2>/dev/null || true
git config --global delta.navigate true 2>/dev/null || true
git config --global delta.light false 2>/dev/null || true
git config --global merge.conflictstyle diff3 2>/dev/null || true
git config --global diff.colorMoved default 2>/dev/null || true

print_success "Git configured with delta"

# ===================================
# FIREWALL SETUP
# ===================================
print_info "Configuring firewall..."

if [ "$OS" = "fedora" ]; then
    # Fedora uses firewalld
    sudo dnf install -y firewalld
    sudo systemctl start firewalld
    sudo systemctl enable firewalld
    
    # Configure firewalld
    sudo firewall-cmd --permanent --add-service=ssh
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --permanent --add-port=443/tcp
    sudo firewall-cmd --reload
    
    print_success "Firewalld configured"
else
    # Debian uses UFW
    sudo apt install -y ufw
    
    # Configure UFW
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow 443/tcp  # HTTPS for code-server
    
    # Enable UFW
    echo "y" | sudo ufw enable
    
    print_success "UFW firewall configured"
fi

# ===================================
# SELINUX CONFIGURATION (Fedora only)
# ===================================
if [ "$OS" = "fedora" ]; then
    print_info "Configuring SELinux for Docker..."
    
    # Allow Docker to work with SELinux
    sudo setsebool -P container_manage_cgroup on 2>/dev/null || true
    
    # Set appropriate contexts for code-server directories
    sudo semanage fcontext -a -t container_file_t "$CODESERVER_DIR(/.*)?" 2>/dev/null || true
    sudo restorecon -Rv "$CODESERVER_DIR" 2>/dev/null || true
    
    print_success "SELinux configured for Docker"
fi

# ===================================
# FINAL STEPS
# ===================================
print_info "Setup complete! Please review the following information:"
echo ""
echo "=========================================="
echo "CODE-SERVER INFORMATION"
echo "=========================================="
echo "Directory: $CODESERVER_DIR"
echo "Password saved in: $CODESERVER_DIR/PASSWORD.txt"
echo "Password: $CODESERVER_PASSWORD"
echo ""
echo "To start code-server:"
echo "  cd $CODESERVER_DIR"
echo "  docker compose up -d"
echo ""
echo "Access code-server at:"
echo "  https://$(hostname -I | awk '{print $1}'):8443"
echo ""
echo "Note: You'll see a security warning due to self-signed certificate."
echo "This is expected - click 'Advanced' and proceed."
echo ""
echo "=========================================="
echo "INSTALLED TOOLS"
echo "=========================================="
echo "✓ Docker & Docker Compose"
echo "✓ Code-server (via Docker)"
echo "✓ Zsh + Oh My Zsh + Powerlevel10k"
echo "✓ LazyGit"
echo "✓ Neovim + LazyVim"
echo "✓ Additional tools: bat, exa, fzf, ncdu, tldr"
echo ""
echo "=========================================="
echo "NEXT STEPS"
echo "=========================================="
echo "1. Logout and login again (or run: exec zsh)"
echo "2. Run 'p10k configure' to set up Powerlevel10k"
echo "3. Start code-server: cd $CODESERVER_DIR && docker compose up -d"
echo "4. Run 'nvim' to initialize LazyVim plugins"
echo ""
echo "=========================================="

print_success "Setup script completed successfully!"
