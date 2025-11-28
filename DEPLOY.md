# 🚀 Quick Deployment Guide

## Option 1: Automated Deployment (Easiest)

Run the deployment script from your local machine:

```bash
cd /Users/oscar/Developer/vps
./deploy.sh
```

The script will:
1. Ask for your VPS IP and username
2. Upload all files via SCP
3. Run the setup automatically
4. Start code-server
5. Show you the password and URL

⏱️ **Total time: 5-10 minutes**

---

## Option 2: Manual Deployment (Step-by-Step)

### Step 1: Upload Files to VPS

From your local machine:

```bash
cd /Users/oscar/Developer/vps

# Replace with your VPS details
scp setup.sh docker-compose.yml nginx.conf user@YOUR_VPS_IP:~/
```

### Step 2: SSH into VPS

```bash
ssh user@YOUR_VPS_IP
```

### Step 3: Run Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

⏱️ **Wait 5-10 minutes for installation**

### Step 4: Logout and Login (Apply Changes)

```bash
exit
ssh user@YOUR_VPS_IP
```

### Step 5: Configure Powerlevel10k (Optional)

```bash
p10k configure
```

Follow the interactive prompts to customize your theme.

### Step 6: Start Code-Server

```bash
cd ~/code-server
docker compose up -d
```

### Step 7: Get Your Password

```bash
cat ~/code-server/PASSWORD.txt
```

### Step 8: Access Code-Server

1. Open browser: `https://YOUR_VPS_IP:443`
2. Accept security warning (self-signed certificate)
3. Enter password from Step 7
4. Start coding! 🎉

---

## 🔧 Post-Deployment

### Configure Your Local Terminal Font

For Powerlevel10k to display properly over SSH:

**Download MesloLGS NF font:**
- Direct: https://github.com/romkatv/powerlevel10k#fonts

**Install on your computer:**

**macOS:**
1. Download all 4 font files
2. Double-click each → Click "Install Font"
3. Terminal.app: Preferences → Profiles → Font → "MesloLGS NF"
4. iTerm2: Preferences → Profiles → Text → Font → "MesloLGS NF"

**Windows:**
1. Download all 4 font files
2. Right-click each → "Install"
3. Windows Terminal: Settings → Profiles → Font face → "MesloLGS NF"

**Linux:**
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv
```

---

## 🔍 Verify Installation

SSH into your VPS and run:

```bash
# Check all installations
echo "=== Docker ==="
docker --version
docker compose version

echo -e "\n=== Languages ==="
python3 --version
node --version
go version
cargo --version

echo -e "\n=== Tools ==="
nvim --version | head -1
lazygit --version
bat --version
delta --version

echo -e "\n=== Code-Server ==="
docker ps

echo -e "\n=== Swap ==="
free -h
swapon --show

echo -e "\n=== Firewall ==="
sudo firewall-cmd --list-all  # Fedora
# OR
sudo ufw status               # Debian
```

---

## 📊 Manage Code-Server

### Start
```bash
cd ~/code-server
docker compose up -d
```

### Stop
```bash
cd ~/code-server
docker compose down
```

### Restart
```bash
cd ~/code-server
docker compose restart
```

### View Logs
```bash
cd ~/code-server
docker compose logs -f code-server
```

### Change Password
```bash
cd ~/code-server
nano .env
# Edit CODESERVER_PASSWORD
docker compose restart
```

---

## 🆘 Troubleshooting

### Can't Connect to VPS
```bash
# Test connection
ping YOUR_VPS_IP

# Verify SSH port
ssh -v user@YOUR_VPS_IP
```

### Can't Access Code-Server

**Check if running:**
```bash
docker ps
```

**Check firewall (Fedora):**
```bash
sudo firewall-cmd --list-all
# Should show port 443/tcp
```

**Check firewall (Debian):**
```bash
sudo ufw status
# Should show 443/tcp ALLOW
```

**Check logs:**
```bash
cd ~/code-server
docker compose logs code-server
```

### SELinux Issues (Fedora)
```bash
# Check for denials
sudo ausearch -m avc -ts recent

# Temporarily disable (testing only)
sudo setenforce 0

# Re-enable
sudo setenforce 1
```

### Forgot Password
```bash
cat ~/code-server/PASSWORD.txt
```

### Out of Disk Space
```bash
# Check usage
df -h

# Clean Docker
docker system prune -a
```

---

## 🔄 Updates

### Update System
**Fedora:**
```bash
sudo dnf upgrade --refresh
```

**Debian:**
```bash
sudo apt update && sudo apt upgrade
```

### Update Docker Containers
Watchtower automatically updates daily, or manually:
```bash
cd ~/code-server
docker compose pull
docker compose up -d
```

---

## 🗑️ Uninstall

```bash
# Stop and remove code-server
cd ~/code-server
docker compose down -v
cd ~
rm -rf ~/code-server

# Remove Docker (optional)
sudo systemctl stop docker
# Fedora:
sudo dnf remove docker-ce docker-ce-cli containerd.io
# Debian:
sudo apt remove docker-ce docker-ce-cli containerd.io

# Remove swap
sudo swapoff /swapfile
sudo rm /swapfile
sudo sed -i '/\/swapfile/d' /etc/fstab
```

---

## 📚 Additional Resources

- **Full Guide:** [README.md](README.md)
- **Checklist:** [CHECKLIST.md](CHECKLIST.md)
- **Distro Comparison:** [DISTRO_GUIDE.md](DISTRO_GUIDE.md)
- **Quick Reference:** [QUICK_START.md](QUICK_START.md)

---

## 🎯 Quick Commands Cheatsheet

```bash
# Code-server
cd ~/code-server && docker compose up -d      # Start
cd ~/code-server && docker compose down       # Stop
cat ~/code-server/PASSWORD.txt                # Get password

# System monitoring
htop                                          # CPU/RAM
btop                                          # Better htop
docker stats                                  # Container resources
df -h                                         # Disk space
free -h                                       # RAM/Swap

# Useful aliases (after setup)
ll                                            # Better ls
lg                                            # LazyGit
v                                             # Neovim
dc ps                                         # Docker compose ps
weather                                       # Check weather
myip                                          # Show public IP
```

---

**Ready to deploy? Run `./deploy.sh` and you're good to go! 🚀**
