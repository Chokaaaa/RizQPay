//
//  WebKitPreloader.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import Foundation
import WebKit

/// WebKit preloader to warm up WebKit processes for faster loading
class WebKitPreloader {
    static let shared = WebKitPreloader()
    
    private var preloadedWebView: WKWebView?
    private let processPool = WKProcessPool()
    
    private init() {
        // Start preloading immediately when app launches
        preloadWebKit()
    }
    
    /// Preloads WebKit components in background for faster subsequent loading
    func preloadWebKit() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let configuration = WKWebViewConfiguration()
            configuration.processPool = self?.processPool ?? WKProcessPool()
            configuration.allowsInlineMediaPlayback = true
            configuration.mediaTypesRequiringUserActionForPlayback = []
            configuration.suppressesIncrementalRendering = false
            
            DispatchQueue.main.async {
                // Create a hidden WebView to warm up the WebKit process
                let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), configuration: configuration)
                webView.alpha = 0
                webView.isHidden = true
                
                // Load a minimal HTML page to initialize the process
                let htmlString = "<html><body>Preload</body></html>"
                webView.loadHTMLString(htmlString, baseURL: nil)
                
                self?.preloadedWebView = webView
                print("🚀 DEBUG: WebKit preloaded successfully")
            }
        }
    }
    
    /// Returns the shared process pool for optimized WebView creation
    func getProcessPool() -> WKProcessPool {
        return processPool
    }
    
    /// Cleanup preloaded resources
    func cleanup() {
        preloadedWebView?.removeFromSuperview()
        preloadedWebView = nil
        print("🧹 DEBUG: WebKit preloader cleaned up")
    }
}