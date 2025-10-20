# Content Migration

## Export from Existing WordPress Site

To export your content from leftlane.io:

1. Log in to your WordPress admin panel at `https://leftlane.io/wp-admin`
2. Navigate to **Tools → Export**
3. Select "All content"
4. Click "Download Export File"
5. Save the file as `export.xml` in this directory

## What Gets Exported

The WordPress export file includes:
- Posts
- Pages
- Comments
- Custom fields
- Categories
- Tags
- Custom taxonomies
- Navigation menus
- Featured images (metadata, not files)

## What Doesn't Get Exported

You'll need to manually migrate:
- Theme files (from `wp-content/themes/`)
- Plugin files (from `wp-content/plugins/`)
- Uploaded media files (from `wp-content/uploads/`)
- Theme customizer settings
- Widget configurations
- Some plugin data

## Import to WordPress Playground

Once WordPress Playground is running:

1. Open the site in your browser
2. Log in with credentials from `blueprint.json` (admin/password)
3. Go to **Tools → Import**
4. Click "WordPress" and install the importer
5. Upload your `export.xml` file
6. Choose to download and import file attachments
7. Assign authors or create new ones
8. Click "Submit"

## Alternative: Import via Blueprint

You can also configure the blueprint to automatically import content on startup.

Add this step to `blueprint.json`:

```json
{
  "step": "importWxr",
  "file": {
    "resource": "url",
    "url": "https://[your-username].github.io/leftlane-wasm/content/export.xml"
  }
}
```

## Media Files

For uploaded media:

1. Download your `wp-content/uploads/` directory from leftlane.io
2. Place it in `wp-content/uploads/` in this repository
3. Commit and push to GitHub
4. Update blueprint.json to copy files to the correct location

## Database Export (Optional)

If you need a database backup:

```bash
# On your existing WordPress server
mysqldump -u [username] -p [database_name] > database_backup.sql
```

Store this outside the repository for security reasons.

