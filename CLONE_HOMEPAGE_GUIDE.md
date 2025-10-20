# Clone LeftLane.io Homepage Exactly in WordPress Playground

Your site uses **Divi theme** with custom Divi Builder layouts. Here's how to replicate it exactly.

## What I Detected from LeftLane.io:

✅ **Theme:** Divi (premium)  
✅ **Fonts:** Kaushan Script, Montserrat, Open Sans  
✅ **Page Builder:** Divi Builder with custom sections  
✅ **Site Title:** "LeftLane.io | Keeping You in the Fast Lane"

## Step-by-Step: Complete Clone

### Step 1: Export Everything from LeftLane.io

#### A. Export Content (WordPress Admin)

1. Log in to https://leftlane.io/wp-admin
2. Go to **Tools → Export**
3. Select **"All content"**
4. Click **"Download Export File"**
5. Save as: `leftlane-io-export.xml`

#### B. Export Divi Theme Options

1. In WordPress admin, go to **Divi → Theme Options**
2. Scroll to bottom
3. Click **"Export Theme Options"** tab
4. Copy the JSON export data
5. Save to file: `divi-theme-options.json`

#### C. Export Divi Builder Layouts

1. Go to **Divi → Divi Library**
2. Click **"Import & Export"** tab
3. Click **"Export"** button
4. Save the file as: `divi-layouts.json`

#### D. Export Customizer Settings (Optional but recommended)

Install **"Customizer Export/Import"** plugin temporarily:
1. Go to **Plugins → Add New**
2. Search "Customizer Export/Import"
3. Install and activate
4. Go to **Appearance → Customize**
5. Look for **"Export/Import"** panel
6. Click **Export** and save file

#### E. Download Divi Theme via FTP/SFTP

```bash
# Connect to your hosting and download:
/wp-content/themes/Divi/
/wp-content/themes/Divi-child/

# Save to your local machine
```

### Step 2: Prepare Files for Repository

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Copy your exports
cp ~/Downloads/leftlane-io-export.xml content/export.xml
cp ~/Downloads/divi-theme-options.json leftlane-export/
cp ~/Downloads/divi-layouts.json leftlane-export/

# Copy Divi theme (if you downloaded via FTP)
cp -r ~/Downloads/Divi wp-content/themes/
cp -r ~/Downloads/Divi-child wp-content/themes/
```

### Step 3: Create Divi Theme Zip

```bash
cd wp-content/themes

# Zip Divi parent theme
zip -r Divi.zip Divi/

# Zip Divi child theme
zip -r Divi-child.zip Divi-child/

cd ../..
```

### Step 4: Update Blueprint Configuration

Run the automated setup:

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm
./scripts/setup-exact-clone.sh
```

Or manually update `blueprint.json`:

```json
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
```

### Step 5: Import Divi Settings (After Playground Loads)

Once WordPress Playground is running:

1. **Import Theme Options:**
   - Go to **Divi → Theme Options**
   - Click **"Import"** tab
   - Paste content from `divi-theme-options.json`
   - Click **"Import Divi Theme Options"**

2. **Import Divi Layouts:**
   - Go to **Divi → Divi Library**
   - Click **"Import & Export"** tab
   - Upload `divi-layouts.json`
   - Click **"Import"**

3. **Set Homepage:**
   - Go to **Settings → Reading**
   - Select **"A static page"**
   - Choose your homepage from dropdown
   - Save

### Step 6: Commit and Deploy

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Add all files
git add wp-content/themes/*.zip content/export.xml blueprint.json

# Commit
git commit -m "Add complete Divi theme and LeftLane.io content for exact clone"

# Push to GitHub
git push

# Wait 2-3 minutes for GitHub Pages to deploy
```

### Step 7: View Your Exact Clone

Visit: https://chriswdixon.github.io/leftlane-wasm/

The homepage should look **exactly** like leftlane.io!

---

## Alternative: Simpler Approach (If You Don't Have FTP Access)

If you can't download Divi via FTP, use this method:

### Method 1: Divi Portability

Divi has built-in export/import:

1. On leftlane.io, create a page
2. Edit with Divi Builder
3. Click the **three dots** (•••) menu
4. Select **"Portability"**
5. **Export:** Copy the JSON
6. Save as `homepage-layout.json`

Then in Playground:
1. Create a new page
2. Edit with Divi Builder  
3. Click **three dots** → **Portability**
4. **Import:** Paste the JSON
5. Save
6. Set as homepage

### Method 2: Manual Recreation

Since you're already using the leftlane-playground plugin on leftlane.io:

1. Open WordPress Playground in your leftlane.io admin (via the plugin)
2. Use Divi Builder's **"Load From Library"**
3. Load your existing layouts
4. They'll be available in the Playground!

---

## Automated Script (Does Everything)

I'll create a complete automation script:

```bash
#!/bin/bash
# save as: clone-leftlane-homepage.sh

echo "🔄 Cloning LeftLane.io Homepage..."

# Check prerequisites
if [ ! -f "content/export.xml" ]; then
    echo "❌ Missing: content/export.xml"
    echo "   Export from: leftlane.io/wp-admin → Tools → Export"
    exit 1
fi

if [ ! -d "wp-content/themes/Divi" ]; then
    echo "❌ Missing: Divi theme"
    echo "   Download from leftlane.io via FTP"
    exit 1
fi

echo "✅ All prerequisites found"

# Create theme zips
echo "📦 Creating theme archives..."
cd wp-content/themes
rm -f Divi.zip Divi-child.zip
zip -rq Divi.zip Divi/
[ -d "Divi-child" ] && zip -rq Divi-child.zip Divi-child/
cd ../..

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

echo "✅ Blueprint updated"

# Commit changes
echo "📤 Committing to Git..."
git add wp-content/themes/*.zip content/export.xml blueprint.json
git commit -m "Complete clone of LeftLane.io homepage with Divi theme"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Ready to deploy!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. git push"
echo "  2. Wait 2-3 minutes for GitHub Pages deployment"
echo "  3. Visit: https://chriswdixon.github.io/leftlane-wasm/"
echo "  4. Login: admin / password"
echo "  5. Import Divi theme options and layouts (see guide)"
echo ""
```

Make it executable:
```bash
chmod +x clone-leftlane-homepage.sh
```

---

## Quick Checklist

- [ ] Export content from leftlane.io (XML file)
- [ ] Export Divi theme options (JSON)
- [ ] Export Divi Builder layouts (JSON)
- [ ] Download Divi theme folder via FTP
- [ ] Copy files to repository
- [ ] Run setup script
- [ ] Push to GitHub
- [ ] Import Divi settings in Playground
- [ ] Set homepage
- [ ] Verify exact match!

---

## What Gets Cloned

✅ **Visual Design:** Complete Divi layout  
✅ **Content:** All posts, pages, images  
✅ **Fonts:** Kaushan Script, Montserrat, Open Sans  
✅ **Theme Settings:** Colors, styles, options  
✅ **Builder Layouts:** All Divi sections  
✅ **Navigation:** Menus and structure  
✅ **Site Settings:** Title, tagline, permalinks

---

## Troubleshooting

**Q: Divi theme not activating?**
- Check that Divi.zip uploaded correctly
- Verify the zip contains the theme files
- Try manually uploading via Playground admin

**Q: Layouts not importing?**
- Ensure you exported as JSON (not individual modules)
- Import via Divi Library, not Customizer
- Some layouts may need manual adjustment

**Q: Fonts not loading?**
- Divi loads fonts automatically
- Check that networking is enabled in blueprint
- Fonts may load slower on first visit

**Q: Homepage looks different?**
- Verify you imported theme options
- Check that homepage is set in Settings → Reading
- Some Divi Customizer settings may need manual setup

---

## Next Steps After Clone

Once your Playground matches leftlane.io:

1. **Test everything:**
   - Click all links
   - Test navigation
   - Check mobile responsive
   - Verify all sections load

2. **Fine-tune:**
   - Adjust any layout differences
   - Update any test content
   - Configure additional plugins if needed

3. **Make it your homepage (if desired):**
   - Follow MAKE_WASM_HOMEPAGE.md
   - Use the leftlane-playground plugin
   - Embed on your live site

---

## Files You Need from LeftLane.io

```
content/export.xml                      ← WordPress export (all content)
wp-content/themes/Divi/                 ← Theme files (via FTP)
wp-content/themes/Divi-child/           ← Child theme (via FTP)
leftlane-export/divi-theme-options.json ← Divi settings
leftlane-export/divi-layouts.json       ← Divi layouts
```

---

Ready to start? Follow Step 1 above to export from leftlane.io!

