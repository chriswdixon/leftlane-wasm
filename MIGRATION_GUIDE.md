# Complete Migration Guide: leftlane.io → GitHub-backed WordPress WASM

This guide walks you through migrating your existing leftlane.io WordPress site to a GitHub-backed WordPress Playground (WASM) setup.

## Prerequisites

- Access to your existing leftlane.io WordPress admin panel
- GitHub account (chriswdixon@gmail.com)
- FTP/SFTP access to your current WordPress hosting (for files)
- Web browser (Chrome, Firefox, or Edge recommended)

## Phase 1: Backup Your Current Site

### 1.1 Export WordPress Content

```
1. Log in to https://leftlane.io/wp-admin
2. Navigate to Tools → Export
3. Select "All content"
4. Click "Download Export File"
5. Save as export.xml
```

### 1.2 Download Theme and Plugins

**Option A: Via FTP/SFTP**
```bash
# Connect to your hosting via FTP client
# Download these directories:
- wp-content/themes/[your-active-theme]
- wp-content/plugins/[your-plugins]
- wp-content/uploads/ (all media files)
```

**Option B: Via WordPress Admin**
```
1. Go to Appearance → Themes
2. Note your active theme name
3. Go to Plugins → Installed Plugins
4. Export list of active plugins
```

### 1.3 Backup Database (Safety)

If your hosting provides phpMyAdmin:
```
1. Log in to phpMyAdmin
2. Select your WordPress database
3. Click "Export"
4. Choose "Quick" export method
5. Download the .sql file
6. Store securely (DO NOT commit to Git)
```

## Phase 2: Set Up GitHub Repository

### 2.1 Create New Repository

```bash
# Navigate to the project directory we created
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm

# Initialize Git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: WordPress Playground WASM setup for leftlane.io"
```

### 2.2 Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `leftlane-wasm` (or `leftlane-io`)
3. Description: "GitHub-backed WordPress site for leftlane.io running on WASM"
4. Visibility: Public (for GitHub Pages) or Private
5. DO NOT initialize with README (we already have one)
6. Click "Create repository"

### 2.3 Push to GitHub

```bash
# Add GitHub remote (replace with your actual username)
git remote add origin https://github.com/chriswdixon/leftlane-wasm.git

# Rename branch to main if needed
git branch -M main

# Push to GitHub
git push -u origin main
```

## Phase 3: Configure GitHub Pages

### 3.1 Enable GitHub Pages

1. Go to your repository on GitHub
2. Click "Settings" tab
3. Click "Pages" in the left sidebar
4. Under "Source", select "GitHub Actions"
5. Save

### 3.2 Trigger Deployment

The GitHub Actions workflow will automatically run when you push to main. Check:
- Go to "Actions" tab
- Watch the "Deploy to GitHub Pages" workflow
- Wait for it to complete (green checkmark)

### 3.3 Access Your Site

Your site will be available at:
```
https://chriswdixon.github.io/leftlane-wasm/
```

## Phase 4: Migrate Content

### 4.1 Add Your Export File

```bash
# Copy your WordPress export file to the content directory
cp ~/Downloads/export.xml /Users/chrisdixon/Documents/GitHub/leftlane-wasm/content/

# Commit and push
git add content/export.xml
git commit -m "Add WordPress content export"
git push
```

### 4.2 Add Your Theme

```bash
# Copy your active theme
cp -r /path/to/your-theme /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wp-content/themes/

# Update blueprint.json to activate your theme
# Edit blueprint.json and change the theme steps:
{
  "step": "activateTheme",
  "themeFolderName": "your-theme-name"
}

# Commit and push
git add wp-content/themes/
git add blueprint.json
git commit -m "Add custom theme"
git push
```

### 4.3 Add Your Plugins

```bash
# Copy your plugins
cp -r /path/to/your-plugins/* /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wp-content/plugins/

# Update blueprint.json to install/activate plugins
# Add for each plugin:
{
  "step": "installPlugin",
  "pluginZipFile": {
    "resource": "wordpress.org/plugins",
    "slug": "your-plugin-slug"
  }
}

# Or for custom plugins already in wp-content/plugins:
{
  "step": "activatePlugin",
  "pluginPath": "your-plugin-folder/main-plugin-file.php"
}

# Commit and push
git add wp-content/plugins/
git add blueprint.json
git commit -m "Add custom plugins"
git push
```

### 4.4 Import Media Files (Optional)

**Note:** Media files can be large. Consider:

**Option A: Include in Repository (Small sites)**
```bash
cp -r /path/to/uploads /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wp-content/
git add wp-content/uploads/
git commit -m "Add media uploads"
git push
```

**Option B: Use CDN (Recommended for large sites)**
- Upload media to Cloudinary, AWS S3, or similar
- Update URLs in WordPress after import

### 4.5 Import Content into WordPress Playground

1. Open your deployed site: `https://chriswdixon.github.io/leftlane-wasm/`
2. Wait for WordPress Playground to load
3. Log in with: `admin` / `password` (from blueprint.json)
4. Go to **Tools → Import**
5. Click "WordPress" and install the importer
6. Click "Run Importer"
7. Choose file: `content/export.xml` (you may need to upload it manually)
8. Download and import file attachments: ✓
9. Assign authors appropriately
10. Click "Submit"

## Phase 5: Configure Custom Domain

### 5.1 Add CNAME File

```bash
# Create CNAME file for custom domain
echo "leftlane.io" > /Users/chrisdixon/Documents/GitHub/leftlane-wasm/CNAME

git add CNAME
git commit -m "Add custom domain"
git push
```

### 5.2 Update DNS Settings

In your domain registrar (where you bought leftlane.io):

**For Apex Domain (leftlane.io):**
```
Type: A
Name: @
Value: 185.199.108.153

Type: A
Name: @
Value: 185.199.109.153

Type: A
Name: @
Value: 185.199.110.153

Type: A
Name: @
Value: 185.199.111.153
```

**For WWW Subdomain:**
```
Type: CNAME
Name: www
Value: chriswdixon.github.io
```

### 5.3 Enable HTTPS

1. Go to GitHub repository Settings → Pages
2. Wait for DNS to propagate (can take 24-48 hours)
3. Check "Enforce HTTPS"

## Phase 6: Testing and Validation

### 6.1 Test Checklist

- [ ] Site loads correctly
- [ ] All pages are accessible
- [ ] All posts are visible
- [ ] Images and media load
- [ ] Navigation menus work
- [ ] Theme displays correctly
- [ ] Plugins function properly
- [ ] Forms work (if applicable)
- [ ] Contact information is correct
- [ ] SEO meta tags are present

### 6.2 Cross-Browser Testing

Test in:
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari
- [ ] Edge
- [ ] Mobile browsers (iOS/Android)

### 6.3 Performance Testing

- [ ] Time to first byte (TTFB)
- [ ] Page load time
- [ ] WordPress Playground startup time
- [ ] Content rendering

## Phase 7: Go Live

### 7.1 Final Backup

Before switching DNS:
```bash
# Backup your old site one more time
# Via your hosting control panel or:
mysqldump -u user -p database > final_backup.sql
tar -czf site_backup.tar.gz wp-content/
```

### 7.2 Switch DNS

Update your DNS settings as described in Phase 5.

### 7.3 Monitor

After DNS changes:
- Monitor site uptime
- Check error logs (browser console)
- Test all critical functionality
- Monitor GitHub Actions for deployment issues

## Troubleshooting

### WordPress Playground Won't Load

**Issue:** Blank screen or loading forever

**Solutions:**
1. Check browser console for errors (F12)
2. Verify blueprint.json syntax (use JSONLint.com)
3. Check GitHub Pages deployment status
4. Try a different browser
5. Clear browser cache and localStorage

### Content Not Importing

**Issue:** Import fails or content missing

**Solutions:**
1. Check export.xml file size (<10MB works best)
2. Split large exports into multiple files
3. Import manually via WordPress admin
4. Verify export.xml is accessible via URL

### Theme/Plugins Not Working

**Issue:** Theme or plugins not activating

**Solutions:**
1. Verify file structure matches standard WordPress
2. Check blueprint.json configuration
3. Some plugins may not work in WASM environment
4. Check browser console for PHP/JS errors

### Custom Domain Not Working

**Issue:** Domain doesn't resolve or shows 404

**Solutions:**
1. Wait 24-48 hours for DNS propagation
2. Verify DNS settings with `dig leftlane.io`
3. Check CNAME file exists and contains correct domain
4. Verify GitHub Pages is configured correctly

### Performance Issues

**Issue:** Site loads slowly

**Solutions:**
1. WordPress Playground has initial load time
2. Consider adding loading screen (already included)
3. Optimize images before uploading
4. Minimize number of plugins
5. Use browser caching

## Alternative Approaches

If WordPress Playground doesn't meet your needs:

### Option 1: Headless WordPress
- Keep existing WordPress as CMS backend
- Use static site generator (Gatsby, Next.js) for frontend
- Deploy static files to GitHub Pages

### Option 2: Traditional WordPress + Git
- Keep standard WordPress hosting
- Use Git for version control
- Deploy via GitHub Actions to traditional host

### Option 3: WordPress.com with GitHub
- Use WordPress.com hosting
- Connect GitHub repository
- Git-based deployments

## Maintenance

### Regular Updates

```bash
# Update WordPress core version in blueprint.json
{
  "preferredVersions": {
    "wp": "6.4"  # Update this
  }
}

# Commit and push
git add blueprint.json
git commit -m "Update WordPress to 6.4"
git push
```

### Content Updates

Edit content in WordPress Playground, then export:
1. Make changes in WordPress admin
2. Export content via Tools → Export
3. Replace content/export.xml
4. Commit and push

### Plugin/Theme Updates

```bash
# Update plugin/theme files
# Download new version
# Replace in wp-content/
git add wp-content/
git commit -m "Update plugin X to version Y"
git push
```

## Support Resources

- **WordPress Playground:** https://wordpress.github.io/wordpress-playground/
- **GitHub Pages:** https://docs.github.com/pages
- **This Repository:** Issues tab for questions

## Next Steps

1. Complete the migration following this guide
2. Test thoroughly
3. Keep old site running until fully validated
4. Update external links to new URLs
5. Set up redirects from old hosting (if needed)
6. Monitor for 30 days before canceling old hosting

---

**Migration Completion Checklist:**

- [ ] Backup completed
- [ ] GitHub repository created
- [ ] GitHub Pages deployed
- [ ] Content exported
- [ ] Content imported
- [ ] Theme migrated
- [ ] Plugins migrated
- [ ] Media files handled
- [ ] Custom domain configured
- [ ] DNS updated
- [ ] HTTPS enabled
- [ ] Testing completed
- [ ] Site live
- [ ] Old site backed up
- [ ] Monitoring in place

Good luck with your migration! 🚀

