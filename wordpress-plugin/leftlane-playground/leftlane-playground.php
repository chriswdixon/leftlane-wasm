<?php
/**
 * Plugin Name: LeftLane WordPress Playground Integration
 * Plugin URI: https://github.com/chriswdixon/leftlane-wasm
 * Description: Integrates WordPress Playground (WASM) for safe testing and interactive demos
 * Version: 1.0.0
 * Author: Chris Dixon
 * Author URI: https://leftlane.io
 * License: MIT
 * Text Domain: leftlane-playground
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit('Direct access not permitted.');
}

/**
 * Main Plugin Class
 */
class LeftLane_Playground_Integration {
    
    /**
     * Plugin version
     */
    const VERSION = '1.0.0';
    
    /**
     * Blueprint URL
     */
    private $blueprint_url = 'https://chriswdixon.github.io/leftlane-wasm/blueprint.json';
    
    /**
     * Constructor
     */
    public function __construct() {
        // Activation/Deactivation hooks
        register_activation_hook(__FILE__, array($this, 'activate'));
        register_deactivation_hook(__FILE__, array($this, 'deactivate'));
        
        // Initialize plugin
        add_action('plugins_loaded', array($this, 'init'));
    }
    
    /**
     * Initialize plugin
     */
    public function init() {
        // Add shortcodes
        add_shortcode('leftlane_playground', array($this, 'render_playground_shortcode'));
        add_shortcode('playground', array($this, 'render_playground_shortcode'));
        
        // Add admin menu
        add_action('admin_menu', array($this, 'add_admin_menu'));
        
        // Add admin bar link
        add_action('admin_bar_menu', array($this, 'add_admin_bar_link'), 100);
        
        // Enqueue scripts and styles
        add_action('wp_enqueue_scripts', array($this, 'enqueue_frontend_assets'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_assets'));
        
        // Add settings
        add_action('admin_init', array($this, 'register_settings'));
    }
    
    /**
     * Activation hook
     */
    public function activate() {
        add_option('leftlane_playground_blueprint_url', $this->blueprint_url);
        add_option('leftlane_playground_default_height', '800');
        flush_rewrite_rules();
    }
    
    /**
     * Deactivation hook
     */
    public function deactivate() {
        flush_rewrite_rules();
    }
    
    /**
     * Register settings
     */
    public function register_settings() {
        register_setting('leftlane_playground_settings', 'leftlane_playground_blueprint_url');
        register_setting('leftlane_playground_settings', 'leftlane_playground_default_height');
        register_setting('leftlane_playground_settings', 'leftlane_playground_show_admin_bar');
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
            'dashicons-admin-site-alt3',
            30
        );
        
        add_submenu_page(
            'leftlane-playground',
            'Playground Settings',
            'Settings',
            'manage_options',
            'leftlane-playground-settings',
            array($this, 'render_settings_page')
        );
    }
    
    /**
     * Add admin bar link
     */
    public function add_admin_bar_link($admin_bar) {
        if (!current_user_can('manage_options')) {
            return;
        }
        
        if (get_option('leftlane_playground_show_admin_bar', true)) {
            $admin_bar->add_menu(array(
                'id'    => 'leftlane-playground',
                'parent' => null,
                'group'  => null,
                'title' => '<span class="ab-icon dashicons-admin-site-alt3"></span> Test in Playground',
                'href'  => admin_url('admin.php?page=leftlane-playground'),
                'meta' => array(
                    'title' => 'Open WordPress Playground for safe testing',
                ),
            ));
        }
    }
    
    /**
     * Enqueue frontend assets
     */
    public function enqueue_frontend_assets() {
        wp_enqueue_style(
            'leftlane-playground',
            plugins_url('assets/css/style.css', __FILE__),
            array(),
            self::VERSION
        );
        
        wp_enqueue_script(
            'leftlane-playground',
            plugins_url('assets/js/script.js', __FILE__),
            array(),
            self::VERSION,
            true
        );
        
        wp_localize_script('leftlane-playground', 'leftlanePlayground', array(
            'blueprintUrl' => get_option('leftlane_playground_blueprint_url', $this->blueprint_url),
            'ajaxUrl' => admin_url('admin-ajax.php'),
        ));
    }
    
    /**
     * Enqueue admin assets
     */
    public function enqueue_admin_assets($hook) {
        if (strpos($hook, 'leftlane-playground') === false) {
            return;
        }
        
        wp_enqueue_style(
            'leftlane-playground-admin',
            plugins_url('assets/css/admin.css', __FILE__),
            array(),
            self::VERSION
        );
    }
    
    /**
     * Render playground shortcode
     */
    public function render_playground_shortcode($atts) {
        $atts = shortcode_atts(array(
            'height' => get_option('leftlane_playground_default_height', '800'),
            'width' => '100%',
            'blueprint' => get_option('leftlane_playground_blueprint_url', $this->blueprint_url),
            'border' => 'yes',
        ), $atts);
        
        $border_class = $atts['border'] === 'yes' ? 'with-border' : 'no-border';
        
        ob_start();
        ?>
        <div class="leftlane-playground-wrapper <?php echo esc_attr($border_class); ?>">
            <div class="leftlane-playground-container" 
                 data-blueprint="<?php echo esc_attr($atts['blueprint']); ?>"
                 data-height="<?php echo esc_attr($atts['height']); ?>"
                 style="width: <?php echo esc_attr($atts['width']); ?>; height: <?php echo esc_attr($atts['height']); ?>px;">
                <div class="leftlane-playground-loading">
                    <div class="spinner"></div>
                    <p>Loading WordPress Playground...</p>
                    <small>This may take 10-20 seconds on first load</small>
                </div>
            </div>
        </div>
        <?php
        return ob_get_clean();
    }
    
    /**
     * Render admin page
     */
    public function render_admin_page() {
        $blueprint_url = get_option('leftlane_playground_blueprint_url', $this->blueprint_url);
        ?>
        <div class="wrap">
            <h1>
                <span class="dashicons dashicons-admin-site-alt3"></span>
                WordPress Playground (WASM)
            </h1>
            
            <div class="leftlane-playground-intro">
                <p>Test WordPress changes in a safe, isolated environment. Changes here won't affect your live site.</p>
                <p><strong>Login:</strong> admin / password</p>
            </div>
            
            <div id="leftlane-playground-admin-container" 
                 class="leftlane-playground-admin-wrapper"
                 data-blueprint="<?php echo esc_attr($blueprint_url); ?>">
                <div class="leftlane-playground-loading">
                    <div class="spinner"></div>
                    <p>Loading WordPress Playground...</p>
                    <small>This may take 10-20 seconds on first load</small>
                </div>
            </div>
            
            <script type="module">
                (async () => {
                    try {
                        const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
                        
                        const container = document.getElementById('leftlane-playground-admin-container');
                        const blueprintUrl = container.dataset.blueprint;
                        
                        const iframe = document.createElement('iframe');
                        iframe.style.width = '100%';
                        iframe.style.height = '800px';
                        iframe.style.border = '1px solid #ccd0d4';
                        iframe.style.borderRadius = '4px';
                        
                        container.innerHTML = '';
                        container.appendChild(iframe);
                        
                        const response = await fetch(blueprintUrl);
                        const blueprint = await response.json();
                        
                        await startPlaygroundWeb({
                            iframe: iframe,
                            remoteUrl: 'https://playground.wordpress.net/remote.html',
                            blueprint: blueprint
                        });
                        
                        console.log('WordPress Playground loaded successfully');
                    } catch (error) {
                        console.error('Error loading Playground:', error);
                        document.getElementById('leftlane-playground-admin-container').innerHTML = 
                            '<div class="notice notice-error"><p>Error loading WordPress Playground. Please check your internet connection.</p></div>';
                    }
                })();
            </script>
        </div>
        <?php
    }
    
    /**
     * Render settings page
     */
    public function render_settings_page() {
        ?>
        <div class="wrap">
            <h1>WordPress Playground Settings</h1>
            
            <form method="post" action="options.php">
                <?php settings_fields('leftlane_playground_settings'); ?>
                
                <table class="form-table">
                    <tr>
                        <th scope="row">
                            <label for="leftlane_playground_blueprint_url">Blueprint URL</label>
                        </th>
                        <td>
                            <input type="url" 
                                   id="leftlane_playground_blueprint_url" 
                                   name="leftlane_playground_blueprint_url" 
                                   value="<?php echo esc_attr(get_option('leftlane_playground_blueprint_url', $this->blueprint_url)); ?>" 
                                   class="regular-text"
                                   placeholder="https://chriswdixon.github.io/leftlane-wasm/blueprint.json">
                            <p class="description">URL to your WordPress Playground blueprint.json configuration file.</p>
                        </td>
                    </tr>
                    
                    <tr>
                        <th scope="row">
                            <label for="leftlane_playground_default_height">Default Height (px)</label>
                        </th>
                        <td>
                            <input type="number" 
                                   id="leftlane_playground_default_height" 
                                   name="leftlane_playground_default_height" 
                                   value="<?php echo esc_attr(get_option('leftlane_playground_default_height', '800')); ?>" 
                                   class="small-text"
                                   min="400"
                                   max="2000">
                            <p class="description">Default height for embedded playgrounds (400-2000px).</p>
                        </td>
                    </tr>
                    
                    <tr>
                        <th scope="row">
                            <label for="leftlane_playground_show_admin_bar">Show in Admin Bar</label>
                        </th>
                        <td>
                            <input type="checkbox" 
                                   id="leftlane_playground_show_admin_bar" 
                                   name="leftlane_playground_show_admin_bar" 
                                   value="1" 
                                   <?php checked(get_option('leftlane_playground_show_admin_bar', true), true); ?>>
                            <label for="leftlane_playground_show_admin_bar">Display "Test in Playground" link in admin bar</label>
                        </td>
                    </tr>
                </table>
                
                <?php submit_button(); ?>
            </form>
            
            <hr>
            
            <h2>Shortcode Usage</h2>
            <p>Use these shortcodes to embed WordPress Playground in your posts and pages:</p>
            
            <h3>Basic Usage:</h3>
            <code>[leftlane_playground]</code>
            
            <h3>With Custom Height:</h3>
            <code>[leftlane_playground height="600"]</code>
            
            <h3>Full Width, No Border:</h3>
            <code>[leftlane_playground height="800" width="100%" border="no"]</code>
            
            <h3>Custom Blueprint:</h3>
            <code>[leftlane_playground blueprint="https://your-blueprint-url.json"]</code>
        </div>
        <?php
    }
}

// Initialize plugin
new LeftLane_Playground_Integration();

