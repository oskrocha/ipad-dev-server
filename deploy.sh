#!/bin/bash
# VPS Deployment Guide
# Run this script locally to deploy to your VPS

set -e

echo "🚀 VPS Setup Deployment Script"
echo "================================"
echo ""

# Check if files exist
if [ ! -f "setup.sh" ] || [ ! -f "docker-compose.yml" ] || [ ! -f "nginx.conf" ]; then
    echo "❌ Error: Required files not found!"
    echo "   Make sure you're running this from the /vps directory"
    exit 1
fi

# Get VPS details from user
read -p "Enter your VPS IP address: " VPS_IP
read -p "Enter your VPS username (default: root): " VPS_USER
VPS_USER=${VPS_USER:-root}

echo ""
echo "📤 Deploying to: $VPS_USER@$VPS_IP"
echo ""

# Check if host key has changed
echo "🔍 Checking SSH connection..."
if ! ssh-keygen -F "$VPS_IP" >/dev/null 2>&1; then
    echo "   No previous host key found (first time connecting)"
elif ssh -o StrictHostKeyChecking=yes -o ConnectTimeout=5 "$VPS_USER@$VPS_IP" exit 2>/dev/null; then
    echo "   ✅ Host key verified"
else
    if grep -q "$VPS_IP" ~/.ssh/known_hosts 2>/dev/null; then
        echo ""
        echo "⚠️  WARNING: Host key has changed for $VPS_IP"
        echo "   This could be because:"
        echo "   - VPS was reinstalled/rebuilt"
        echo "   - First time using this VPS"
        echo "   - Security issue (rare)"
        echo ""
        read -p "Do you want to remove the old key and continue? (yes/no): " CONFIRM
        
        if [ "$CONFIRM" = "yes" ]; then
            echo "🔧 Removing old host key..."
            ssh-keygen -R "$VPS_IP" 2>/dev/null || true
            echo "✅ Old key removed. Will add new key on connection."
        else
            echo "❌ Deployment cancelled for security."
            exit 1
        fi
    fi
fi

# Upload files
echo ""
echo "1️⃣  Uploading setup files..."

# First, check if password needs to be changed
echo "   Checking SSH access..."
if ! ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 "$VPS_USER@$VPS_IP" "echo 'SSH test successful'" 2>&1 | grep -q "successful"; then
    echo ""
    echo "⚠️  Cannot establish SSH connection."
    echo ""
    echo "🔍 Common issues detected:"
    
    if ssh -o StrictHostKeyChecking=accept-new "$VPS_USER@$VPS_IP" "exit" 2>&1 | grep -q "change your password"; then
        echo ""
        echo "❗ PASSWORD CHANGE REQUIRED"
        echo "   Your VPS requires an immediate password change."
        echo ""
        echo "📝 Steps to fix:"
        echo "   1. SSH into your VPS manually:"
        echo "      ssh $VPS_USER@$VPS_IP"
        echo ""
        echo "   2. You'll be prompted to change your password"
        echo "   3. Set a new password"
        echo "   4. Exit and run this script again"
        echo ""
        exit 1
    fi
    
    echo "1. Verify VPS IP is correct: $VPS_IP"
    echo "2. Try manual SSH: ssh $VPS_USER@$VPS_IP"
    echo "3. Verify username is correct: $VPS_USER"
    echo "4. Check if SSH key is set up or password access"
    echo ""
    exit 1
fi

scp -o StrictHostKeyChecking=accept-new setup.sh docker-compose.yml nginx.conf "$VPS_USER@$VPS_IP:~/" || {
    echo ""
    echo "❌ Failed to upload files."
    echo ""
    echo "Possible solutions:"
    echo "1. Verify VPS IP is correct: $VPS_IP"
    echo "2. Check SSH access: ssh $VPS_USER@$VPS_IP"
    echo "3. Verify username is correct: $VPS_USER"
    echo "4. Check if SSH key is set up (or use password)"
    echo ""
    exit 1
}

echo "✅ Files uploaded successfully!"
echo ""

# SSH and run setup
echo "2️⃣  Connecting to VPS and starting installation..."
echo "   This will take 5-10 minutes..."
echo ""

ssh -o StrictHostKeyChecking=accept-new -t "$VPS_USER@$VPS_IP" << 'ENDSSH'
    set -e
    
    echo "🔧 Making setup script executable..."
    chmod +x setup.sh
    
    echo "🚀 Running setup script..."
    ./setup.sh
    
    echo ""
    echo "✅ Setup complete! You'll be logged out to apply changes."
    echo ""
ENDSSH

echo ""
echo "3️⃣  Reconnecting and starting code-server..."

ssh -o StrictHostKeyChecking=accept-new -t "$VPS_USER@$VPS_IP" << 'ENDSSH'
    # Run p10k configure in background (user can do it later)
    echo "⚙️  Configuring Zsh theme..."
    
    # Start code-server
    echo "🐳 Starting code-server..."
    cd ~/code-server
    docker compose up -d
    
    echo ""
    echo "✅ Code-server started!"
    echo ""
    
    # Show password
    echo "🔑 Your code-server password:"
    cat ~/code-server/PASSWORD.txt
    echo ""
    
    # Get IP
    SERVER_IP=$(hostname -I | awk '{print $1}')
    
    echo "================================"
    echo "🎉 DEPLOYMENT COMPLETE!"
    echo "================================"
    echo ""
    echo "📍 Access code-server at:"
    echo "   https://$SERVER_IP:443"
    echo ""
    echo "🔑 Password: (shown above)"
    echo "   Also saved in: ~/code-server/PASSWORD.txt"
    echo ""
    echo "⚠️  You'll see a security warning (self-signed certificate)"
    echo "   Click 'Advanced' → 'Proceed' to continue"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Configure Powerlevel10k: p10k configure"
    echo "   2. Set your terminal font to 'MesloLGS NF'"
    echo "   3. Start coding!"
    echo ""
ENDSSH

echo ""
echo "✅ All done! Your VPS is ready."
echo ""
