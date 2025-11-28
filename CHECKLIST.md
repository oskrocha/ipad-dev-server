# Pre-Installation Checklist

Use this checklist before running the setup script on your VPS.

## ✅ VPS Requirements

- [ ] **OS:** Fedora 42, Debian 12, or Debian 13 installed
- [ ] **RAM:** At least 2GB (4GB+ recommended)
- [ ] **Disk:** At least 20GB free space
- [ ] **User:** Non-root user with sudo privileges
- [ ] **SSH:** Can connect via SSH
- [ ] **Internet:** VPS has outbound internet access

## ✅ Pre-Installation Steps

### 1. Create Non-Root User (if needed)

```bash
# On VPS as root:
adduser youruser
usermod -aG sudo youruser  # Debian
usermod -aG wheel youruser  # Fedora

# Test sudo access:
su - youruser
sudo whoami  # Should output: root
```

### 2. Update System

**Fedora:**
```bash
sudo dnf upgrade --refresh -y
sudo reboot  # If kernel was updated
```

**Debian:**
```bash
sudo apt update && sudo apt upgrade -y
sudo reboot  # If kernel was updated
```

### 3. Set Hostname (Optional)

```bash
sudo hostnamectl set-hostname your-server-name
```

### 4. Configure SSH (Recommended)

```bash
# Backup SSH config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit config
sudo nano /etc/ssh/sshd_config

# Recommended settings:
# PermitRootLogin no
# PasswordAuthentication no  # If using SSH keys
# Port 22  # Or change to custom port

# Restart SSH
sudo systemctl restart sshd
```

### 5. Upload Setup Files

From your local machine:
```bash
scp setup.sh docker-compose.yml nginx.conf user@vps-ip:~/
```

## ✅ During Installation

The script will:
- [ ] Detect your OS automatically
- [ ] Update all packages
- [ ] Install Docker and Docker Compose
- [ ] Configure 4GB swap file
- [ ] Install Zsh, Oh My Zsh, and Powerlevel10k
- [ ] Install LazyGit and LazyVim
- [ ] Generate SSL certificates
- [ ] Configure firewall
- [ ] (Fedora) Configure SELinux for Docker

Expected duration: **5-10 minutes**

## ✅ Post-Installation

### Immediate Steps

1. **Logout and login** to apply group changes:
   ```bash
   exit
   ssh user@vps-ip
   ```

2. **Configure Powerlevel10k** (first time):
   ```bash
   p10k configure
   ```

3. **Start code-server**:
   ```bash
   cd ~/code-server
   docker compose up -d
   ```

4. **Get your password**:
   ```bash
   cat ~/code-server/PASSWORD.txt
   ```

5. **Test access**:
   - Open: `https://YOUR_VPS_IP:443`
   - Accept security warning (self-signed cert)
   - Enter password from step 4

### Verify Installation

```bash
# Check Docker
docker ps
# Should show: code-server, nginx, watchtower

# Check firewall (Fedora)
sudo firewall-cmd --list-all

# Check firewall (Debian)
sudo ufw status

# Check swap
free -h
swapon --show

# Check disk space
df -h

# Test Neovim
nvim --version

# Test LazyGit
lazygit --version

# Check code-server logs
cd ~/code-server
docker compose logs code-server
```

## 🔒 Security Hardening (Optional but Recommended)

### 1. Change SSH Port (Optional)

```bash
sudo nano /etc/ssh/sshd_config
# Change: Port 22  ->  Port 2222

sudo systemctl restart sshd

# Update firewall (Fedora)
sudo firewall-cmd --permanent --add-port=2222/tcp
sudo firewall-cmd --permanent --remove-service=ssh
sudo firewall-cmd --reload

# Update firewall (Debian)
sudo ufw allow 2222/tcp
sudo ufw delete allow ssh
```

### 2. Fail2Ban Installation

**Fedora:**
```bash
sudo dnf install -y fail2ban
sudo systemctl enable --now fail2ban
```

**Debian:**
```bash
sudo apt install -y fail2ban
sudo systemctl enable --now fail2ban
```

### 3. Automatic Security Updates

**Fedora:**
```bash
sudo dnf install -y dnf-automatic
sudo systemctl enable --now dnf-automatic.timer
```

**Debian:**
```bash
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

### 4. Change Code-Server Password

```bash
cd ~/code-server
nano .env
# Change CODESERVER_PASSWORD value
docker compose restart
```

## 📊 Resource Monitoring

### Check System Resources

```bash
# CPU and memory usage
htop

# Disk usage
ncdu /

# Docker container stats
docker stats

# Active connections
sudo ss -tunap
```

### Set Up Monitoring Alerts (Optional)

Consider installing:
- **Netdata** - Real-time monitoring dashboard
- **Prometheus + Grafana** - Metrics and alerting
- **Uptime Kuma** - Uptime monitoring

## 🛠️ Common Issues

| Issue | Solution |
|-------|----------|
| Script fails with "Permission denied" | Ensure user has sudo privileges |
| Docker won't start | Check `journalctl -u docker` for errors |
| Can't access code-server | Check firewall rules and container status |
| SELinux blocking (Fedora) | Check `ausearch -m avc -ts recent` |
| Out of disk space | Clean Docker: `docker system prune -a` |

## 📝 Backup Strategy

**Important files to backup:**
```bash
# Code-server data
~/code-server/

# SSH keys
~/.ssh/

# Zsh config
~/.zshrc
~/.p10k.zsh

# Neovim config
~/.config/nvim/
```

**Backup command:**
```bash
tar -czf vps-backup-$(date +%Y%m%d).tar.gz \
  ~/code-server \
  ~/.ssh \
  ~/.zshrc \
  ~/.p10k.zsh \
  ~/.config/nvim
```

## 🎯 Ready to Install?

Once you've completed the checklist:

```bash
cd ~
chmod +x setup.sh
./setup.sh
```

Watch for any errors during installation. The script will output colored messages:
- 🟢 Green = Success
- 🟡 Yellow = Information
- 🔴 Red = Error

Save the output to review later:
```bash
./setup.sh 2>&1 | tee setup-log.txt
```

---

**Need help?** Check:
- `README.md` - Full documentation
- `DISTRO_GUIDE.md` - Distribution-specific tips
- Docker logs: `docker compose logs -f`
- System logs: `sudo journalctl -xe`
