# Integrating WordPress Playground WASM with Existing WordPress Site

This guide shows you how to use WordPress Playground (WASM) alongside your existing leftlane.io WordPress installation.

## Use Cases

### 1. **Staging/Testing Environment**
Test changes before applying to production

### 2. **Interactive Demos**
Let visitors try WordPress features on your site

### 3. **Content Preview**
Preview content changes in a safe environment

### 4. **Plugin/Theme Testing**
Test plugins and themes without affecting your live site

## Integration Methods

---

## Method 1: Embed WordPress Playground in Your Site

### Basic Embed (Simple Demo)

Add this to any WordPress page or post (use HTML block):

```html
<!-- Simple WordPress Playground Embed -->
<div class="wp-playground-embed">
  <iframe 
    src="https://playground.wordpress.net/" 
    width="100%" 
    height="800"
    frameborder="0"
    style="border: 2px solid #ddd; border-radius: 8px;">
  </iframe>
</div>
```

### Customized Embed (With Your Content)

```html
<!-- WordPress Playground with Blueprint -->
<div class="wp-playground-embed">
  <iframe 
    src="https://playground.wordpress.net/#https://chriswdixon.github.io/leftlane-wasm/blueprint.json" 
    width="100%" 
    height="800"
    frameborder="0">
  </iframe>
</div>
```

### Advanced Embed (Full Control)

```html
<!-- Custom WordPress Playground with Your Data -->
<div id="playground-container" style="width: 100%; height: 800px;"></div>

<script type="module">
  import { startPlaygroundWeb } from 'https://playground.wordpress.net/client/index.js';

  const container = document.getElementById('playground-container');
  const iframe = document.createElement('iframe');
  iframe.style.width = '100%';
  iframe.style.height = '100%';
  iframe.style.border = '2px solid #ddd';
  iframe.style.borderRadius = '8px';
  container.appendChild(iframe);

  // Fetch your blueprint from GitHub
  const blueprint = await fetch('https://chriswdixon.github.io/leftlane-wasm/blueprint.json')
    .then(res => res.json());

  // Start WordPress Playground with your config
  const client = await startPlaygroundWeb({
    iframe: iframe,
    remoteUrl: 'https://playground.wordpress.net/remote.html',
    blueprint: blueprint
  });

  console.log('WordPress Playground loaded with your configuration!');
</script>
```

---

## Method 2: WordPress Plugin for WASM Integration

Create a custom WordPress plugin to manage the Playground integration.

### Step 1: Create Plugin File

Save as `wp-content/plugins/leftlane-playground/leftlane-playground.php`:

```php
<?php
/**
 * Plugin Name: LeftLane WordPress Playground
 * Plugin URI: https://github.com/chriswdixon/leftlane-wasm
 * Description: Integrates WordPress Playground (WASM) into your site for testing and demos
 * Version: 1.0.0
 * Author: Chris Dixon
 * License: MIT
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class LeftLane_Playground {
    
    private $blueprint_url = 'https://chriswdixon.github.io/leftlane-wasm/blueprint.json';
    
    public function __construct() {
        // Add shortcode for embedding playground
        add_shortcode('leftlane_playground', array($this, 'render_playground'));
        
        // Add admin menu
        add_action('admin_menu', array($this, 'add_admin_menu'));
        
        // Enqueue scripts
        add_action('wp_enqueue_scripts', array($this, 'enqueue_scripts'));
    }
    
    /**
     * Render the WordPress Playground
     */
    public function render_playground($atts) {
        $atts = shortcode_atts(array(
            'height' => '800',
            'width' => '100%',
            'blueprint' => $this->blueprint_url,
        ), $atts);
        
        ob_start();
        ?>
        <div class="leftlane-playground-container" 
             data-blueprint="<?php echo esc_attr($atts['blueprint']); ?>"
             style="width: <?php echo esc_attr($atts['width']); ?>; height: <?php echo esc_attr($atts['height']); ?>px;">
            <div class="loading">
                <p>Loading WordPress Playground...</p>
            </div>
        </div>
        <?php
        return ob_get_clean();
    }
    
    /**
     * Enqueue necessary scripts
     */
    public function enqueue_scripts() {
        wp_enqueue_style(
            'leftlane-playground',
            plugins_url('style.css', __FILE__),
            array(),
            '1.0.0'
        );
        
        wp_enqueue_script(
            'leftlane-playground',
            plugins_url('script.js', __FILE__),
            array(),
            '1.0.0',
            true
        );
    }
    
    /**
     * Add admin menu
     */
    public function add_admin_menu() {
        add_menu_page(
            'WordPress Playground',
            'Playground',
            'manage_options',
            'leftlane-playground',
            array($this, 'render_admin_page'),
            'dashicons-admin-site',
            30
        );
    }
    
    /**
     * Render admin page
     */
    public function render_admin_page() {
        ?>
        <div class="wrap">
            <h1>WordPress Playground (WASM)</h1>
            <p>Test changes in a safe environment before applying to your live site.</p>
            
            <div id="playground-admin-container" style="width: 100%; height: 800px; margin-top: 20px;"></div>
            
            <script type="module">
                import { startPlaygroundWeb } from 'https://playground.wordpress.net/client/index.js';
                
                const container = document.getElementById('playground-admin-container');
                const iframe = document.createElement('iframe');
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.border = '1px solid #ccc';
                container.appendChild(iframe);
                
                const response = await fetch('<?php echo esc_js($this->blueprint_url); ?>');
                const blueprint = await response.json();
                
                await startPlaygroundWeb({
                    iframe: iframe,
                    remoteUrl: 'https://playground.wordpress.net/remote.html',
                    blueprint: blueprint
                });
            </script>
        </div>
        <?php
    }
}

// Initialize plugin
new LeftLane_Playground();
```

### Step 2: Create Plugin CSS

Save as `wp-content/plugins/leftlane-playground/style.css`:

```css
.leftlane-playground-container {
    position: relative;
    border: 2px solid #ddd;
    border-radius: 8px;
    overflow: hidden;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.leftlane-playground-container .loading {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: white;
    font-size: 1.2rem;
}

.leftlane-playground-container iframe {
    width: 100%;
    height: 100%;
    border: none;
}
```

### Step 3: Create Plugin JavaScript

Save as `wp-content/plugins/leftlane-playground/script.js`:

```javascript
(async function() {
    const containers = document.querySelectorAll('.leftlane-playground-container');
    
    if (containers.length === 0) return;
    
    // Load WordPress Playground client
    const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
    
    for (const container of containers) {
        const blueprintUrl = container.dataset.blueprint;
        
        // Create iframe
        const iframe = document.createElement('iframe');
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.border = 'none';
        
        // Replace loading with iframe
        container.innerHTML = '';
        container.appendChild(iframe);
        
        try {
            // Fetch blueprint
            const response = await fetch(blueprintUrl);
            const blueprint = await response.json();
            
            // Start WordPress Playground
            await startPlaygroundWeb({
                iframe: iframe,
                remoteUrl: 'https://playground.wordpress.net/remote.html',
                blueprint: blueprint
            });
        } catch (error) {
            container.innerHTML = '<p style="color: red;">Error loading WordPress Playground</p>';
            console.error('Playground error:', error);
        }
    }
})();
```

### Step 4: Use the Shortcode

In any WordPress page or post:

```
[leftlane_playground height="800" width="100%"]
```

Or with custom blueprint:

```
[leftlane_playground height="600" blueprint="https://your-custom-blueprint.json"]
```

---

## Method 3: Subdomain Setup (Recommended for Production)

Set up WordPress Playground on a subdomain for testing.

### Step 1: Configure DNS

Add a CNAME record:
```
Type: CNAME
Name: playground
Value: chriswdixon.github.io
```

### Step 2: Update CNAME File

```bash
cd /Users/chrisdixon/Documents/GitHub/leftlane-wasm
echo "playground.leftlane.io" > CNAME
git add CNAME
git commit -m "Configure playground subdomain"
git push
```

### Step 3: Access Your Playground

After DNS propagation (24-48 hours):
```
https://playground.leftlane.io
```

### Step 4: Link from Main Site

Add a link in your WordPress admin menu or header:

```php
// In your theme's functions.php
add_action('admin_bar_menu', function($wp_admin_bar) {
    $wp_admin_bar->add_node(array(
        'id' => 'playground',
        'title' => 'Test in Playground',
        'href' => 'https://playground.leftlane.io',
        'meta' => array(
            'target' => '_blank',
            'class' => 'playground-link'
        )
    ));
}, 100);
```

---

## Method 4: Sync Content to Playground

Automatically export your site content and import it into the Playground.

### Step 1: Export Automation Script

Save as `export-to-playground.sh`:

```bash
#!/bin/bash

# WordPress site details
WP_PATH="/path/to/your/wordpress"
PLAYGROUND_PATH="/Users/chrisdixon/Documents/GitHub/leftlane-wasm"

# Export content
cd $WP_PATH
wp export --path=$WP_PATH --dir="$PLAYGROUND_PATH/content" --filename_format="export.xml"

# Copy active theme
ACTIVE_THEME=$(wp theme list --status=active --field=name --path=$WP_PATH)
cp -r "$WP_PATH/wp-content/themes/$ACTIVE_THEME" "$PLAYGROUND_PATH/wp-content/themes/"

# Copy active plugins
wp plugin list --status=active --field=name --path=$WP_PATH | while read plugin; do
    cp -r "$WP_PATH/wp-content/plugins/$plugin" "$PLAYGROUND_PATH/wp-content/plugins/"
done

# Commit and push
cd $PLAYGROUND_PATH
git add .
git commit -m "Sync content from production - $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "Content synced to WordPress Playground!"
```

Make it executable:
```bash
chmod +x export-to-playground.sh
```

### Step 2: Create a Cron Job

Run sync daily at midnight:

```bash
crontab -e
```

Add:
```
0 0 * * * /path/to/export-to-playground.sh
```

---

## Method 5: WordPress Admin Integration

Add a Playground button directly in your WordPress admin.

### Add to functions.php:

```php
/**
 * Add WordPress Playground button to admin bar
 */
add_action('admin_bar_menu', function($admin_bar) {
    $admin_bar->add_menu(array(
        'id'    => 'wp-playground',
        'parent' => null,
        'group'  => null,
        'title' => '<span class="ab-icon dashicons-before dashicons-admin-site"></span> Test in Playground',
        'href'  => '#',
        'meta' => array(
            'title' => 'Open WordPress Playground',
            'onclick' => 'openPlaygroundModal(); return false;',
        ),
    ));
}, 100);

/**
 * Add Playground modal JavaScript
 */
add_action('admin_footer', function() {
    ?>
    <div id="playground-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 999999;">
        <div style="width: 90%; height: 90%; margin: 5% auto; background: white; border-radius: 8px; overflow: hidden;">
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 15px; background: #0073aa; color: white;">
                <h2 style="margin: 0; color: white;">WordPress Playground - Safe Testing Environment</h2>
                <button onclick="closePlaygroundModal()" style="background: transparent; border: none; color: white; font-size: 24px; cursor: pointer;">&times;</button>
            </div>
            <iframe id="playground-iframe" src="" width="100%" height="calc(100% - 60px)" frameborder="0"></iframe>
        </div>
    </div>

    <script>
        function openPlaygroundModal() {
            const modal = document.getElementById('playground-modal');
            const iframe = document.getElementById('playground-iframe');
            
            if (!iframe.src) {
                iframe.src = 'https://chriswdixon.github.io/leftlane-wasm/';
            }
            
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closePlaygroundModal() {
            const modal = document.getElementById('playground-modal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        // Close on escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closePlaygroundModal();
            }
        });
    </script>
    <?php
}, 100);
```

---

## Use Case Examples

### Example 1: Testing Before Publishing

```html
<!-- Add to your post editor -->
<div class="playground-testing">
    <h3>Preview This Content in Playground</h3>
    <p>Test how this post looks before publishing:</p>
    [leftlane_playground height="600"]
</div>
```

### Example 2: Plugin Demo Page

Create a page showcasing a plugin using Playground:

```html
<h2>Try Our Plugin</h2>
<p>Experience our WordPress plugin in action:</p>

<iframe 
    src="https://playground.wordpress.net/?plugin=your-plugin-slug" 
    width="100%" 
    height="800"
    style="border: 2px solid #ddd; border-radius: 8px;">
</iframe>
```

### Example 3: Training/Documentation

Create interactive WordPress tutorials:

```html
<h2>WordPress Tutorial</h2>
<p>Follow along in this live WordPress instance:</p>

[leftlane_playground height="700"]

<div class="tutorial-steps">
    <h3>Steps:</h3>
    <ol>
        <li>Login with admin/password</li>
        <li>Go to Posts → Add New</li>
        <li>Create your first post</li>
    </ol>
</div>
```

---

## Comparison: GitHub Pages vs Existing Site

| Feature | GitHub Pages (Separate) | Embedded in Site |
|---------|------------------------|------------------|
| Independence | ✅ Fully separate | ❌ Depends on main site |
| Performance | ✅ Better | ⚠️ Good |
| Maintenance | ✅ Easier | ⚠️ More complex |
| Integration | ❌ Manual | ✅ Seamless |
| Cost | ✅ Free | ✅ Free |
| Custom Domain | ✅ Yes | ✅ Yes (subdomain) |

---

## Recommendations

### For Testing/Staging: Method 3 (Subdomain)
- Clean separation
- Easy to access
- Professional setup

### For Demos: Method 1 (Embed)
- Simple to implement
- Great for visitors
- Interactive experience

### For Team Use: Method 5 (Admin Integration)
- Convenient for editors
- No navigation needed
- Safe testing

### For Automation: Method 4 (Sync)
- Always up-to-date
- Reduces manual work
- Consistent with production

---

## Security Considerations

1. **Playground is Isolated**: Changes in Playground don't affect your live site
2. **No Database Access**: Playground can't access your production database
3. **Temporary Storage**: Playground uses browser storage (not permanent)
4. **Safe for Testing**: Perfect for testing plugins, themes, and content

---

## Next Steps

1. Choose your integration method
2. Implement using the code above
3. Test the integration
4. Train your team on using the Playground
5. Set up automated syncing (optional)

---

## Questions?

- **Q: Will Playground changes affect my live site?**
  A: No, Playground is completely isolated

- **Q: Can I use my production database?**
  A: No, Playground uses its own browser-based database

- **Q: How do I sync content?**
  A: Use Method 4 (automated export/import)

- **Q: Can visitors see the Playground?**
  A: Only if you embed it (Method 1) or share the link

- **Q: Is it secure?**
  A: Yes, Playground runs in the browser and can't access your server

---

**Ready to integrate?** Choose a method above and start testing safely!

