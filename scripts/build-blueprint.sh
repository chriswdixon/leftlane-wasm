#!/bin/bash

#############################################################################
# Build Blueprint: Generate blueprint.json from leftlane.io export data
#############################################################################

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Building Blueprint from LeftLane.io Export"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXPORT_DIR="$REPO_DIR/leftlane-export"
BLUEPRINT_FILE="$REPO_DIR/blueprint.json"

# Check if export data exists
if [ ! -f "$EXPORT_DIR/site-info.txt" ]; then
    echo "❌ Error: $EXPORT_DIR/site-info.txt not found"
    echo ""
    echo "Please run: ./scripts/export-from-leftlane.sh first"
    exit 1
fi

echo "📖 Reading site information..."
source "$EXPORT_DIR/site-info.txt"

# Use detected info as fallback
if [ -f "$EXPORT_DIR/detected-info.txt" ]; then
    source "$EXPORT_DIR/detected-info.txt"
fi

echo "✅ Theme: ${THEME_NAME:-$THEME_SLUG}"
echo "✅ Plugins: ${#PLUGINS[@]} detected"
echo ""

# Generate blueprint.json
echo "📝 Generating blueprint.json..."

cat > "$BLUEPRINT_FILE" << EOF
{
  "\$schema": "https://playground.wordpress.net/blueprint-schema.json",
  "landingPage": "/",
  "preferredVersions": {
    "php": "8.2",
    "wp": "latest"
  },
  "phpExtensionBundles": [
    "kitchen-sink"
  ],
  "features": {
    "networking": true
  },
  "steps": [
    {
      "step": "login",
      "username": "admin",
      "password": "password"
    },
EOF

# Add theme installation
if [ -n "$THEME_SLUG" ]; then
    echo "    {" >> "$BLUEPRINT_FILE"
    echo "      \"step\": \"installTheme\"," >> "$BLUEPRINT_FILE"
    echo "      \"themeZipFile\": {" >> "$BLUEPRINT_FILE"
    echo "        \"resource\": \"wordpress.org/themes\"," >> "$BLUEPRINT_FILE"
    echo "        \"slug\": \"$THEME_SLUG\"" >> "$BLUEPRINT_FILE"
    echo "      }" >> "$BLUEPRINT_FILE"
    echo "    }," >> "$BLUEPRINT_FILE"
    
    echo "    {" >> "$BLUEPRINT_FILE"
    echo "      \"step\": \"activateTheme\"," >> "$BLUEPRINT_FILE"
    echo "      \"themeFolderName\": \"$THEME_SLUG\"" >> "$BLUEPRINT_FILE"
    echo "    }," >> "$BLUEPRINT_FILE"
fi

# Add plugins
for plugin in "${PLUGINS[@]}"; do
    if [ -n "$plugin" ]; then
        echo "    {" >> "$BLUEPRINT_FILE"
        echo "      \"step\": \"installPlugin\"," >> "$BLUEPRINT_FILE"
        echo "      \"pluginZipFile\": {" >> "$BLUEPRINT_FILE"
        echo "        \"resource\": \"wordpress.org/plugins\"," >> "$BLUEPRINT_FILE"
        echo "        \"slug\": \"$plugin\"" >> "$BLUEPRINT_FILE"
        echo "      }" >> "$BLUEPRINT_FILE"
        echo "    }," >> "$BLUEPRINT_FILE"
    fi
done

# Add site settings
cat >> "$BLUEPRINT_FILE" << EOF
    {
      "step": "setSiteOptions",
      "options": {
        "blogname": "${SITE_TITLE:-LeftLane}",
        "blogdescription": "${SITE_TAGLINE:-}",
        "permalink_structure": "${PERMALINK_STRUCTURE:-/%postname%/}"
      }
    }
EOF

# Add content import if export.xml exists
if [ -f "$REPO_DIR/content/export.xml" ]; then
    echo "," >> "$BLUEPRINT_FILE"
    cat >> "$BLUEPRINT_FILE" << 'EOF'
    {
      "step": "importWxr",
      "file": {
        "resource": "url",
        "url": "https://chriswdixon.github.io/leftlane-wasm/content/export.xml"
      }
    }
EOF
fi

# Close JSON
cat >> "$BLUEPRINT_FILE" << EOF

  ]
}
EOF

echo "✅ Blueprint generated: $BLUEPRINT_FILE"
echo ""

# Pretty print JSON
if command -v python3 &> /dev/null; then
    python3 -m json.tool "$BLUEPRINT_FILE" > "$BLUEPRINT_FILE.tmp" && mv "$BLUEPRINT_FILE.tmp" "$BLUEPRINT_FILE"
    echo "✅ JSON formatted"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Blueprint Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Theme: ${THEME_NAME:-$THEME_SLUG}"
echo "Plugins: ${#PLUGINS[@]}"
echo "Site Title: ${SITE_TITLE:-LeftLane}"
echo "Permalink: ${PERMALINK_STRUCTURE:-/%postname%/}"
echo ""

if [ -f "$REPO_DIR/content/export.xml" ]; then
    echo "✅ Content import configured"
else
    echo "⚠️  No content export found"
    echo "   Copy export.xml to: $REPO_DIR/content/"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Review blueprint.json"
echo "2. Test locally: open index.html"
echo "3. Commit and push:"
echo "   git add blueprint.json content/"
echo "   git commit -m 'Configure Playground to match leftlane.io'"
echo "   git push"
echo ""
echo "Your Playground will now look like leftlane.io!"
echo ""

