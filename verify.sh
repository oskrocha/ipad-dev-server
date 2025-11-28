#!/bin/bash
# Quick Deploy Script - Run this to verify files before upload

set -e

echo "🔍 Verifying VPS setup files..."

# Check if all required files exist
REQUIRED_FILES=("setup.sh" "docker-compose.yml" "nginx.conf")
MISSING=0

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing: $file"
        MISSING=1
    else
        echo "✅ Found: $file"
    fi
done

if [ $MISSING -eq 1 ]; then
    echo ""
    echo "❌ Some required files are missing!"
    exit 1
fi

# Check if setup.sh is executable
if [ ! -x "setup.sh" ]; then
    echo "📝 Making setup.sh executable..."
    chmod +x setup.sh
fi

echo ""
echo "✅ All files verified!"
echo ""
echo "📤 Ready to upload to VPS. Run:"
echo ""
echo "  scp setup.sh docker-compose.yml nginx.conf user@your-vps-ip:~/"
echo ""
echo "Then on your VPS, run:"
echo ""
echo "  chmod +x setup.sh"
echo "  ./setup.sh"
echo ""
echo "📚 Documentation:"
echo "  - README.md       - Full guide"
echo "  - CHECKLIST.md    - Pre-installation checklist"
echo "  - DISTRO_GUIDE.md - Distribution differences"
echo ""
