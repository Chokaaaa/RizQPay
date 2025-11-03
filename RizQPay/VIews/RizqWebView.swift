//
//  RizqWebView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI

struct RizqWebView: View {
    let scannedCode: String
    let onBackToScan: () -> Void
    let onDismiss: () -> Void
    @State private var isLoading = true
    
    // Computed property to get the URL from scanned code
    private var webURL: URL? {
        // Debug: Print the scanned code
        print("🔍 DEBUG: Scanned QR Code content: \(scannedCode)")
        
        // Try to create URL from scanned code
        if let url = URL(string: scannedCode), url.scheme != nil {
            print("✅ DEBUG: Valid URL found: \(url.absoluteString)")
            return url
        }
        
        // If scanned code doesn't contain a valid URL, check if it's just a domain
        let processedCode: String
        if !scannedCode.hasPrefix("http://") && !scannedCode.hasPrefix("https://") {
            processedCode = "https://\(scannedCode)"
            print("🔧 DEBUG: Adding https:// to scanned code: \(processedCode)")
        } else {
            processedCode = scannedCode
        }
        
        if let url = URL(string: processedCode), url.scheme != nil {
            print("✅ DEBUG: Valid URL created: \(url.absoluteString)")
            return url
        }
        
        // Fallback to default URL if scanned code is not a valid URL
        let fallbackURL = URL(string: "https://app.rizq.kz")!
        print("⚠️ DEBUG: Invalid URL in QR code, using fallback: \(fallbackURL.absoluteString)")
        return fallbackURL
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebView(url: webURL, isLoading: $isLoading)
                    .onAppear {
                        print("🌐 DEBUG: WebView loading URL: \(webURL?.absoluteString ?? "nil")")
                    }
                
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        
                        Text("Loading...")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7))
                }
            }
            .navigationTitle("RizQ Pay")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBackToScan) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back to Scan")
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    RizqWebView(
        scannedCode: "sample-qr-code",
        onBackToScan: { print("Back to scan") },
        onDismiss: { print("Dismiss") }
    )
}