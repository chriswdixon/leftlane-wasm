# LeftLane.io - WordPress on WASM

This repository contains a GitHub-backed WordPress installation running on WebAssembly (WASM) using WordPress Playground.

## Overview

This setup uses WordPress Playground to run a complete WordPress site entirely in the browser using WebAssembly. The site is version-controlled via GitHub and can be deployed to GitHub Pages or any static hosting service.

## Features

- ✅ WordPress running entirely on WASM (no server required)
- ✅ Git-based version control for themes, plugins, and content
- ✅ Automatic deployment via GitHub Actions
- ✅ Content export/import from existing WordPress sites
- ✅ Portable and testable locally or in CI/CD

## Quick Start

### Local Development

1. Open `index.html` in your browser
2. WordPress Playground will automatically load with your configuration
3. Login with default credentials (see blueprint.json for details)

### Deployment

The site automatically deploys to GitHub Pages on push to the `main` branch.

Visit your site at: `https://[your-username].github.io/leftlane-wasm/`

## Repository Structure

```
leftlane-wasm/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions deployment workflow
├── wp-content/
│   ├── themes/                 # Your WordPress themes
│   ├── plugins/                # Your WordPress plugins
│   └── uploads/                # Media files (optional)
├── content/
│   └── export.xml              # WordPress export file from leftlane.io
├── blueprint.json              # WordPress Playground configuration
├── index.html                  # Entry point for WordPress Playground
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

## Migration from Existing WordPress Site

### Step 1: Export Content

1. Log in to your existing leftlane.io WordPress dashboard
2. Go to **Tools → Export**
3. Select "All content" and download the export file
4. Save it as `content/export.xml` in this repository

### Step 2: Export Themes and Plugins

Download your active theme and plugins from your current WordPress installation:

```bash
# From your existing WordPress installation
cd wp-content
zip -r themes.zip themes/your-active-theme
zip -r plugins.zip plugins/

# Extract to this repository
unzip themes.zip -d ./wp-content/
unzip plugins.zip -d ./wp-content/
```

### Step 3: Configure Blueprint

Edit `blueprint.json` to include your plugins and theme activation.

### Step 4: Import Content

Once WordPress Playground loads:
1. Go to **Tools → Import**
2. Install WordPress Importer
3. Upload `content/export.xml`
4. Map authors and import

## WordPress Playground Configuration

The `blueprint.json` file controls:
- PHP version
- WordPress version
- Pre-installed plugins
- Theme activation
- Content import
- Database setup

## Deployment Options

### Option 1: GitHub Pages (Recommended)

Already configured via `.github/workflows/deploy.yml`. Just push to `main`.

### Option 2: Netlify

1. Connect your GitHub repository to Netlify
2. Set build directory to root `/`
3. No build command needed (static files)

### Option 3: Vercel

1. Import GitHub repository in Vercel
2. Framework Preset: Other
3. Build Command: (leave empty)
4. Output Directory: `.`

## Custom Domain Setup

To use `leftlane.io` with this setup:

1. **For GitHub Pages:**
   - Add a `CNAME` file with your domain
   - Configure DNS:
     ```
     Type: CNAME
     Name: www
     Value: [your-username].github.io
     ```

2. **Update DNS A Records:**
   ```
   185.199.108.153
   185.199.109.153
   185.199.110.153
   185.199.111.153
   ```

## Limitations & Considerations

### Current Limitations
- WordPress Playground is primarily for development/testing
- Database is stored in browser localStorage (not persistent across devices)
- Some plugins may not work in WASM environment
- Performance may vary based on browser

### Production Considerations
For a production-ready site, consider:
- Using WordPress Playground with cloud storage backend
- Headless WordPress architecture (WordPress backend + static frontend)
- Traditional WordPress hosting with Git deployment

## Advanced Configuration

### Custom PHP.ini Settings

Add to `blueprint.json`:
```json
{
  "phpExtensionBundles": ["kitchen-sink"],
  "features": {
    "networking": true
  }
}
```

### Database Persistence

WordPress Playground uses IndexedDB for storage. For cross-device persistence, consider:
- Exporting/importing the database periodically
- Using WordPress Playground with a remote database adapter

## Resources

- [WordPress Playground Documentation](https://wordpress.github.io/wordpress-playground/)
- [Blueprint JSON Schema](https://wordpress.github.io/wordpress-playground/blueprints-api/)
- [WordPress Playground GitHub](https://github.com/WordPress/wordpress-playground)

## Support

For issues specific to this setup:
- Open an issue in this repository

For WordPress Playground issues:
- Visit [WordPress Playground GitHub Issues](https://github.com/WordPress/wordpress-playground/issues)

## License

This project structure is MIT licensed. WordPress itself is GPL licensed.

