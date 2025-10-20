# Make WordPress Playground Look Exactly Like LeftLane.io

## Detected Information

✅ **Theme:** Divi (Premium theme by Elegant Themes)  
✅ **Site Title:** LeftLane.io | Keeping You in the Fast Lane  
✅ **Plugin:** leftlane-playground (already installed)

---

## Challenge: Divi is Premium

Divi is a premium theme that cannot be automatically installed from wordpress.org. You have **3 options**:

---

## Option 1: Upload Divi to GitHub (Exact Match) ⭐ RECOMMENDED

This will make the Playground look **exactly** like leftlane.io.

### Step 1: Export Divi Theme

From your leftlane.io WordPress admin:

1. Go to **leftlane.io/wp-admin**
2. Navigate to **Appearance → Themes**
3. Find **Divi** theme
4. Click **Theme Details** or download via FTP

**Via FTP (Recommended):**
```bash
# Download from your hosting via FTP/SFTP
# Location: /wp-content/themes/Divi/
# Download the entire Divi folder
```

### Step 2: Add Divi to Repository

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Create themes directory (already exists)
mkdir -p wp-content/themes

# Copy your downloaded Divi theme
cp -r /path/to/downloaded/Divi wp-content/themes/

# Example if downloaded to Downloads:
# cp -r ~/Downloads/Divi wp-content/themes/
```

### Step 3: Update Blueprint

I'll create the blueprint for you:

```bash
cat > blueprint.json << 'EOF'
{
  "$schema": "https://playground.wordpress.net/blueprint-schema.json",
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
```

### Step 4: Zip Divi Theme

```bash
cd wp-content/themes
zip -r Divi.zip Divi/
cd ../..
```

### Step 5: Export Content

1. Go to **leftlane.io/wp-admin**
2. **Tools → Export**
3. Select **All content**
4. Download and save to: `content/export.xml`

```bash
# Copy your export file
cp ~/Downloads/wordpress.*.xml content/export.xml
```

### Step 6: Commit and Push

```bash
git add wp-content/themes/Divi.zip blueprint.json content/export.xml
git commit -m "Add Divi theme and content to match leftlane.io exactly"
git push
```

**Result:** WordPress Playground will look **exactly** like leftlane.io!

---

## Option 2: Use Similar Free Theme (Good Enough)

If you don't want to upload Divi, use a similar professional theme.

### Best Free Alternatives to Divi:

1. **Astra** - Very similar, highly customizable
2. **GeneratePress** - Clean and flexible
3. **Kadence** - Modern and powerful
4. **OceanWP** - Feature-rich

### Quick Setup with Astra:

```bash
cat > blueprint.json << 'EOF'
{
  "$schema": "https://playground.wordpress.net/blueprint-schema.json",
  "landingPage": "/",
  "preferredVersions": {
    "php": "8.2",
    "wp": "latest"
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
        "resource": "wordpress.org/themes",
        "slug": "astra"
      }
    },
    {
      "step": "activateTheme",
      "themeFolderName": "astra"
    },
    {
      "step": "setSiteOptions",
      "options": {
        "blogname": "LeftLane.io",
        "blogdescription": "Keeping You in the Fast Lane",
        "permalink_structure": "/%postname%/"
      }
    }
  ]
}
EOF

git add blueprint.json
git commit -m "Configure with Astra theme (Divi alternative)"
git push
```

**Result:** Professional look, similar to Divi, but not exact.

---

## Option 3: Hybrid Approach (Recommended for Testing)

Start with a free theme, then manually upload Divi later in the Playground.

### Step 1: Use Astra Initially

```bash
# Use blueprint from Option 2
```

### Step 2: Upload Divi Manually in Playground

1. Open Playground at: https://chriswdixon.github.io/leftlane-wasm/
2. Login: admin / password
3. Go to **Appearance → Themes → Add New → Upload Theme**
4. Upload your Divi zip file
5. Activate Divi

**Result:** You can test both approaches!

---

## Automated Setup Script

Let me automate Option 1 for you:

```bash
#!/bin/bash
# save as: setup-exact-clone.sh

echo "Setting up exact clone of leftlane.io..."

# Check if Divi exists
if [ ! -d "wp-content/themes/Divi" ]; then
    echo ""
    echo "❌ Divi theme not found!"
    echo ""
    echo "Please download Divi from leftlane.io and place in:"
    echo "  wp-content/themes/Divi/"
    echo ""
    echo "Methods:"
    echo "1. Via FTP: Download /wp-content/themes/Divi/ folder"
    echo "2. Via WordPress admin: Tools → Export (for theme files)"
    echo "3. Via hosting cPanel: File Manager → Download"
    echo ""
    exit 1
fi

echo "✅ Found Divi theme"

# Zip Divi
echo "📦 Creating Divi.zip..."
cd wp-content/themes
zip -rq Divi.zip Divi/
cd ../..

echo "✅ Divi.zip created"

# Update blueprint
echo "📝 Updating blueprint.json..."
cat > blueprint.json << 'BLUEPRINT'
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
BLUEPRINT

# Add content import if exists
if [ -f "content/export.xml" ]; then
    cat >> blueprint.json << 'IMPORT'
,
    {
      "step": "importWxr",
      "file": {
        "resource": "url",
        "url": "https://chriswdixon.github.io/leftlane-wasm/content/export.xml"
      }
    }
IMPORT
    echo "✅ Content import configured"
fi

# Close blueprint
cat >> blueprint.json << 'CLOSE'

  ]
}
CLOSE

echo "✅ Blueprint updated"

# Commit
echo "📤 Committing changes..."
git add wp-content/themes/Divi.zip blueprint.json
[ -f "content/export.xml" ] && git add content/export.xml
git commit -m "Configure Playground to exactly match leftlane.io with Divi theme"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "1. git push"
echo "2. Visit: https://chriswdixon.github.io/leftlane-wasm/"
echo ""
echo "Your Playground will look exactly like leftlane.io!"
echo ""
```

Save and run:
```bash
chmod +x setup-exact-clone.sh
./setup-exact-clone.sh
```

---

## Getting Divi Theme from LeftLane.io

### Method 1: FTP/SFTP

```bash
# Connect to your hosting
sftp user@yourhost.com

# Navigate and download
cd public_html/wp-content/themes
get -r Divi

# Copy to repository
cp -r Divi /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wp-content/themes/
```

### Method 2: cPanel File Manager

1. Log in to your hosting cPanel
2. Open File Manager
3. Navigate to: `public_html/wp-content/themes/Divi/`
4. Right-click → Compress → Create ZIP
5. Download the ZIP file
6. Extract to: `wp-content/themes/Divi/`

### Method 3: WordPress Plugin

Install "All-in-One WP Migration" or "Duplicator" to export everything.

---

## What Gets Replicated

With Option 1 (exact clone), you'll get:

✅ **Visual Design** - Divi theme with all customizations  
✅ **Content** - All posts, pages, and media  
✅ **Settings** - Site title, tagline, permalinks  
✅ **Layout** - Header, footer, sidebars  
✅ **Styling** - Colors, fonts, custom CSS

### What Won't Transfer (Limitations):

❌ **Divi Theme Options** - Custom settings from Divi Theme Options panel  
❌ **Customizer Settings** - Unless exported separately  
❌ **Plugin Data** - Database-specific plugin configurations  
❌ **Form Data** - Contact form submissions, etc.

### To Get 100% Match:

You'll need to also export:
1. **Divi Theme Options** - Use Divi's built-in export
2. **Customizer Settings** - Use Customizer Export plugin
3. **Widget Data** - Use Widget Importer & Exporter

---

## Quick Commands Reference

```bash
# Navigate to project
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Check current theme
ls wp-content/themes/

# Export content from leftlane.io
# (Do this in WordPress admin: Tools → Export)

# Copy downloaded files
cp ~/Downloads/Divi.zip wp-content/themes/
cp ~/Downloads/wordpress.*.xml content/export.xml

# Run setup
./setup-exact-clone.sh

# Test locally
open index.html

# Deploy
git push

# View live
open https://chriswdixon.github.io/leftlane-wasm/
```

---

## My Recommendation

**Start with Option 2 (free theme) for testing**, then upgrade to Option 1 (Divi) once you're comfortable with the setup.

This lets you:
1. ✅ Get started immediately
2. ✅ Test the Playground functionality
3. ✅ Learn the workflow
4. ✅ Then add Divi for exact match

Would you like me to set up Option 2 (Astra theme) right now so you can start testing?

