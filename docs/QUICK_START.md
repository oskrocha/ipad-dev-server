# VPS Setup - Quick Reference

## 🎯 Recommendation: **Fedora 42** ✅

**Why Fedora 42 over Debian?**
- ✅ **Modern packages** - Latest versions of all tools
- ✅ **Better Docker support** - Optimized for containers
- ✅ **SELinux security** - Enterprise-grade security out of the box
- ✅ **Faster package manager** - dnf is more efficient than apt
- ✅ **Your preference** - You mentioned preferring Fedora!

**Why NOT install GNOME?**
- ❌ Uses 500MB-1GB+ RAM
- ❌ Unnecessary for server (code-server gives you web-based IDE)
- ❌ Larger attack surface
- ❌ More packages to update
- ✅ **Keep it minimal** - Maximum performance for Docker

---

## 📦 What Gets Installed

### Core Features
1. **Code-Server** (VS Code in browser)
   - Access via HTTPS on port 443
   - Password-protected
   - Self-signed SSL certificate
   - Nginx reverse proxy for security

2. **4GB Virtual Memory** (swap)
   - Optimized settings for performance
   - Persists across reboots

3. **Developer Shell**
   - Zsh with Oh My Zsh
   - Powerlevel10k theme (beautiful UI)
   - Syntax highlighting
   - Auto-suggestions

4. **Git Tools**
   - LazyGit (terminal UI for Git)
   - Full Git integration

5. **Editor**
   - Neovim with LazyVim
   - Modern Vim distribution
   - LSP support, treesitter, etc.

### Bonus Tools
- Docker & Docker Compose
- bat (better cat)
- exa (better ls)  
- fzf (fuzzy finder)
- ncdu (disk usage)
- tldr (simplified man pages)
- htop, tmux, and more

### Security
- Firewall configured (firewalld on Fedora, ufw on Debian)
- SELinux pre-configured (Fedora)
- Auto-updates via Watchtower
- HTTPS only
- Rate limiting in Nginx

---

## 🚀 Installation (3 Steps)

### Step 1: Upload Files
```bash
scp setup.sh docker-compose.yml nginx.conf user@your-vps-ip:~/
```

### Step 2: Run Setup
```bash
ssh user@your-vps-ip
chmod +x setup.sh
./setup.sh
```
⏱️ Takes 5-10 minutes

### Step 3: Start Code-Server
```bash
# After logging back in:
cd ~/code-server
docker compose up -d
```

**Access:** `https://YOUR_VPS_IP:443`
**Password:** `cat ~/code-server/PASSWORD.txt`

---

## 📋 Files Overview

| File | Purpose |
|------|---------|
| `setup.sh` | Main installation script |
| `docker-compose.yml` | Code-server container config |
| `nginx.conf` | Reverse proxy with security |
| `README.md` | Full documentation |
| `CHECKLIST.md` | Pre-installation guide |
| `DISTRO_GUIDE.md` | Fedora vs Debian differences |
| `verify.sh` | Verify files before upload |

---

## 🔧 Key Script Features

### Auto-Detection
The script automatically detects:
- ✅ Fedora vs Debian
- ✅ Uses correct package manager (dnf/apt)
- ✅ Configures correct firewall (firewalld/ufw)
- ✅ Handles SELinux on Fedora
- ✅ Adapts paths and commands

### Idempotent
Safe to run multiple times:
- ✅ Checks if tools already installed
- ✅ Won't duplicate configurations
- ✅ Updates instead of reinstalling

### Error Handling
- ✅ Checks for sudo privileges
- ✅ Colored output (green=success, red=error)
- ✅ Stops on critical errors
- ✅ Provides helpful messages

---

## 🎨 What Your Terminal Will Look Like

After installation, you get:
```
┌─[user@server]─[~/projects]
└──╼ $ git status
```
With:
- Git branch indicator
- Command suggestions as you type
- Syntax highlighting
- Beautiful Unicode glyphs
- Current directory info
- Exit code indicators

---

## 🔐 Security Considerations

### Automatic
✅ Firewall enabled
✅ Only necessary ports open (22, 443)
✅ SELinux configured (Fedora)
✅ Self-signed SSL
✅ Password protection
✅ Rate limiting
✅ Security headers

### Recommended (Manual)
- Change SSH port
- Set up SSH key auth (disable password)
- Install fail2ban
- Enable automatic security updates
- Change code-server password
- Consider Let's Encrypt (requires domain)

---

## 📊 Resource Usage

### Expected RAM Usage
- **Base Fedora (no GUI):** ~300-500MB
- **Docker:** ~200-300MB
- **Code-server container:** ~500-800MB
- **Nginx:** ~10-20MB
- **Total:** ~1-1.5GB

### With 2GB VPS
- ✅ Enough for development
- ✅ Swap provides buffer
- ⚠️ Don't run heavy builds

### With 4GB+ VPS
- ✅ Comfortable for most tasks
- ✅ Can run multiple containers
- ✅ Build medium projects

---

## ⚡ Quick Commands Reference

### Code-Server
```bash
cd ~/code-server
docker compose up -d      # Start
docker compose down       # Stop
docker compose restart    # Restart
docker compose logs -f    # View logs
cat PASSWORD.txt          # Get password
```

### System
```bash
htop                      # Monitor resources
free -h                   # Check RAM/swap
df -h                     # Check disk
docker ps                 # List containers
docker stats              # Container stats
```

### Firewall (Fedora)
```bash
sudo firewall-cmd --list-all              # Show rules
sudo firewall-cmd --add-port=8080/tcp     # Add port
sudo firewall-cmd --reload                # Reload
```

### Firewall (Debian)
```bash
sudo ufw status          # Show rules
sudo ufw allow 8080/tcp  # Add port
```

### SELinux (Fedora)
```bash
sestatus                 # Check status
sudo ausearch -m avc     # Check denials
```

---

## 🆘 Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Can't access code-server | Check firewall, verify container running |
| Docker permission denied | Logout/login or `newgrp docker` |
| SELinux blocking (Fedora) | Check `ausearch -m avc -ts recent` |
| Forgot password | `cat ~/code-server/PASSWORD.txt` |
| Out of memory | Check `free -h`, restart containers |
| Can't install package | Update: `sudo dnf upgrade --refresh` |

---

## 📞 Support & Resources

### Included Documentation
- **README.md** - Complete guide with all details
- **CHECKLIST.md** - Pre/post installation steps
- **DISTRO_GUIDE.md** - OS-specific commands

### Project Documentation
- [Code-Server Docs](https://coder.com/docs/code-server)
- [LazyVim Guide](https://www.lazyvim.org/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Docker Docs](https://docs.docker.com/)

### Logs to Check
```bash
# Code-server logs
docker compose logs -f code-server

# System logs
sudo journalctl -xe

# Docker daemon logs
sudo journalctl -u docker

# SELinux denials (Fedora)
sudo ausearch -m avc -ts recent
```

---

## ✅ Verification Checklist

After installation, verify:
- [ ] Can access code-server at `https://IP:443`
- [ ] Password works
- [ ] Can create/edit files in workspace
- [ ] LazyGit runs: `lazygit`
- [ ] Neovim works: `nvim`
- [ ] Docker accessible: `docker ps`
- [ ] Swap enabled: `swapon --show`
- [ ] Firewall active (Fedora: `firewall-cmd --state`)
- [ ] Shell is zsh: `echo $SHELL`
- [ ] Powerlevel10k configured: `p10k configure`

---

## 🎉 You're All Set!

Your VPS is now a fully-featured development environment accessible from any browser!

**Next Steps:**
1. Configure Powerlevel10k theme: `p10k configure`
2. Customize code-server settings
3. Install your favorite VS Code extensions
4. Clone your projects
5. Start coding!

**Tips:**
- Use tmux for persistent sessions
- Leverage LazyGit for quick Git operations
- Use fzf (Ctrl+R) for command history search
- Explore LazyVim plugins
- Keep Docker images updated with Watchtower

---

**Enjoy your new development server! 🚀**
