# Install WordPress Playground on Your Existing LeftLane.io Site

## 🎯 Quick Summary

You can now add WordPress Playground (WASM) to your **existing** leftlane.io WordPress site! This lets you:
- Test changes safely before going live
- Create interactive demos for visitors
- Train team members without risking production
- Preview content in a sandboxed environment

## 📦 What's Been Created

I've built a complete WordPress plugin that integrates WordPress Playground into your existing site:

### Plugin Features:
✅ **Admin Page** - Full Playground interface in WordPress admin  
✅ **Shortcode** - Embed anywhere with `[leftlane_playground]`  
✅ **Admin Bar Link** - Quick "Test in Playground" button  
✅ **Settings Page** - Customize height, blueprint URL, etc.  
✅ **Fully Styled** - Beautiful loading screens and responsive design  
✅ **Zero Dependencies** - Works out of the box

## 🚀 Installation (3 Minutes)

### Step 1: Download the Plugin

The plugin is ready at:
```
/Users/chrisdixon/Documents/GitHub/leftlane-wasm/wordpress-plugin/leftlane-playground.zip
```

Or download from GitHub:
```
https://github.com/chriswdixon/leftlane-wasm/raw/main/wordpress-plugin/leftlane-playground.zip
```

### Step 2: Install in WordPress

**Option A: Via WordPress Admin (Easiest)**

1. Log in to https://leftlane.io/wp-admin
2. Go to **Plugins → Add New**
3. Click **Upload Plugin** button
4. Choose `leftlane-playground.zip`
5. Click **Install Now**
6. Click **Activate Plugin**

**Option B: Via FTP/SFTP**

1. Extract the zip file
2. Upload `leftlane-playground` folder to:
   ```
   /wp-content/plugins/leftlane-playground/
   ```
3. In WordPress admin, go to **Plugins**
4. Find "LeftLane WordPress Playground Integration"
5. Click **Activate**

**Option C: Via WP-CLI**

```bash
wp plugin install /path/to/leftlane-playground.zip --activate
```

### Step 3: Configure (Optional)

Go to **Playground → Settings** to customize:
- Blueprint URL (points to your GitHub config)
- Default height for embeds
- Admin bar visibility

### Step 4: Start Using!

After activation, you'll see:
- **Playground** menu in WordPress admin sidebar
- **Test in Playground** link in admin bar (top)

## 💻 Usage Examples

### 1. WordPress Admin Testing

Click **Playground** in the admin menu to open a full WordPress testing environment.

**Use Cases:**
- Test new plugins before installing on live site
- Preview theme changes
- Try different WordPress settings
- Train team members

### 2. Embed in Posts/Pages

Add the shortcode to any post or page:

**Basic Embed:**
```
[leftlane_playground]
```

**Custom Height:**
```
[leftlane_playground height="600"]
```

**Full Width, No Border:**
```
[leftlane_playground height="800" border="no"]
```

### 3. Quick Access from Admin Bar

Click **"Test in Playground"** in the WordPress admin bar for instant access.

## 📝 Real-World Examples

### Example 1: Content Preview Page

Create a page for your team to preview content:

```
# Content Preview Sandbox

Test your content before publishing:

[leftlane_playground height="700"]

## Instructions
1. Login with: admin / password
2. Create your content
3. Preview how it looks
4. Then create it on the live site
```

### Example 2: Plugin Demo Page

Showcase a plugin to potential customers:

```
# Try Our Plugin Live

Experience our WordPress plugin in action:

[leftlane_playground height="800"]

Click around, test features, no signup required!
```

### Example 3: Training Page

Create WordPress training content:

```
# WordPress Training Module 1

Follow along in this live WordPress environment:

[leftlane_playground]

### Lesson Steps:
1. Login (admin/password)
2. Navigate to Posts → Add New
3. Create a blog post
4. Add an image
5. Publish!

Try it yourself in the sandbox above ↑
```

## 🎨 Integration Options

### Option 1: Testing Environment (Recommended)
- Use the **Playground admin page** for internal testing
- Keep it private for your team
- Test before deploying to production

### Option 2: Public Demos
- Embed in public pages using shortcode
- Great for tutorials, demos, documentation
- Visitors can interact without affecting your site

### Option 3: Subdomain (Advanced)
- Point `playground.leftlane.io` to GitHub Pages
- Separate URL for testing environment
- Professional setup for team use

See `EXISTING_WORDPRESS_INTEGRATION.md` for subdomain setup.

## 🔧 Customization

### Change Blueprint Configuration

In **Playground → Settings**, update the Blueprint URL to customize:
- WordPress version
- Pre-installed plugins
- Theme selection
- Site settings
- Auto-import content

Current blueprint:
```
https://chriswdixon.github.io/leftlane-wasm/blueprint.json
```

Edit this file to customize your Playground setup!

### Customize Appearance

The plugin includes CSS files you can modify:
```
wp-content/plugins/leftlane-playground/assets/css/style.css (frontend)
wp-content/plugins/leftlane-playground/assets/css/admin.css (admin)
```

## 🎯 Use Case Scenarios

### Scenario 1: Plugin Testing
**Before:** Install plugin → Hope it works → Fix issues on live site  
**Now:** Test in Playground → Verify it works → Install confidently

### Scenario 2: Content Training
**Before:** Train on live site → Risk breaking things  
**Now:** Train in Playground → No risk, full WordPress access

### Scenario 3: Theme Preview
**Before:** Activate on live site → See if you like it → Revert if not  
**Now:** Test in Playground → See exactly how it looks → Decide safely

### Scenario 4: Client Demos
**Before:** Setup demo site → Manage hosting → Keep it updated  
**Now:** Embed Playground → Instant demo → No maintenance

## 🔒 Security & Isolation

**Important:** WordPress Playground is **completely isolated** from your production site:

✅ Separate database (browser-based)  
✅ No access to production files  
✅ Can't affect live site  
✅ Changes only stored in user's browser  
✅ Perfect for safe testing

## 📊 What You Can Do

### In WordPress Playground:
- ✅ Create/edit posts and pages
- ✅ Install and test plugins
- ✅ Try different themes
- ✅ Change WordPress settings
- ✅ Import/export content
- ✅ Full WordPress admin access

### What You CAN'T Do:
- ❌ Access production database
- ❌ Affect live site
- ❌ Share changes across devices
- ❌ Use production media files (unless imported)

## 🎓 Next Steps

1. **Install the plugin** (3 minutes)
2. **Try it out** - Click Playground in admin menu
3. **Test something** - Install a plugin in Playground
4. **Embed it** - Add shortcode to a page
5. **Train your team** - Show them how to test safely

## 📚 Additional Resources

**In Your Repository:**
- `EXISTING_WORDPRESS_INTEGRATION.md` - Comprehensive integration guide
- `wordpress-plugin/README.md` - Plugin documentation
- `MIGRATION_GUIDE.md` - Full migration instructions
- `README.md` - Project overview

**Online:**
- WordPress Playground: https://wordpress.github.io/wordpress-playground/
- Your GitHub Repo: https://github.com/chriswdixon/leftlane-wasm
- Plugin Download: https://github.com/chriswdixon/leftlane-wasm/raw/main/wordpress-plugin/leftlane-playground.zip

## 🐛 Troubleshooting

**Plugin won't activate:**
- Check PHP version (needs 7.4+)
- Check WordPress version (needs 5.8+)
- Look for conflicts with other plugins

**Playground won't load:**
- Check internet connection
- Open browser console (F12) for errors
- Try different browser
- Clear browser cache

**Shortcode not working:**
- Verify plugin is active
- Check shortcode syntax
- Test in different post/page

**Need help?**
- Check `EXISTING_WORDPRESS_INTEGRATION.md`
- Review browser console errors
- Check WordPress error logs

## 🎉 You're Ready!

Your WordPress Playground plugin is ready to install on leftlane.io. Here's what to do:

1. **Download:** `/Users/chrisdixon/Documents/GitHub/leftlane-wasm/wordpress-plugin/leftlane-playground.zip`
2. **Install:** Upload to WordPress
3. **Activate:** Enable the plugin
4. **Use:** Click "Playground" in admin menu

---

## Quick Commands

```bash
# Copy plugin to desktop for easy access
cp /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wordpress-plugin/leftlane-playground.zip ~/Desktop/

# Or open in Finder
open /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wordpress-plugin/

# View on GitHub
open https://github.com/chriswdixon/leftlane-wasm/tree/main/wordpress-plugin
```

---

**Happy Testing! 🚀**

Your production site is safe, and you can now test anything risk-free!

