# Quick Start Guide

Get your WordPress Playground site running in 5 minutes!

## Step 1: Create GitHub Repository (2 min)

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Initialize Git
git init
git add .
git commit -m "Initial commit: WordPress Playground WASM for leftlane.io"

# Create repository on GitHub (go to https://github.com/new)
# Then connect and push:
git remote add origin https://github.com/chriswdixon/leftlane-wasm.git
git branch -M main
git push -u origin main
```

## Step 2: Enable GitHub Pages (1 min)

1. Go to repository Settings → Pages
2. Under "Source", select **"GitHub Actions"**
3. Save and wait for deployment

## Step 3: Test Locally (30 sec)

```bash
# Open in browser (Mac)
open index.html

# Or just double-click index.html in Finder
```

WordPress will load in your browser! Login with:
- **Username:** admin
- **Password:** password

## Step 4: View Live Site (30 sec)

Your site will be live at:
```
https://chriswdixon.github.io/leftlane-wasm/
```

## Step 5: Migrate Your Content (1 min)

1. Export from leftlane.io: **Tools → Export → Download**
2. Save as `content/export.xml`
3. In WordPress Playground: **Tools → Import → WordPress**
4. Upload and import

## Done! 🎉

Your WordPress site is now running on WASM via GitHub!

---

## Next Steps

- Read [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for complete migration
- Customize [blueprint.json](blueprint.json) for your needs
- Add custom themes to `wp-content/themes/`
- Add custom plugins to `wp-content/plugins/`
- Set up custom domain (see README.md)

## Need Help?

- Check [README.md](README.md) for full documentation
- Review [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for detailed steps
- See [WordPress Playground Docs](https://wordpress.github.io/wordpress-playground/)

## Test Commands

```bash
# Validate blueprint.json
cat blueprint.json | python3 -m json.tool

# Check file structure
tree -L 3

# View git status
git status

# Preview changes before commit
git diff
```

## Troubleshooting

**Site won't load?**
- Check browser console (F12)
- Try clearing cache
- Verify blueprint.json syntax

**Content won't import?**
- Check export.xml file size
- Verify file path
- Try manual import via WordPress admin

**GitHub Pages not deploying?**
- Check Actions tab for errors
- Verify Pages is enabled
- Wait a few minutes for first deploy

---

**Pro Tips:**

💡 Use Chrome DevTools to debug WordPress Playground issues

💡 Keep your export.xml under 10MB for best results

💡 Test locally before pushing to GitHub

💡 WordPress Playground uses IndexedDB for storage

💡 Changes in browser are not persistent - export/import to save

Happy blogging! 🚀

