# WordPress Playground Integration Plugin

This plugin integrates WordPress Playground (WASM) into your existing leftlane.io WordPress site.

## Quick Install

### Method 1: Upload Plugin (Recommended)

1. Create a zip file of the plugin:
   ```bash
   cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm/wordpress-plugin
   zip -r leftlane-playground.zip leftlane-playground/
   ```

2. In your WordPress admin:
   - Go to **Plugins → Add New**
   - Click **Upload Plugin**
   - Choose `leftlane-playground.zip`
   - Click **Install Now**
   - Click **Activate Plugin**

### Method 2: FTP/SFTP Upload

1. Upload the `leftlane-playground` folder to your WordPress site:
   ```
   /wp-content/plugins/leftlane-playground/
   ```

2. In WordPress admin:
   - Go to **Plugins**
   - Find "LeftLane WordPress Playground Integration"
   - Click **Activate**

### Method 3: WP-CLI

```bash
# On your WordPress server
wp plugin install /path/to/leftlane-playground.zip --activate
```

## Features

✅ **Admin Integration** - Access Playground from WordPress admin  
✅ **Shortcode Support** - Embed in posts/pages with `[leftlane_playground]`  
✅ **Admin Bar Link** - Quick access to testing environment  
✅ **Customizable** - Configure height, blueprint URL, and more  
✅ **Safe Testing** - Completely isolated from production site

## Usage

### In WordPress Admin

After activation:
1. Look for **Playground** in the admin menu
2. Click to open the testing environment
3. Login with: admin / password

### In Posts/Pages

Use the shortcode:

```
[leftlane_playground]
```

With custom options:

```
[leftlane_playground height="600" border="no"]
```

### Admin Bar Quick Access

Click **"Test in Playground"** in the admin bar to quickly open the testing environment.

## Configuration

Go to **Playground → Settings** to configure:

- **Blueprint URL**: URL to your WordPress Playground configuration
- **Default Height**: Height for embedded playgrounds
- **Show in Admin Bar**: Toggle admin bar link

## Shortcode Reference

| Attribute | Description | Default | Example |
|-----------|-------------|---------|---------|
| `height` | Height in pixels | 800 | `height="600"` |
| `width` | Width (px or %) | 100% | `width="90%"` |
| `border` | Show border | yes | `border="no"` |
| `blueprint` | Custom blueprint URL | Your GitHub blueprint | `blueprint="https://..."` |

## Examples

### Basic Embed
```
[leftlane_playground]
```

### Custom Height
```
[leftlane_playground height="600"]
```

### Full Width, No Border
```
[leftlane_playground height="800" width="100%" border="no"]
```

### Custom Configuration
```
[leftlane_playground blueprint="https://chriswdixon.github.io/leftlane-wasm/blueprint.json"]
```

## Use Cases

### 1. Testing Before Publishing
Test content or design changes before they go live:
```
## Preview This Post

Test how this content looks:
[leftlane_playground height="600"]
```

### 2. Interactive Tutorials
Create WordPress training content:
```
## Learn WordPress

Follow along in this live environment:
[leftlane_playground]

### Steps:
1. Login with admin/password
2. Go to Posts → Add New
3. Create your first post
```

### 3. Plugin/Theme Demos
Showcase your products:
```
## Try Our Theme

Experience our theme in action:
[leftlane_playground height="700"]
```

### 4. Safe Testing Environment
Test before applying to production:
- Try new plugins
- Test theme customizations
- Preview content changes
- Experiment with settings

## Technical Details

- **WordPress Version Required**: 5.8+
- **PHP Version Required**: 7.4+
- **Browser Support**: All modern browsers with WebAssembly
- **Database**: Browser-based (IndexedDB), isolated from production
- **Network**: Requires internet connection to load Playground

## FAQ

**Q: Will this affect my live site?**  
A: No, WordPress Playground is completely isolated.

**Q: Are changes persistent?**  
A: Changes are stored in browser localStorage (not shared across devices).

**Q: Can multiple users share a Playground?**  
A: Each user gets their own instance in their browser.

**Q: What's the performance like?**  
A: Initial load takes 10-20 seconds, then it's fast.

**Q: Can I use my production data?**  
A: No, but you can export/import content via XML.

## Troubleshooting

**Playground won't load:**
- Check your internet connection
- Open browser console (F12) for errors
- Try a different browser
- Clear browser cache

**Shortcode not working:**
- Ensure plugin is activated
- Check shortcode syntax
- Try in a different post/page

**Settings not saving:**
- Check user permissions (need admin)
- Look for PHP errors in error logs

## Support

- **GitHub**: https://github.com/chriswdixon/leftlane-wasm
- **Documentation**: See EXISTING_WORDPRESS_INTEGRATION.md
- **Website**: https://leftlane.io

## Credits

- **WordPress Playground**: WordPress.org
- **Plugin Development**: Chris Dixon
- **License**: MIT

## Version History

### 1.0.0 (2025-10-20)
- Initial release
- Shortcode support
- Admin page integration
- Settings management
- Admin bar link

---

**Ready to use!** Install the plugin and start testing safely.

