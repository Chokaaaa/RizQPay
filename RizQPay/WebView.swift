//
//  WebView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI
import WebKit

// Simple WebView wrapper using WKWebView
struct WebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}