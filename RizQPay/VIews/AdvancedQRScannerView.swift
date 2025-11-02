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
    @State private var lastScanTime: Date = .now
    @State private var scanningEnabled = true
    
    // Binding to communicate WebView state to parent
    @Binding var isShowingWebView: Bool
    
    // Callback for complete dismissal (X button)
    let onDismiss: (() -> Void)?
    
    // Throttling interval to prevent rapid scans
    private let scanThrottleInterval: TimeInterval = 2.0
    
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
                        print("🔄 DEBUG: User requested to go back to scanning")
                        // Reset and go back to scanning with proper cleanup
                        Task { @MainActor in
                            showWebView = false
                            isShowingWebView = false // Update parent binding first
                            
                            // Small delay to ensure WebView is properly dismissed
                            try? await Task.sleep(for: .milliseconds(300))
                            
                            // Reset scanner state
                            scannedCode = ""
                            scanningEnabled = true
                            isScanning = true
                            lastScanTime = .now
                            
                            print("🔄 DEBUG: Scanner reset and ready for new QR code")
                        }
                    },
                    onDismiss: {
                        print("❌ DEBUG: User dismissed the scanner completely")
                        // Complete dismissal - close both WebView and scanner
                        cleanupScanner()
                        onDismiss?()
                    }
                )
            } else {
                QRScannerSwiftUIView(
                    configuration: .init(
                        focusImagePadding: 12.0,
                        animationDuration: 0.15, // Reduced animation duration
                        isBlurEffectEnabled: false // Disabled blur for better performance
                    ),
                    isScanning: $isScanning,
                    onSuccess: { code in
                        // Throttle rapid scans to prevent camera slowdown
                        let currentTime = Date.now
                        let timeSinceLastScan = currentTime.timeIntervalSince(lastScanTime)
                        
                        guard scanningEnabled && timeSinceLastScan >= scanThrottleInterval else {
                            print("🚫 DEBUG: Scan throttled - too soon since last scan")
                            return
                        }
                        
                        print("📱 DEBUG: QR Code scanning successful!")
                        print("📱 DEBUG: Raw QR Code content: '\(code)'")
                        
                        // Immediately disable scanning to prevent duplicates
                        scanningEnabled = false
                        isScanning = false
                        lastScanTime = currentTime
                        
                        // Process the scanned code
                        Task { @MainActor in
                            scannedCode = code
                            showWebView = true
                            isShowingWebView = true // Update parent binding
                            
                            print("📱 DEBUG: Transitioning to WebView with URL: \(code)")
                        }
                    },
                    onFailure: { error in
                        print("❌ DEBUG: QR Code scanning failed with error: \(error.localizedDescription)")
                        print("❌ DEBUG: Error details: \(error)")
                        
                        // Re-enable scanning after a short delay on failure
                        Task {
                            try? await Task.sleep(for: .milliseconds(500))
                            await MainActor.run {
                                scanningEnabled = true
                            }
                        }
                    }
                )
                .onAppear {
                    print("📷 DEBUG: QR Scanner appeared - initializing camera")
                    checkCameraPermission()
                }
                .onDisappear {
                    print("📷 DEBUG: QR Scanner disappeared - cleaning up")
                    cleanupScanner()
                }
            }
        }
        // Removed animation to improve performance
    }
    
    // MARK: - Helper Methods
    
    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            print("✅ Camera permission granted")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        print("✅ Camera permission granted")
                    } else {
                        print("❌ Camera permission denied")
                    }
                }
            }
        case .denied, .restricted:
            print("❌ Camera permission denied or restricted")
        @unknown default:
            print("⚠️ Unknown camera permission status")
        }
    }
    
    private func cleanupScanner() {
        isScanning = false
        scanningEnabled = false
        print("🧹 DEBUG: Scanner cleanup completed")
    }
}

#Preview {
    AdvancedQRScannerView()
}
