//
//  AdvancedQRScannerView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI
import QRScanner
import AVFoundation

struct AdvancedQRScannerView: View {
    @State private var scannedCode = ""
    @State private var isScanning = true
    @State private var showWebView = false
    
    // Binding to communicate WebView state to parent
    @Binding var isShowingWebView: Bool
    
    // Callback for complete dismissal (X button)
    let onDismiss: (() -> Void)?
    
    init(isShowingWebView: Binding<Bool> = .constant(false), onDismiss: (() -> Void)? = nil) {
        self._isShowingWebView = isShowingWebView
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack {
            if showWebView {
                RizqWebView(
                    scannedCode: scannedCode,
                    onBackToScan: {
                        // Reset and go back to scanning
                        showWebView = false
                        isScanning = true
                        scannedCode = ""
                        isShowingWebView = false // Update parent binding
                    },
                    onDismiss: {
                        // Complete dismissal - close both WebView and scanner
                        onDismiss?()
                    }
                )
            } else {
                QRScannerSwiftUIView(
                    configuration: .init(
                        focusImagePadding: 12.0,
                        animationDuration: 0.3,
                        isBlurEffectEnabled: true
                    ),
                    isScanning: $isScanning,
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

#Preview {
    AdvancedQRScannerView()
}
