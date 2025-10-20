#!/bin/bash

#############################################################################
# Export Script: Clone LeftLane.io Appearance to WordPress Playground
#############################################################################

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Export LeftLane.io to WordPress Playground WASM"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Configuration
SITE_URL="https://leftlane.io"
WP_ADMIN="$SITE_URL/wp-admin"
EXPORT_DIR="$(dirname "$0")/../leftlane-export"
REPO_DIR="$(dirname "$0")/.."

# Create export directory
mkdir -p "$EXPORT_DIR"

echo "📋 STEP 1: Gather Information"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To replicate leftlane.io in WordPress Playground, I need:"
echo ""
echo "1. ✅ Theme name/slug"
echo "2. ✅ Active plugins list"
echo "3. ✅ Content export (XML)"
echo "4. ✅ Site settings (title, tagline, etc.)"
echo "5. ✅ Homepage settings"
echo ""

# Method 1: If they have WP-CLI access
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 METHOD 1: Using WP-CLI (if you have SSH access)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "If you have SSH/terminal access to leftlane.io, run these commands:"
echo ""
echo "# Get active theme"
echo "wp theme list --status=active --field=name --path=/path/to/wordpress"
echo ""
echo "# Get active plugins"
echo "wp plugin list --status=active --format=json --path=/path/to/wordpress"
echo ""
echo "# Export content"
echo "wp export --dir=. --path=/path/to/wordpress"
echo ""
echo "# Get site options"
echo "wp option get blogname --path=/path/to/wordpress"
echo "wp option get blogdescription --path=/path/to/wordpress"
echo "wp option get show_on_front --path=/path/to/wordpress"
echo ""

# Method 2: Via WordPress Admin
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🖥️  METHOD 2: Via WordPress Admin (Easier)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Follow these steps:"
echo ""
echo "1. LOG IN to: $WP_ADMIN"
echo ""
echo "2. GET THEME NAME:"
echo "   - Go to: Appearance → Themes"
echo "   - Note the active theme name"
echo ""
echo "3. GET PLUGINS:"
echo "   - Go to: Plugins → Installed Plugins"
echo "   - Note all active plugins"
echo ""
echo "4. EXPORT CONTENT:"
echo "   - Go to: Tools → Export"
echo "   - Select: All content"
echo "   - Click: Download Export File"
echo "   - Save to: $EXPORT_DIR/export.xml"
echo ""
echo "5. GET SITE INFO:"
echo "   - Go to: Settings → General"
echo "   - Note: Site Title and Tagline"
echo "   - Go to: Settings → Reading"
echo "   - Note: Homepage displays (latest posts or static page)"
echo ""

# Create info file template
cat > "$EXPORT_DIR/site-info.txt" << 'EOF'
# Fill in this information about leftlane.io

THEME_NAME=
THEME_SLUG=

PLUGINS=(
    # List active plugin slugs, one per line
    # Example:
    # "contact-form-7"
    # "yoast-seo"
)

SITE_TITLE="LeftLane"
SITE_TAGLINE=""

HOMEPAGE_TYPE="posts"  # or "page"
HOMEPAGE_ID=""  # if using static page

PERMALINK_STRUCTURE="/%postname%/"
EOF

echo ""
echo "6. FILL IN SITE INFO:"
echo "   - Edit: $EXPORT_DIR/site-info.txt"
echo "   - Fill in all the information you gathered"
echo ""

# Method 3: Automated detection
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 METHOD 3: Automated Detection (Partial)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Attempting to detect theme from leftlane.io..."

# Try to detect theme from HTML
THEME_DETECT=$(curl -s "$SITE_URL" | grep -oP "wp-content/themes/\K[^/]+" | head -1)

if [ -n "$THEME_DETECT" ]; then
    echo "✅ Detected theme: $THEME_DETECT"
    echo "THEME_SLUG=\"$THEME_DETECT\"" >> "$EXPORT_DIR/detected-info.txt"
else
    echo "⚠️  Could not automatically detect theme"
fi

# Try to detect plugins
echo ""
echo "Detecting plugins..."
curl -s "$SITE_URL" | grep -oP "wp-content/plugins/\K[^/']+" | sort -u | head -10 > "$EXPORT_DIR/detected-plugins.txt"

if [ -s "$EXPORT_DIR/detected-plugins.txt" ]; then
    echo "✅ Detected some plugins (saved to detected-plugins.txt)"
    cat "$EXPORT_DIR/detected-plugins.txt"
else
    echo "⚠️  Could not automatically detect plugins"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 NEXT STEPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Review detected information in: $EXPORT_DIR/"
echo ""
echo "2. Complete the manual steps above to get:"
echo "   - Content export (XML file)"
echo "   - Full theme name"
echo "   - Complete plugin list"
echo ""
echo "3. Once you have everything, run:"
echo "   ./scripts/build-blueprint.sh"
echo ""
echo "This will automatically update blueprint.json with your site's configuration!"
echo ""

# Create directory structure
mkdir -p "$REPO_DIR/wp-content/themes"
mkdir -p "$REPO_DIR/wp-content/plugins"
mkdir -p "$REPO_DIR/content"

echo "✅ Export directories created"
echo ""
echo "Export location: $EXPORT_DIR"
echo ""

