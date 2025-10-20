#!/bin/bash

#############################################################################
# Setup Exact Clone: Configure Playground to match leftlane.io exactly
#############################################################################

set -e

cd "$(dirname "$0")/.."

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup Exact Clone of LeftLane.io"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Divi exists
if [ ! -d "wp-content/themes/Divi" ]; then
    echo "❌ Divi theme not found!"
    echo ""
    echo "Please download Divi from leftlane.io and place in:"
    echo "  wp-content/themes/Divi/"
    echo ""
    echo "Methods:"
    echo "1. Via FTP: Download /wp-content/themes/Divi/ folder"
    echo "2. Via hosting cPanel: File Manager → Download"
    echo "3. Via WordPress admin if you have theme export plugin"
    echo ""
    exit 1
fi

echo "✅ Found Divi theme"

# Zip Divi
echo "📦 Creating Divi.zip..."
cd wp-content/themes
rm -f Divi.zip
zip -rq Divi.zip Divi/
cd ../..

echo "✅ Divi.zip created"

# Update blueprint
echo "📝 Updating blueprint.json..."
cat > blueprint.json << 'EOF'
{
  "$schema": "https://playground.wordpress.net/blueprint-schema.json",
  "landingPage": "/",
  "preferredVersions": {
    "php": "8.2",
    "wp": "latest"
  },
  "phpExtensionBundles": ["kitchen-sink"],
  "features": {
    "networking": true
  },
  "steps": [
    {
      "step": "login",
      "username": "admin",
      "password": "password"
    },
    {
      "step": "installTheme",
      "themeZipFile": {
        "resource": "url",
        "url": "https://chriswdixon.github.io/leftlane-wasm/wp-content/themes/Divi.zip"
      }
    },
    {
      "step": "activateTheme",
      "themeFolderName": "Divi"
    },
    {
      "step": "setSiteOptions",
      "options": {
        "blogname": "LeftLane.io",
        "blogdescription": "Keeping You in the Fast Lane",
        "permalink_structure": "/%postname%/"
      }
    }
EOF

# Add content import if exists
if [ -f "content/export.xml" ]; then
    cat >> blueprint.json << 'EOF'
,
    {
      "step": "importWxr",
      "file": {
        "resource": "url",
        "url": "https://chriswdixon.github.io/leftlane-wasm/content/export.xml"
      }
    }
EOF
    echo "✅ Content import will be included"
else
    echo "⚠️  No content/export.xml found - skipping content import"
    echo "   Export from leftlane.io: Tools → Export → All content"
fi

# Close blueprint
cat >> blueprint.json << 'EOF'

  ]
}
EOF

echo "✅ Blueprint updated"

# Commit
echo ""
echo "📤 Committing changes..."
git add wp-content/themes/Divi.zip blueprint.json
[ -f "content/export.xml" ] && git add content/export.xml

git commit -m "Configure Playground to exactly match leftlane.io with Divi theme"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Configured:"
echo "  • Theme: Divi"
echo "  • Site: LeftLane.io"

if [ -f "content/export.xml" ]; then
    echo "  • Content: Imported from export.xml"
fi

echo ""
echo "Next steps:"
echo "  1. git push"
echo "  2. Visit: https://chriswdixon.github.io/leftlane-wasm/"
echo ""
echo "Your Playground will look exactly like leftlane.io!"
echo ""

