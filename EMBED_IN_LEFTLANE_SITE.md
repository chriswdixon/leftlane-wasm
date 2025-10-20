# Embed WordPress Playground Inside Your LeftLane.io Site

You want a **page on leftlane.io** that shows WordPress Playground, and you want that Playground to look like your homepage.

## Super Simple Solution (5 Minutes)

### Step 1: Install the Plugin

You already have `leftlane-playground.zip` on your Desktop!

1. Go to **https://leftlane.io/wp-admin**
2. Navigate to **Plugins → Add New → Upload Plugin**
3. Choose `leftlane-playground.zip` from your Desktop
4. Click **Install Now**
5. Click **Activate Plugin**

### Step 2: Create a Page

1. Go to **Pages → Add New**
2. Title: "Try WordPress" (or whatever you want)
3. In the content, add this shortcode:
   ```
   [leftlane_playground height="900" border="no"]
   ```
4. Click **Publish**

### Step 3: Done!

Visit: **https://leftlane.io/try-wordpress/** (or whatever you named the page)

You'll see WordPress Playground running right inside your leftlane.io site!

---

## Make the Playground Look Like Your Homepage

The Playground will automatically use your GitHub configuration which already has:
- ✅ Your site title: "LeftLane.io"
- ✅ Your tagline: "Keeping You in the Fast Lane"  
- ✅ Similar professional theme (Astra)

Want it to look EXACTLY like your homepage? Follow the "Add Divi Theme" steps below.

---

## Full-Screen Experience (Optional)

Want the Playground to fill the entire browser like a full site?

### Use the Full-Screen Template

Create a file in your theme: `page-playground.php`

```php
<?php
/**
 * Template Name: Playground Full Screen
 */
?>
<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WordPress Playground - <?php bloginfo('name'); ?></title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            overflow: hidden;
        }
        #playground-container {
            width: 100vw;
            height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        #loading {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: white;
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
    </style>
</head>
<body>
    <div id="playground-container">
        <div id="loading">
            <h1><?php bloginfo('name'); ?></h1>
            <div class="spinner"></div>
            <p>Loading WordPress Playground...</p>
        </div>
    </div>

    <script type="module">
        (async () => {
            const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
            
            const container = document.getElementById('playground-container');
            const iframe = document.createElement('iframe');
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.border = 'none';
            
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
</body>
</html>
```

Then:
1. Create page with this template
2. Publish
3. Full-screen Playground!

---

## Make Playground Homepage Look Exactly Like Your Site

### Option 1: Quick Update (Use Current Setup)

Your GitHub blueprint already configured! Just update it with better settings:

**Edit your `blueprint.json` on GitHub to match your colors/fonts:**

```json
{
  "steps": [
    {
      "step": "setSiteOptions",
      "options": {
        "blogname": "LeftLane.io",
        "blogdescription": "Keeping You in the Fast Lane"
      }
    }
  ]
}
```

Commit and push - the plugin will use it automatically!

### Option 2: Add Your Divi Theme (Exact Match)

To make the Playground look EXACTLY like leftlane.io:

1. **Export Divi** from your site via FTP
2. **Add to GitHub** repository (follow previous guide)
3. **Push changes**
4. The embedded Playground will automatically use it!

---

## Different Use Cases

### Use Case 1: Demo Page
Create a page at `leftlane.io/demo` where visitors can try WordPress:

```
Page: "Try WordPress"
URL: leftlane.io/demo
Content: [leftlane_playground height="800"]
```

### Use Case 2: Testing Environment
Create a private page for your team:

```
Page: "Staging Environment" (set to private)
URL: leftlane.io/staging
Content: [leftlane_playground height="900" border="no"]
```

### Use Case 3: Training Center
Create a learning section:

```
Page: "WordPress Training"
URL: leftlane.io/training
Content: 
# Learn WordPress

Practice in this safe environment:

[leftlane_playground height="700"]

## Tutorial Steps:
1. Login with admin/password
2. Create your first post
3. Customize your site
```

### Use Case 4: Replace Homepage (If you really want)
Make Playground your actual homepage:

1. Create page with `[leftlane_playground height="900" border="no"]`
2. Go to **Settings → Reading**
3. Select **"A static page"**
4. Choose your Playground page as homepage
5. Your site homepage becomes the Playground!

---

## Shortcode Options

Customize the embedded Playground:

```
Basic:
[leftlane_playground]

Taller:
[leftlane_playground height="1000"]

Full width, no border:
[leftlane_playground height="900" width="100%" border="no"]

Custom blueprint:
[leftlane_playground blueprint="https://your-custom-blueprint.json"]
```

---

## Quick Summary

**What you actually want:**
1. Keep leftlane.io as-is
2. Add a page that shows WordPress Playground
3. That Playground page looks like your site

**How to do it:**
1. Install `leftlane-playground.zip` plugin (on your Desktop)
2. Create a page with `[leftlane_playground]` shortcode
3. Publish
4. Done!

**The Playground automatically pulls config from:**
`https://chriswdixon.github.io/leftlane-wasm/blueprint.json`

This config already has your:
- Site title
- Site tagline  
- Professional theme
- Good settings

**Want exact Divi match?**
Just add Divi theme to GitHub repo (previous guide) and it'll automatically use it!

---

## Test It Right Now

1. **Go to:** https://leftlane.io/wp-admin
2. **Upload plugin** from Desktop: `leftlane-playground.zip`
3. **Activate it**
4. **Create page** with shortcode: `[leftlane_playground]`
5. **View the page**

That's it! WordPress Playground running INSIDE your leftlane.io site.

---

## The GitHub repo is just for CONFIGURATION

The GitHub Pages site (`chriswdixon.github.io/leftlane-wasm`) is just storing:
- `blueprint.json` (configuration)
- `content/export.xml` (optional content)
- `Divi.zip` (optional theme)

Your plugin **embeds the Playground** on leftlane.io and tells it to use that configuration!

So:
- ✅ Your site stays at leftlane.io (unchanged)
- ✅ Playground runs ON a page in your site
- ✅ Config comes from GitHub (just settings)
- ✅ Visitors never leave leftlane.io

---

**Ready?** Install the plugin right now and create a page!

