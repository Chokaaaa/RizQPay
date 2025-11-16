//
//  WebView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI
import WebKit

// Optimized WebView wrapper with better performance
struct WebView: UIViewRepresentable {
    let url: URL?
    @Binding var isLoading: Bool
    
    init(url: URL?, isLoading: Binding<Bool> = .constant(false)) {
        self.url = url
        self._isLoading = isLoading
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        // Performance optimizations for faster loading
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.suppressesIncrementalRendering = false // Allow incremental rendering
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        // Performance settings
        webView.scrollView.scrollsToTop = true
        webView.isMultipleTouchEnabled = true
        
        // Set navigation delegate for better error handling
        webView.navigationDelegate = context.coordinator
        
        // Load the initial URL when creating the web view (only once)
        if let url = url {
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            request.timeoutInterval = 10.0
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Only load the URL if it's different from the currently loaded URL
        // This prevents infinite refreshing when SwiftUI re-renders the view
        if let url = url, url != webView.url {
            // Optimized request with aggressive caching for faster loading
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad // Use cache if available
            request.timeoutInterval = 10.0 // Shorter timeout
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("🌐 WebView started loading")
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ WebView finished loading")
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ WebView failed to load: \(error.localizedDescription)")
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ WebView provisional navigation failed: \(error.localizedDescription)")
            parent.isLoading = false
        }
    }
}
