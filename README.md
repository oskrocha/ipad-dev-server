```
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   ██╗██████╗  █████╗ ██████╗     ██████╗ ███████╗██╗   ██╗  ║
║   ██║██╔══██╗██╔══██╗██╔══██╗    ██╔══██╗██╔════╝██║   ██║  ║
║   ██║██████╔╝███████║██║  ██║    ██║  ██║█████╗  ██║   ██║  ║
║   ██║██╔═══╝ ██╔══██║██║  ██║    ██║  ██║██╔══╝  ╚██╗ ██╔╝  ║
║   ██║██║     ██║  ██║██████╔╝    ██████╔╝███████╗ ╚████╔╝   ║
║   ╚═╝╚═╝     ╚═╝  ╚═╝╚═════╝     ╚═════╝ ╚══════╝  ╚═══╝    ║
║                                                               ║
║             ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ ║
║             ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗║
║             ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝║
║             ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗║
║             ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║║
║             ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

# iPad Dev Server

> 🚀 Transform any VPS into a complete development environment in 10 minutes.  
> Perfect for **iPad users** who need full VS Code, Docker, and modern dev tools anywhere.

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

### Perfect For:
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

### Option 1: Automated Deployment (Easiest) ⭐

**One command does everything!**

```bash
cd /path/to/ipad-dev-server
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

**Safari (Recommended)**
- Open Safari → Navigate to `https://YOUR_VPS_IP:443`
- Add to Home Screen for app-like experience
- Use in fullscreen mode
- Works perfectly with iPad keyboard shortcuts

**Split View Tips**
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

### Real Development Workflows

**Python with uv (10-100x faster than pip)**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv init my-fastapi-app && cd my-fastapi-app
uv add fastapi uvicorn httpx
uv run uvicorn main:app --reload --host 0.0.0.0
```

**Node.js Full-Stack**
```bash
npm create vite@latest my-app -- --template react-ts
cd my-app && npm install && npm run dev
# Access at https://your-vps-ip:5173
```

**Docker Multi-Service**
```bash
# PostgreSQL + Redis + Your App
docker compose up -d
# Monitor logs in code-server terminal
# Connect from TablePlus on iPad
```

**Go Microservices**
```bash
go mod init github.com/you/project
go install github.com/cosmtrek/air@latest
air  # Hot reload!
```

**Rust Systems Programming**
```bash
cargo new my-app && cd my-app
cargo run
# Full rust-analyzer support in code-server
```

---

## 📁 File Structure

After installation, you'll have:

```
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

4. **Keep Docker images updated:** Watchtower is included to auto-update containers daily

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

**Enjoy your fully-configured development VPS! 🎉**
