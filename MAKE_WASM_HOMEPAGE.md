# Make WordPress Playground WASM the Homepage of Your Existing Site

This guide shows you how to embed WordPress Playground as the front page of your existing leftlane.io WordPress site.

## Overview

Your existing WordPress site stays at leftlane.io, but the homepage displays the WordPress Playground WASM instance. All other pages (blog posts, about, etc.) remain accessible.

---

## Method 1: Using the Plugin (Easiest - 2 Minutes)

### Step 1: Install the Plugin

If you haven't already:
1. Upload `leftlane-playground.zip` to your WordPress
2. Activate the plugin

### Step 2: Create a New Page

1. In WordPress admin, go to **Pages → Add New**
2. Title: "Home" (or anything you want)
3. In the content area, add the shortcode:
   ```
   [leftlane_playground height="900" border="no"]
   ```
4. Click **Publish**

### Step 3: Set as Homepage

1. Go to **Settings → Reading**
2. Under "Your homepage displays":
   - Select **"A static page"**
   - For "Homepage", select the page you just created
3. Click **Save Changes**

### Done! 

Visit https://leftlane.io and you'll see WordPress Playground as your homepage!

---

## Method 2: Full-Screen Homepage Template (Professional)

Create a custom page template that makes WordPress Playground fill the entire browser window.

### Step 1: Create Page Template

Add this file to your theme:

**File:** `wp-content/themes/your-theme/page-playground-home.php`

```php
<?php
/**
 * Template Name: Playground Full Screen
 * Description: Full-screen WordPress Playground homepage
 */
?>
<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php bloginfo('name'); ?> - <?php bloginfo('description'); ?></title>
    <?php wp_head(); ?>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            overflow: hidden;
        }
        
        #playground-fullscreen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        #playground-loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: white;
            text-align: center;
        }
        
        #playground-loading h1 {
            font-size: 3rem;
            font-weight: 300;
            margin-bottom: 1rem;
        }
        
        .spinner {
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top: 4px solid white;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin-bottom: 1rem;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        #playground-iframe {
            display: none;
            width: 100%;
            height: 100%;
            border: none;
        }
        
        #playground-iframe.loaded {
            display: block;
        }
        
        /* Optional: Header/Menu Bar */
        #site-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.95);
            padding: 1rem 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        #site-header h1 {
            font-size: 1.5rem;
            margin: 0;
        }
        
        #site-header nav a {
            margin-left: 1.5rem;
            text-decoration: none;
            color: #333;
            font-weight: 500;
        }
        
        #site-header nav a:hover {
            color: #667eea;
        }
        
        /* Adjust playground position if header is shown */
        body.with-header #playground-fullscreen {
            top: 70px;
            height: calc(100vh - 70px);
        }
    </style>
</head>
<body <?php body_class(); ?>>

    <!-- Optional: Uncomment to show site header/menu -->
    <!--
    <div id="site-header">
        <h1><?php bloginfo('name'); ?></h1>
        <nav>
            <a href="<?php echo home_url('/about'); ?>">About</a>
            <a href="<?php echo home_url('/blog'); ?>">Blog</a>
            <a href="<?php echo home_url('/contact'); ?>">Contact</a>
        </nav>
    </div>
    -->

    <div id="playground-fullscreen">
        <div id="playground-loading">
            <h1><?php bloginfo('name'); ?></h1>
            <div class="spinner"></div>
            <p>Loading WordPress Playground...</p>
            <small>This may take 10-20 seconds</small>
        </div>
        <iframe id="playground-iframe"></iframe>
    </div>

    <script type="module">
        (async () => {
            const iframe = document.getElementById('playground-iframe');
            const loading = document.getElementById('playground-loading');
            
            try {
                // Load WordPress Playground client
                const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
                
                // Fetch blueprint
                const blueprintUrl = 'https://chriswdixon.github.io/leftlane-wasm/blueprint.json';
                const response = await fetch(blueprintUrl);
                const blueprint = await response.json();
                
                // Start WordPress Playground
                await startPlaygroundWeb({
                    iframe: iframe,
                    remoteUrl: 'https://playground.wordpress.net/remote.html',
                    blueprint: blueprint
                });
                
                // Hide loading, show iframe
                loading.style.display = 'none';
                iframe.classList.add('loaded');
                
            } catch (error) {
                console.error('Error loading Playground:', error);
                loading.innerHTML = '<p style="color: #ffcccc;">Error loading WordPress Playground. Please refresh.</p>';
            }
        })();
    </script>

    <?php wp_footer(); ?>
</body>
</html>
```

### Step 2: Create Page with Template

1. Go to **Pages → Add New**
2. Title: "Home"
3. In the right sidebar, under "Page Attributes"
4. Select **Template: "Playground Full Screen"**
5. Publish the page (content doesn't matter, the template controls display)

### Step 3: Set as Homepage

1. Go to **Settings → Reading**
2. Select **"A static page"**
3. Set "Homepage" to your new page
4. Click **Save Changes**

### Optional: Add Header/Menu

Uncomment this section in the template to show your site navigation:

```php
<div id="site-header">
    <h1><?php bloginfo('name'); ?></h1>
    <nav>
        <a href="<?php echo home_url('/about'); ?>">About</a>
        <a href="<?php echo home_url('/blog'); ?>">Blog</a>
        <a href="<?php echo home_url('/contact'); ?>">Contact</a>
    </nav>
</div>
```

And add this to body tag:
```php
<body <?php body_class('with-header'); ?>>
```

---

## Method 3: Direct Theme Integration

Modify your theme's homepage template directly.

### Option A: Edit front-page.php

If your theme has `front-page.php`:

**File:** `wp-content/themes/your-theme/front-page.php`

Replace the entire file content with:

```php
<?php get_header(); ?>

<div id="playground-container" style="width: 100%; height: 800px; margin: 2rem 0;">
    <div class="loading" style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px;">
        <div style="border: 4px solid rgba(255,255,255,0.3); border-radius: 50%; border-top: 4px solid white; width: 50px; height: 50px; animation: spin 1s linear infinite;"></div>
        <p style="color: white; margin-top: 1rem;">Loading WordPress Playground...</p>
    </div>
</div>

<script type="module">
    (async () => {
        const container = document.getElementById('playground-container');
        const iframe = document.createElement('iframe');
        iframe.style.width = '100%';
        iframe.style.height = '800px';
        iframe.style.border = '2px solid #ddd';
        iframe.style.borderRadius = '8px';
        
        const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
        
        const response = await fetch('https://chriswdixon.github.io/leftlane-wasm/blueprint.json');
        const blueprint = await response.json();
        
        container.innerHTML = '';
        container.appendChild(iframe);
        
        await startPlaygroundWeb({
            iframe: iframe,
            remoteUrl: 'https://playground.wordpress.net/remote.html',
            blueprint: blueprint
        });
    })();
</script>

<style>
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>

<?php get_footer(); ?>
```

### Option B: Edit home.php

Same as above, but edit `home.php` instead.

### Option C: Edit index.php

For homepage only, wrap in a conditional:

```php
<?php get_header(); ?>

<?php if (is_front_page()) : ?>
    <!-- WordPress Playground on homepage only -->
    <div id="playground-container" style="width: 100%; height: 800px;">
        <!-- Same code as above -->
    </div>
<?php else : ?>
    <!-- Regular content for other pages -->
    <?php 
    if (have_posts()) :
        while (have_posts()) : the_post();
            the_content();
        endwhile;
    endif;
    ?>
<?php endif; ?>

<?php get_footer(); ?>
```

---

## Method 4: Using a Page Builder

If you use Elementor, Divi, or another page builder:

### Elementor

1. Create new page
2. Edit with Elementor
3. Add **HTML widget**
4. Paste this code:

```html
<div id="playground-elem" style="width: 100%; height: 800px; border: 2px solid #ddd; border-radius: 8px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white;">
    <div>
        <div style="border: 4px solid rgba(255,255,255,0.3); border-radius: 50%; border-top: 4px solid white; width: 50px; height: 50px; animation: spin 1s linear infinite; margin: 0 auto 1rem;"></div>
        <p>Loading WordPress Playground...</p>
    </div>
</div>

<script type="module">
    (async () => {
        const container = document.getElementById('playground-elem');
        const iframe = document.createElement('iframe');
        iframe.style.width = '100%';
        iframe.style.height = '800px';
        iframe.style.border = 'none';
        
        const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
        const response = await fetch('https://chriswdixon.github.io/leftlane-wasm/blueprint.json');
        const blueprint = await response.json();
        
        container.innerHTML = '';
        container.appendChild(iframe);
        
        await startPlaygroundWeb({
            iframe: iframe,
            remoteUrl: 'https://playground.wordpress.net/remote.html',
            blueprint: blueprint
        });
    })();
</script>

<style>
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>
```

5. Set page as homepage in Settings → Reading

### Divi

1. Create new page
2. Use Divi Builder
3. Add **Code module**
4. Paste the same HTML code above
5. Set as homepage

---

## Method 5: Simple iframe Embed (Quick & Easy)

Just want something working fast? Create a page with this:

1. Go to **Pages → Add New**
2. Switch to **Text/HTML editor** (not Visual)
3. Paste this:

```html
<div style="width: 100%; height: 100vh; margin: 0; padding: 0;">
    <iframe 
        src="https://chriswdixon.github.io/leftlane-wasm/" 
        width="100%" 
        height="100%" 
        style="border: none; display: block;"
        title="WordPress Playground">
    </iframe>
</div>

<style>
    body {
        margin: 0 !important;
        padding: 0 !important;
    }
    #main, #content, .entry-content {
        padding: 0 !important;
        margin: 0 !important;
    }
</style>
```

4. Publish
5. Set as homepage in Settings → Reading

---

## Recommended Approach

**I recommend Method 1** (using the plugin with shortcode) because:

✅ **Easiest to implement** (2 minutes)  
✅ **No code changes** to your theme  
✅ **Easy to customize** (just change shortcode attributes)  
✅ **Easy to revert** (just change homepage setting)  
✅ **Works with any theme**

---

## Quick Start (2 Minutes)

```bash
# 1. Install plugin (if not already)
# Upload leftlane-playground.zip and activate

# 2. Create homepage page
# - Pages → Add New
# - Add: [leftlane_playground height="900" border="no"]
# - Publish

# 3. Set as homepage
# - Settings → Reading
# - Select "A static page"
# - Choose your new page
# - Save
```

Done! WordPress Playground is now your homepage.

---

## Customization Options

### Height Options

```
[leftlane_playground height="600"]  ← Shorter
[leftlane_playground height="900"]  ← Taller
[leftlane_playground height="1200"] ← Very tall
```

### Full Page Width

```
[leftlane_playground height="900" width="100%" border="no"]
```

### Custom Blueprint

```
[leftlane_playground blueprint="https://your-custom-blueprint.json"]
```

---

## What Visitors Will See

When someone visits leftlane.io:

1. **Your Site Loads** (WordPress with your theme)
2. **Homepage Shows** WordPress Playground loading
3. **Playground Initializes** (10-20 seconds first time)
4. **Full WordPress Available** for visitors to interact with

**Other Pages:** All your other pages (About, Blog, Contact, etc.) remain unchanged and accessible via your menu.

---

## Keeping Your Menu/Navigation

WordPress Playground as homepage doesn't remove your menu. Visitors can still:
- See your site navigation
- Click to other pages (About, Blog, etc.)
- Return to homepage to see Playground

This is the beauty of Method 1 - it integrates seamlessly!

---

## Testing

After setup:
1. Visit https://leftlane.io (logged out)
2. You should see WordPress Playground loading
3. Test navigation to other pages
4. Confirm everything still works

---

## Troubleshooting

**Playground not loading:**
- Check plugin is activated
- Verify shortcode syntax
- Check browser console (F12) for errors

**Page looks broken:**
- Some themes add extra padding/margins
- Try the full-screen template (Method 2)
- Or add custom CSS to remove padding

**Menu not showing:**
- Check your theme settings
- Verify menu is assigned to primary location
- Some themes hide menu on certain pages

---

## Want to See It First?

Test it on a staging/development page before making it your homepage:

1. Create page with shortcode
2. Publish but DON'T set as homepage yet
3. Visit the page URL to see how it looks
4. Once happy, set it as homepage

---

Ready to implement? I recommend starting with **Method 1** - it's the quickest and easiest!

