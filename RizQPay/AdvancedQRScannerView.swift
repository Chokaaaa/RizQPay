//
//  AdvancedQRScannerView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI
import QRScanner
import AVFoundation
import WebKit

struct AdvancedQRScannerView: View {
    @State private var scannedCode = ""
    @State private var isScanning = true
    @State private var torchActive = false
    @State private var showWebView = false
    
    // Binding to communicate WebView state to parent
    @Binding var isShowingWebView: Bool
    
    init(isShowingWebView: Binding<Bool> = .constant(false)) {
        self._isShowingWebView = isShowingWebView
    }
    
    var body: some View {
        VStack {
            if showWebView {
                RizqWebView(scannedCode: scannedCode) {
                    // Reset and go back to scanning
                    showWebView = false
                    isScanning = true
                    scannedCode = ""
                    isShowingWebView = false // Update parent binding
                }
            } else {
                QRScannerSwiftUIView(
                    configuration: .init(
                        focusImagePadding: 12.0,
                        animationDuration: 0.3,
                        isBlurEffectEnabled: true
                    ),
                    isScanning: $isScanning,
                    torchActive: $torchActive,
                    onSuccess: { code in
                        scannedCode = code
                        isScanning = false
                        showWebView = true
                        isShowingWebView = true // Update parent binding
                        print("QR Code scanned: \(code)")
                    },
                    onFailure: { error in
                        print("Error: \(error.localizedDescription)")
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showWebView)
    }
}

struct RizqWebView: View {
    let scannedCode: String
    let onBack: () -> Void
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                WebView(url: URL(string: "https://app.rizq.kz"))
                    .onAppear {
                        // Add a small delay to show loading state
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isLoading = false
                        }
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
                    Button(action: onBack) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back to Scan")
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onBack) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

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


#Preview {
    AdvancedQRScannerView()
}
