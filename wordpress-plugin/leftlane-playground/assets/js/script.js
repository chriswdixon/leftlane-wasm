/**
 * WordPress Playground Frontend JavaScript
 */

(function() {
    'use strict';
    
    /**
     * Initialize all playground containers on the page
     */
    async function initPlaygrounds() {
        const containers = document.querySelectorAll('.leftlane-playground-container');
        
        if (containers.length === 0) {
            return;
        }
        
        try {
            // Load WordPress Playground client
            const { startPlaygroundWeb } = await import('https://playground.wordpress.net/client/index.js');
            
            // Initialize each container
            for (const container of containers) {
                await initSinglePlayground(container, startPlaygroundWeb);
            }
        } catch (error) {
            console.error('Error loading WordPress Playground:', error);
            
            containers.forEach(container => {
                container.innerHTML = `
                    <div style="padding: 2rem; text-align: center; color: #d63638;">
                        <p><strong>Error loading WordPress Playground</strong></p>
                        <p>Please check your internet connection and try again.</p>
                    </div>
                `;
            });
        }
    }
    
    /**
     * Initialize a single playground instance
     */
    async function initSinglePlayground(container, startPlaygroundWeb) {
        const blueprintUrl = container.dataset.blueprint;
        const height = container.dataset.height || '800';
        
        try {
            // Create iframe
            const iframe = document.createElement('iframe');
            iframe.style.width = '100%';
            iframe.style.height = height + 'px';
            iframe.style.border = 'none';
            iframe.style.display = 'block';
            
            // Fetch blueprint
            const response = await fetch(blueprintUrl);
            if (!response.ok) {
                throw new Error(`Failed to fetch blueprint: ${response.statusText}`);
            }
            const blueprint = await response.json();
            
            // Replace loading screen with iframe
            container.innerHTML = '';
            container.appendChild(iframe);
            
            // Start WordPress Playground
            await startPlaygroundWeb({
                iframe: iframe,
                remoteUrl: 'https://playground.wordpress.net/remote.html',
                blueprint: blueprint
            });
            
            console.log('WordPress Playground loaded successfully');
            
            // Add loaded class for any custom styling
            container.classList.add('playground-loaded');
            
        } catch (error) {
            console.error('Error initializing playground:', error);
            
            container.innerHTML = `
                <div style="padding: 2rem; text-align: center; color: #d63638; background: #fff;">
                    <p><strong>Failed to initialize WordPress Playground</strong></p>
                    <p style="font-size: 0.9rem;">${error.message}</p>
                </div>
            `;
        }
    }
    
    /**
     * Wait for DOM to be ready
     */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initPlaygrounds);
    } else {
        initPlaygrounds();
    }
    
    /**
     * Expose API for programmatic access
     */
    window.LeftLanePlayground = {
        init: initPlaygrounds,
        version: '1.0.0'
    };
    
})();

