# Quick Distro Reference

This setup script automatically detects and supports:

## Supported Distributions

| Distribution | Status | Notes |
|--------------|--------|-------|
| **Fedora 42** | ✅ **Recommended** | Latest packages, modern tooling, SELinux pre-configured |
| Debian 12 | ✅ Fully Supported | Stable, well-tested |
| Debian 13 | ✅ Fully Supported | Testing branch, newer packages |

## Key Differences

### Package Manager
- **Fedora:** `dnf` (used automatically)
- **Debian:** `apt` (used automatically)

### Firewall
- **Fedora:** `firewalld`
  ```bash
  sudo firewall-cmd --list-all
  sudo firewall-cmd --add-port=8080/tcp --permanent
  sudo firewall-cmd --reload
  ```
- **Debian:** `ufw`
  ```bash
  sudo ufw status
  sudo ufw allow 8080/tcp
  ```

### SELinux
- **Fedora:** Enabled by default (script configures it)
  ```bash
  # Check status
  sestatus
  
  # View denials
  sudo ausearch -m avc -ts recent
  
  # Temporarily disable (testing only)
  sudo setenforce 0
  
  # Re-enable
  sudo setenforce 1
  ```
- **Debian:** Not used (AppArmor may be present)

### Service Management
Both use `systemctl`:
```bash
sudo systemctl status docker
sudo systemctl restart docker
```

### Docker Volume Mounts
- **Fedora:** Uses `:Z` flag for SELinux context
  ```yaml
  volumes:
    - ./data:/data:Z
  ```
- **Debian:** Standard mounts
  ```yaml
  volumes:
    - ./data:/data
  ```

## Installation Recommendations

### For Fedora 42 (Recommended)
- ✅ Most modern packages
- ✅ SELinux provides extra security
- ✅ Better container support out of the box
- ✅ Faster package manager (dnf)
- ⚠️ Slightly higher RAM usage (~100-200MB more)

### For Debian 12/13
- ✅ Rock solid stability
- ✅ Lower resource usage
- ✅ Longer support cycles
- ✅ More familiar to many users

## Why No GNOME/Desktop?

For a VPS development server, **skip installing any GUI**:

### Reasons:
1. **Resource Usage:** GNOME uses 500MB-1GB+ RAM
2. **Security:** Smaller attack surface without GUI
3. **Not Needed:** Code-server provides web-based IDE
4. **Performance:** More resources for Docker containers
5. **Updates:** Fewer packages to maintain

### What You Get Instead:
- 🌐 **Code-server** - Full VS Code in browser
- 🖥️ **SSH** - Terminal access
- 📊 **htop/tmux** - Terminal-based monitoring
- 🎨 **Powerlevel10k** - Beautiful terminal UI

## Post-Installation Tips

### Fedora Specific
```bash
# Update system
sudo dnf upgrade --refresh

# Check SELinux denials after starting code-server
sudo ausearch -m avc -ts recent | grep denied

# If needed, generate SELinux policy
sudo ausearch -m avc -ts recent | audit2allow -M mycodepolicy
sudo semodule -i mycodepolicy.pp
```

### Debian Specific
```bash
# Update system
sudo apt update && sudo apt upgrade

# Check for security updates
sudo apt list --upgradable
```

### Both Systems
```bash
# Check Docker logs
docker compose logs -f

# Monitor system resources
htop

# Check open ports
sudo ss -tlnp

# Test code-server locally
curl -k https://localhost:443
```

## Migrating Between Distros

Your code-server data is portable:

1. **Backup:**
   ```bash
   tar -czf codeserver-backup.tar.gz ~/code-server
   ```

2. **Transfer to new VPS:**
   ```bash
   scp codeserver-backup.tar.gz user@new-vps:~/
   ```

3. **Run setup script on new VPS**

4. **Restore data:**
   ```bash
   cd ~
   tar -xzf codeserver-backup.tar.gz
   cd code-server
   docker compose up -d
   ```

## Troubleshooting by Distro

### Fedora: "Permission Denied" in Containers
```bash
# Check SELinux context
ls -Z ~/code-server

# Fix if needed
sudo chcon -R -t container_file_t ~/code-server
```

### Fedora: Firewall Blocking Connections
```bash
# Verify rules
sudo firewall-cmd --list-all

# Add rule if needed
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
```

### Debian: Docker Not Starting
```bash
# Check service
sudo systemctl status docker

# Check logs
sudo journalctl -u docker -n 50
```

### Both: Code-Server Container Won't Start
```bash
# Check permissions
ls -la ~/code-server

# Check Docker socket
ls -la /var/run/docker.sock

# Verify user in docker group
groups $USER
```

---

**Summary:** Fedora 42 is recommended for the best development experience with modern packages and built-in container security. The script handles all differences automatically.
