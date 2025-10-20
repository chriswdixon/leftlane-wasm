=== LeftLane WordPress Playground Integration ===
Contributors: chriswdixon
Tags: playground, wasm, testing, development, staging
Requires at least: 5.8
Tested up to: 6.4
Stable tag: 1.0.0
Requires PHP: 7.4
License: MIT
License URI: https://opensource.org/licenses/MIT

Integrate WordPress Playground (WASM) for safe testing and interactive demos directly in your WordPress site.

== Description ==

WordPress Playground Integration brings the power of WordPress Playground (WebAssembly) to your existing WordPress site. Test changes, preview content, and create interactive demos without affecting your live site.

= Features =

* 🎮 **Safe Testing Environment** - Test plugins, themes, and content changes safely
* 🚀 **Zero Setup** - Works out of the box with sensible defaults
* 🎨 **Shortcode Support** - Easy embedding in posts and pages
* ⚙️ **Admin Integration** - Quick access from WordPress admin
* 📱 **Responsive** - Works on all devices and screen sizes
* 🔒 **Secure** - Completely isolated from your production site

= Use Cases =

* **Testing** - Test plugins and themes before installing on live site
* **Staging** - Preview content changes in safe environment
* **Demos** - Create interactive WordPress demonstrations
* **Training** - Teach WordPress without risking live site
* **Development** - Quick WordPress instance for testing

= How It Works =

WordPress Playground runs a complete WordPress installation in your browser using WebAssembly. It's completely isolated from your production site, so any changes made in the Playground won't affect your live site.

= Shortcode Usage =

Basic:
`[leftlane_playground]`

Custom height:
`[leftlane_playground height="600"]`

Full width, no border:
`[leftlane_playground height="800" width="100%" border="no"]`

Custom configuration:
`[leftlane_playground blueprint="https://your-blueprint-url.json"]`

= Admin Access =

After activation, you'll find:
* **Playground** menu in WordPress admin
* **Test in Playground** link in admin bar
* Settings page for configuration

= Requirements =

* Modern web browser with WebAssembly support
* Internet connection (for loading Playground)
* WordPress 5.8 or higher
* PHP 7.4 or higher

== Installation ==

1. Upload the plugin files to `/wp-content/plugins/leftlane-playground/`
2. Activate the plugin through the 'Plugins' screen
3. Go to Playground menu to start using
4. Configure settings under Playground → Settings

== Frequently Asked Questions ==

= Will this affect my live site? =

No. WordPress Playground runs entirely in the browser and is completely isolated from your production site.

= Do changes persist? =

Changes made in the Playground are stored in the browser's local storage. They're not permanent and won't sync across devices.

= Can I use my production database? =

No. Playground uses its own browser-based database for complete isolation and safety.

= What browsers are supported? =

All modern browsers that support WebAssembly: Chrome, Firefox, Safari, and Edge.

= Is it free? =

Yes! Both this plugin and WordPress Playground are free and open source.

= Can I customize the Playground configuration? =

Yes! You can provide a custom blueprint.json URL in the settings or shortcode.

== Screenshots ==

1. WordPress Playground in admin interface
2. Embedded playground using shortcode
3. Settings page
4. Admin bar quick access

== Changelog ==

= 1.0.0 =
* Initial release
* Shortcode support
* Admin integration
* Settings page
* Admin bar link

== Upgrade Notice ==

= 1.0.0 =
Initial release of WordPress Playground Integration.

== Credits ==

* WordPress Playground by WordPress.org
* Plugin by Chris Dixon
* LeftLane.io

== Support ==

For support, please visit:
* GitHub: https://github.com/chriswdixon/leftlane-wasm
* Website: https://leftlane.io

