# iPad Dev Server

```plaintext
╔════════════════════════════════════════════════════════════╗
║    ██╗██████╗  █████╗ ██████╗     ██████╗ ███████╗██╗   ██╗║
║    ██║██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔════╝██║   ██║║
║    ██║██████╔╝███████║██║  ██║    ██║  ██║█████╗  ██║   ██║║
║    ██║██╔═══╝ ██╔══██║██║  ██║    ██║  ██║██╔══╝  ╚██╗ ██╔╝║
║    ██║██║     ██║  ██║██████╔╝    ██████╔╝███████╗ ╚████╔╝ ║
║    ╚═╝╚═╝     ╚═╝  ╚═╝╚═════╝     ╚═════╝ ╚══════╝  ╚═══╝  ║
║                                                            ║
║          ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗  ║
║          ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗ ║
║          ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝ ║
║          ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗ ║
║          ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║ ║
║          ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝ ║
╚════════════════════════════════════════════════════════════╝
```

> 🚀 Transform any VPS into a complete development environment in 10 minutes.  
> Perfect for **iPad users** who need full VS Code, Docker, and modern dev tools anywhere.
>
> ⚡ **Opinionated Setup** - This script makes specific choices (Zsh, Oh My Zsh, Powerlevel10k, LazyVim, LazyGit) optimized for modern terminal workflows. If you prefer different tools, you can customize the setup.sh script.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Fedora 42](https://img.shields.io/badge/Fedora-42-blue.svg)](https://getfedora.org/)
[![Debian](https://img.shields.io/badge/Debian-12%2F13-red.svg)](https://www.debian.org/)

---

## 💡 The Frustration That Led Here

As an iPad Pro user, you've probably hit these walls:

- **No JIT compilation** → Can't run VMs like UTM for local dev environments
- **iPadOS 18 limitations** → No native terminal, no Docker, no proper IDEs
- **Locked ecosystem** → Can't install the tools that make development productive  
- **Safari-only reality** → Limited by Apple's walled garden

You have this **incredible hardware** (M4 chip, 120Hz display, all-day battery) but you're stuck using it as a glorified content consumption device.

**This project fixes that.** Turn any $5/month VPS into your personal cloud development machine with full VS Code, Docker, Git, and terminal - all accessible from Safari. No jailbreak, no workarounds, just real development power.

### Perfect For

- 📱 **iPad Pro users** who want desktop-class development
- ✈️ **Digital nomads** coding from tablets
- 🎒 **Students** with limited hardware
- 🏖️ **Remote workers** who travel light
- 💻 Anyone wanting a **powerful dev environment accessible anywhere**

---

## ✨ What You Get

One script installs everything you need:

### 🎨 **Beautiful Terminal Experience**

- **Code-Server** - Full VS Code in your browser (HTTPS secured)
- **Zsh + Oh My Zsh** - Modern shell with auto-suggestions
- **Powerlevel10k** - Beautiful prompt with Nerd Fonts
- **tmux** - Multiple terminal sessions

### 🛠️ **Complete Dev Stack**

- **Docker & Docker Compose** - Containerize everything
- **Python 3** + pip + venv
- **Node.js (LTS)** + npm
- **Go** - For fast compiled code
- **Rust** - Modern systems programming
- **Git** with delta (beautiful diffs)

### 🚀 **Modern CLI Tools**

- **LazyGit** - Terminal UI for Git
- **Neovim + LazyVim** - Modern Vim setup
- **eza/exa** - Better ls with icons
- **bat** - cat with syntax highlighting
- **fzf** - Fuzzy finder
- **btop** - Beautiful system monitor
- **jq** - JSON processor

### 🔐 **Security Built-In**

- Automatic firewall configuration
- HTTPS with SSL certificates
- Password-protected access
- SELinux configured (Fedora)
- Auto-updates via Watchtower

---

## 🎯 Recommended OS: Fedora 42

**Optimized for Fedora 42** (also supports Debian 12/13)

## 📋 What This Script Installs

### Core Components

- **Code-server** (VS Code in browser) via Docker with HTTPS
- **Virtual Memory** (4GB swap file)
- **Zsh** with Oh My Zsh and Powerlevel10k theme
- **LazyGit** - Terminal UI for git
- **Neovim** with LazyVim configuration

### Additional Tools

- **Docker & Docker Compose** - Container management
- **bat** - Better `cat` with syntax highlighting
- **exa** - Better `ls` with colors
- **fzf** - Fuzzy finder for files and history
- **ncdu** - Disk usage analyzer
- **tldr** - Simplified man pages
- **htop** - System monitor
- **tmux** - Terminal multiplexer
- **Zsh plugins** - autosuggestions and syntax highlighting

### Security Features

- **UFW Firewall** configured
- **HTTPS** with self-signed SSL certificates
- **Nginx reverse proxy** with rate limiting
- **Password-protected** code-server access
- **Docker security** best practices

## 🚀 Quick Start

### Step 0: Get the Code (First Time Setup)

**If you're new to Git, follow these steps on your local machine (Mac/Linux/WSL):**

```bash
# 1. Clone this repository to your computer
git clone https://github.com/oskrocha/ipad-dev-server.git

# 2. Navigate into the directory
cd ipad-dev-server

# 3. Make the scripts executable
chmod +x deploy.sh setup.sh verify.sh

# You're ready! Now choose Option 1 or 2 below.
```

**What if I don't have Git?**

- Download the [ZIP file](https://github.com/oskrocha/ipad-dev-server/archive/refs/heads/main.zip)
- Extract it on your computer
- Open Terminal and `cd` to the extracted folder
- Run `chmod +x *.sh` to make scripts executable

---

### Option 1: Automated Deployment (Easiest) ⭐

**One command does everything!**

```bash
# Run from the ipad-dev-server directory
./deploy.sh
```

The script will:

1. ✅ Ask for your VPS IP and username
2. ✅ Upload all files automatically
3. ✅ Run the complete installation
4. ✅ Start code-server
5. ✅ Show you the password and URL

⏱️ **Total time: 10-15 minutes**

---

### Option 2: Manual Installation

If you prefer step-by-step control:

**Prerequisites:**

- Fresh **Fedora 42** (recommended) or **Debian 12/13** VPS
- Non-root user with sudo privileges
- At least 2GB RAM (4GB+ recommended for Fedora)
- SSH access to your server
- **No GUI/Desktop environment needed** - everything runs via web interface

**Installation Steps:**

1. **Upload the setup files to your VPS:**

   ```bash
   scp setup.sh docker-compose.yml nginx.conf user@your-vps-ip:~/
   ```

2. **SSH into your VPS:**

   ```bash
   ssh user@your-vps-ip
   ```

3. **Make the setup script executable:**

   ```bash
   chmod +x setup.sh
   ```

4. **Run the setup script:**

   ```bash
   ./setup.sh
   ```

5. **Wait for completion** (approximately 5-10 minutes depending on your server speed)

6. **Logout and login again** to apply shell changes:

   ```bash
   exit
   ssh user@your-vps-ip
   ```

7. **Configure Powerlevel10k** (first time only):

   ```bash
   p10k configure
   ```

8. **Start code-server:**

   ```bash
   cd ~/code-server
   docker compose up -d
   ```

9. **Access code-server:**
   - Open your browser and navigate to: `https://YOUR_VPS_IP:443`
   - Accept the security warning (self-signed certificate)
   - Enter the password found in: `~/code-server/PASSWORD.txt`

---

## 📱 Using on iPad

### Best iPad Experience

#### Safari (Recommended)

- Open Safari → Navigate to `https://YOUR_VPS_IP:443`
- Add to Home Screen for app-like experience
- Use in fullscreen mode
- Works perfectly with iPad keyboard shortcuts

#### Split View Tips

- Safari + Safari: Documentation + Code
- Safari + Blink Shell: VS Code + Terminal
- Safari + Working Copy: Code + Git client

### Recommended iPad Apps

1. **Safari** - For code-server (built-in, works perfectly!)
2. **Blink Shell** or **Termius** - Pro SSH clients with Mosh support
3. **Working Copy** (optional) - Native Git client for iOS

### iPad Pro Tips

- **External Keyboard**: All VS Code shortcuts work
- **Stage Manager**: Multiple code-server windows
- **Trackpad/Mouse**: Full cursor support
- **Split Screen**: Code + docs side-by-side
- **Picture-in-Picture**: Watch tutorials while coding

### Real Development Workflows on iPad

#### Python Development in Code-Server (Safari)

```bash
# Open Safari on iPad → https://your-vps-ip
# Full VS Code interface with iPad keyboard shortcuts
# Create a new Python project in the browser terminal

mkdir my-project && cd my-project
python3 -m venv .venv
source .venv/bin/activate
pip install fastapi uvicorn pytest

# Write code with IntelliSense, auto-completion
# Set breakpoints and debug with iPad trackpad
# Run tests in integrated terminal
# All VS Code extensions work: Python, Pylance, Black formatter
# Use Cmd+P to open files, Cmd+Shift+P for command palette
```

#### Terminal Development with Neovim (Blink Shell on iPad)

```bash
# SSH from Blink Shell or Termius on iPad
# Full terminal IDE with LazyVim

nvim myfile.rs      # Rust: Full rust-analyzer LSP
nvim server.go      # Go: gopls with auto-imports
nvim app.ts         # TypeScript: Complete type checking
nvim api.py         # Python: pyright LSP

# iPad workflow:
# - Use iPad's hardware keyboard for Vim motions
# - <leader>ff (Space-f-f) → Telescope fuzzy find files
# - <leader>sg (Space-s-g) → Live grep codebase
# - gd → Jump to definition across files
# - K → View documentation
# - Split windows, visual mode, macros all work perfectly
```

#### Docker Development from iPad

```bash
# SSH into your VPS from iPad
# Run full backend infrastructure

# Start PostgreSQL for your app
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=dev postgres

# Connect from iPad using TablePlus or any SQL client
# Your VPS IP:5432

# Full-stack setup with compose
cat > docker-compose.yml << EOF
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: dev
  redis:
    image: redis:alpine
  app:
    build: .
    ports:
      - "8000:8000"
EOF

docker compose up -d
# Monitor logs from iPad terminal
docker compose logs -f app
```

#### Git Workflow from iPad (LazyGit TUI)

```bash
# Beautiful Git interface in Blink Shell/Termius
lazygit

# Navigate with iPad keyboard/trackpad:
# - ↑↓ arrows to select files
# - Space to stage/unstage
# - 'c' to commit (opens editor)
# - 'P' to push
# - Tab to switch panels (Files/Branches/Commits)
# - Visual diff viewer with syntax highlighting
# - Interactive rebase, cherry-pick, stash management

# Traditional git also enhanced with delta:
git status
git diff  # Beautiful side-by-side diffs
git log --oneline --graph  # Pretty branch visualization
```

#### iPad Pro Split View Power Combo

- **Left**: Safari with code-server (VS Code)
- **Right**: Blink Shell with LazyGit or terminal commands
- **Result**: Code on left, git operations on right - seamless workflow

#### Stage Manager Setup (iPad Pro)

- **Main window**: Code-server fullscreen
- **Overlay 1**: Blink Shell for git/docker commands  
- **Overlay 2**: Safari with documentation
- **Overlay 3**: Working Copy app for quick commits

---

## 📁 File Structure

After installation, you'll have:

```plaintext
~/code-server/
├── .env                    # Environment variables
├── PASSWORD.txt           # Your code-server password (KEEP SECURE!)
├── config/               # Code-server configuration
├── projects/             # Your workspace (default)
└── docker-compose.yml    # Docker configuration
```

## 🔧 Usage

### Code-Server Management

**Start code-server:**

```bash
cd ~/code-server
docker compose up -d
```

**Stop code-server:**

```bash
cd ~/code-server
docker compose down
```

**View code-server logs:**

```bash
cd ~/code-server
docker compose logs -f code-server
```

**Restart code-server:**

```bash
cd ~/code-server
docker compose restart
```

**View your password:**

```bash
cat ~/code-server/PASSWORD.txt
```

### Access Code-Server

- **URL:** `https://YOUR_VPS_IP:443`
- **Password:** Located in `~/code-server/PASSWORD.txt`
- **Note:** You'll see a security warning - this is normal with self-signed certificates

### Useful Commands

**LazyGit:**

```bash
lazygit
```

**LazyVim/Neovim:**

```bash
nvim
```

**Check swap status:**

```bash
free -h
swapon --show
```

**Check Docker status:**

```bash
docker ps
docker stats
```

**Firewall status:**

```bash
# On Fedora:
sudo firewall-cmd --list-all

# On Debian:
sudo ufw status
```

## 🔐 Security Notes

1. **Change your password:** The auto-generated password is stored in plaintext. Consider changing it:
   - Edit `~/code-server/.env`
   - Update the `CODESERVER_PASSWORD` value
   - Restart: `docker compose restart`

2. **Self-signed certificate:** The setup uses a self-signed SSL certificate. For production, consider:
   - Using a domain name
   - Getting a Let's Encrypt certificate with Certbot

3. **Firewall:**

   - **Fedora:** Uses firewalld - Only SSH and HTTPS (443) are open
   - **Debian:** Uses UFW - Only ports 22 (SSH) and 443 (HTTPS) are open

4. **SELinux (Fedora):** The script automatically configures SELinux for Docker compatibility

5. **Keep Docker images updated:** Watchtower is included to auto-update containers daily

## 🛠 Customization

### Change Code-Server Port

Edit `docker-compose.yml`:

```yaml
ports:
  - "YOUR_PORT:8443"
```

### Adjust Swap Size

Edit `setup.sh` and modify:

```bash
SWAP_SIZE="4G"  # Change to desired size
```

### Add More Docker Services

Edit `docker-compose.yml` to add additional containers

## 🐛 Troubleshooting

### Code-server won't start

```bash
cd ~/code-server
docker compose logs code-server
```

### Can't access via browser

**On Fedora:**

```bash
# Check firewall
sudo firewall-cmd --list-all

# Check if SELinux is blocking
sudo ausearch -m avc -ts recent

# Temporarily set SELinux to permissive for testing (not recommended for production)
sudo setenforce 0
```

**On Debian:**

```bash
# Check firewall
sudo ufw status
```

**Both systems:**

```bash
# Check Docker
docker ps

# Check if port is listening
sudo ss -tlnp | grep 443
```

### Forgot password

```bash
cat ~/code-server/PASSWORD.txt
```

### Docker permission denied

```bash
# Logout and login again, or run:
newgrp docker
```

### Neovim plugins not loading

```bash
nvim
# Then type: :Lazy sync
```

## 📚 Additional Resources

- 📖 **[Documentation Folder](docs/)** - Detailed guides, checklists, and troubleshooting
- [Code-Server Documentation](https://coder.com/docs/code-server)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [LazyGit Documentation](https://github.com/jesseduffield/lazygit)
- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh Documentation](https://ohmyz.sh/)

## ⚠️ Important Notes

1. **Backup your PASSWORD.txt file** - You'll need it to access code-server
2. **The first Neovim launch** will take time as it installs plugins
3. **Docker socket is mounted** - This allows using Docker inside code-server
4. **Automatic updates** are enabled via Watchtower for security
5. **Fedora SELinux:** The script configures SELinux automatically. Volume mounts use `:Z` flag for proper labeling
6. **No GUI needed:** Everything runs headless - access via browser only

## 🔄 Uninstall

To remove everything:

```bash
# Stop and remove code-server
cd ~/code-server
docker compose down -v
cd ~
rm -rf ~/code-server

# Remove Docker (optional)
sudo apt remove --purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apt/sources.list.d/docker.list
sudo rm /usr/share/keyrings/docker-archive-keyring.gpg

# Remove swap
sudo swapoff /swapfile
sudo rm /swapfile
# Remove swap entry from /etc/fstab manually

# Remove other tools as needed
```

## 📝 License

This setup script is provided as-is for personal use.

---

Enjoy your fully-configured development VPS! 🎉
