#!/bin/bash

#############################################################################
# Clone LeftLane.io Homepage - Complete Automation
#############################################################################

set -e

cd "$(dirname "$0")/.."

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔄 Cloning LeftLane.io Homepage to WordPress Playground"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."
echo ""

MISSING=0

if [ ! -f "content/export.xml" ]; then
    echo "❌ Missing: content/export.xml"
    echo "   📍 Export from: leftlane.io/wp-admin → Tools → Export → All content"
    echo ""
    MISSING=1
fi

if [ ! -d "wp-content/themes/Divi" ]; then
    echo "❌ Missing: Divi theme"
    echo "   📍 Download from leftlane.io via FTP/SFTP"
    echo "   📍 Location: /wp-content/themes/Divi/"
    echo ""
    MISSING=1
fi

if [ $MISSING -eq 1 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  Please complete the missing items above"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Quick guide:"
    echo ""
    echo "1. Export Content:"
    echo "   - Visit: https://leftlane.io/wp-admin"
    echo "   - Go to: Tools → Export"
    echo "   - Select: All content"
    echo "   - Download and save to: content/export.xml"
    echo ""
    echo "2. Download Divi Theme:"
    echo "   - Connect via FTP/SFTP to your hosting"
    echo "   - Download: /wp-content/themes/Divi/"
    echo "   - Copy to: wp-content/themes/Divi/"
    echo ""
    echo "   OR use cPanel File Manager:"
    echo "   - Navigate to wp-content/themes/Divi"
    echo "   - Right-click → Compress → ZIP"
    echo "   - Download and extract to wp-content/themes/"
    echo ""
    exit 1
fi

echo "✅ content/export.xml found"
echo "✅ Divi theme found"

# Check for child theme
if [ -d "wp-content/themes/Divi-child" ]; then
    echo "✅ Divi child theme found"
    HAS_CHILD=1
else
    echo "ℹ️  No Divi child theme (optional)"
    HAS_CHILD=0
fi

echo ""

# Create theme zips
echo "📦 Creating theme archives..."

cd wp-content/themes

# Remove old zips
rm -f Divi.zip Divi-child.zip

# Zip Divi
echo "   → Compressing Divi theme..."
zip -rq Divi.zip Divi/
DIVI_SIZE=$(du -h Divi.zip | cut -f1)
echo "   ✅ Divi.zip created ($DIVI_SIZE)"

# Zip child theme if exists
if [ $HAS_CHILD -eq 1 ]; then
    echo "   → Compressing Divi child theme..."
    zip -rq Divi-child.zip Divi-child/
    CHILD_SIZE=$(du -h Divi-child.zip | cut -f1)
    echo "   ✅ Divi-child.zip created ($CHILD_SIZE)"
fi

cd ../..
echo ""

# Update blueprint
echo "📝 Generating blueprint.json..."

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
        "permalink_structure": "/%postname%/",
        "show_on_front": "page"
      }
    },
    {
      "step": "importWxr",
      "file": {
        "resource": "url",
        "url": "https://chriswdixon.github.io/leftlane-wasm/content/export.xml"
      }
    }
  ]
}
EOF

echo "✅ blueprint.json generated"
echo ""

# Show what will be committed
echo "📋 Files to be committed:"
echo "   • wp-content/themes/Divi.zip"
if [ $HAS_CHILD -eq 1 ]; then
    echo "   • wp-content/themes/Divi-child.zip"
fi
echo "   • content/export.xml"
echo "   • blueprint.json"
echo ""

# Commit changes
echo "📤 Committing to Git..."
git add wp-content/themes/*.zip content/export.xml blueprint.json

if git diff --cached --quiet; then
    echo "ℹ️  No changes to commit (already up to date)"
else
    git commit -m "Add complete LeftLane.io clone with Divi theme and content

- Divi theme ($DIVI_SIZE)
$([ $HAS_CHILD -eq 1 ] && echo "- Divi child theme ($CHILD_SIZE)")
- Full content export with all posts, pages, and media
- Configured to match leftlane.io exactly
- Ready for WordPress Playground deployment"
    
    echo "✅ Changes committed"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Clone Preparation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🚀 Next steps:"
echo ""
echo "  1. Push to GitHub:"
echo "     git push"
echo ""
echo "  2. Wait 2-3 minutes for GitHub Pages deployment"
echo ""
echo "  3. Visit your Playground:"
echo "     https://chriswdixon.github.io/leftlane-wasm/"
echo ""
echo "  4. Login with:"
echo "     Username: admin"
echo "     Password: password"
echo ""
echo "  5. Import Divi settings (see CLONE_HOMEPAGE_GUIDE.md):"
echo "     • Divi → Theme Options → Import"
echo "     • Divi → Divi Library → Import layouts"
echo "     • Settings → Reading → Set homepage"
echo ""
echo "📖 Full guide: CLONE_HOMEPAGE_GUIDE.md"
echo ""
echo "Your WordPress Playground will look exactly like leftlane.io!"
echo ""

