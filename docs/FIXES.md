# Fixes Applied Based on Deployment Issues

## Issues Encountered and Solutions

### 1. **Docker Compose Version Warning**
**Issue**: `version: '3.8'` in docker-compose.yml is obsolete
**Solution**: Removed the `version` field from docker-compose.yml

### 2. **Code-server Container Crash Loop**
**Issue**: Container kept restarting with exit code 100 and error `s6-overlay-suexec: fatal: can only run as pid 1`
**Root Cause**: The `command` override in docker-compose.yml was wrapping `/init` in a bash script, preventing it from running as PID 1
**Solution**: Removed the `command` override entirely - the linuxserver/code-server image already has all necessary tools

### 3. **Nginx Container Failing to Start**
**Issue**: Multiple nginx startup failures due to configuration errors

#### 3a. Missing nginx.conf File
**Issue**: nginx.conf was created as a directory by Docker instead of a file
**Solution**: 
- Added logic to setup.sh to move uploaded nginx.conf from home directory to code-server directory
- deploy.sh already uploads nginx.conf correctly

#### 3b. Upstream Port Configuration Error
**Issue**: Error `upstream "code-server" may not have port 8443` 
**Root Cause**: Nginx upstream blocks cannot specify ports in both the upstream definition AND the proxy_pass URL
**Solution**: Removed the upstream block and directly proxy to `http://code-server:8443`

#### 3c. Wrong Protocol in Proxy Pass
**Issue**: Nginx trying to connect to code-server via HTTPS when it only serves HTTP
**Root Cause**: nginx.conf had `proxy_pass https://code-server` but code-server logs showed `Not serving HTTPS`
**Solution**: Changed `proxy_pass` to use `http://code-server:8443` instead of `https://code-server`

### 4. **Network Configuration**
**Issue**: Better container networking for reliability
**Solution**: Explicitly added `networks: - default` to nginx service in docker-compose.yml

## Files Updated

### docker-compose.yml
- ✅ Removed obsolete `version: '3.8'`
- ✅ Removed problematic `command` override from code-server service
- ✅ Added explicit network configuration to nginx service

### nginx.conf
- ✅ Removed upstream block with port specification
- ✅ Changed `proxy_pass` from `https://code-server` to `http://code-server:8443`
- ✅ Changed `Host` header from `$host` to `$http_host` for better compatibility

### setup.sh
- ✅ Added logic to move docker-compose.yml and nginx.conf from home directory to code-server directory
- ✅ This ensures files uploaded by deploy.sh end up in the correct location

### deploy.sh
- ✅ Already correctly uploads nginx.conf (no changes needed)

## Testing Checklist

After deploying, verify:

```bash
# 1. Check all containers are running (not restarting)
docker ps
# Should show: code-server (Up), nginx (Up), watchtower (Up or Restarting with API error - safe to ignore)

# 2. Verify port 443 is listening
sudo ss -tlnp | grep 443
# Should show docker-proxy listening on 0.0.0.0:443 and [::]:443

# 3. Check nginx logs for errors
docker logs code-server-nginx --tail 20
# Should NOT show "upstream may not have port" or connection errors

# 4. Check code-server is serving HTTP
docker logs code-server --tail 20
# Should show "Not serving HTTPS" and "HTTP server listening on http://0.0.0.0:8443/"

# 5. Test browser access
# Open https://YOUR_VPS_IP
# Should show code-server login page (accept self-signed certificate warning)
```

## Deployment Command

From your local machine in the `/vps` directory:

```bash
# Full automated deployment
./deploy.sh

# Or manual deployment
scp docker-compose.yml nginx.conf setup.sh fedora@YOUR_VPS_IP:~/
ssh fedora@YOUR_VPS_IP
chmod +x setup.sh
./setup.sh
cd ~/code-server
docker compose up -d
```

## Known Issues (Non-Critical)

### Watchtower API Version Error
**Issue**: Watchtower shows `client version 1.25 is too old. Minimum supported API version is 1.44`
**Impact**: Watchtower keeps restarting but this doesn't affect code-server functionality
**Solution**: This is a watchtower bug with newer Docker versions. Can be safely ignored or watchtower can be removed from docker-compose.yml if auto-updates aren't needed.

**To disable watchtower**: Comment out or remove the watchtower service from docker-compose.yml

### Deprecated http2 Directive Warning
**Issue**: `the "listen ... http2" directive is deprecated`
**Impact**: Non-critical warning, nginx still works correctly
**Solution**: Modern nginx versions want `http2 on;` as a separate directive. Can be updated in future nginx.conf versions.
