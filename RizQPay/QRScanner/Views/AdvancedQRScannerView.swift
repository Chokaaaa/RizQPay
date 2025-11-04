//
//  AdvancedQRScannerView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI
import AVFoundation

struct AdvancedQRScannerView: View {
    @State private var scannedCode = ""
    @State private var isScanning = true
    @State private var showWebView = false
    @State private var lastScanTime: Date = .now
    @State private var scanningEnabled = true
    
    // Performance tracking
    @State private var scanStartTime: Date?
    @State private var webViewTransitionStartTime: Date?
    @State private var lastDebugTime: Date = .now
    
    // Binding to communicate WebView state to parent
    @Binding var isShowingWebView: Bool
    
    // Callback for complete dismissal (X button)
    let onDismiss: (() -> Void)?
    
    // Throttling interval to prevent rapid scans - reduced for faster response
    private let scanThrottleInterval: TimeInterval = 0.5
    
    init(isShowingWebView: Binding<Bool> = .constant(false), onDismiss: (() -> Void)? = nil) {
        self._isShowingWebView = isShowingWebView
        self.onDismiss = onDismiss
        print("🏗️ DEBUG [INIT]: AdvancedQRScannerView initialized at \(Date.now)")
        print("🏗️ DEBUG [INIT]: Memory usage before init: \(getMemoryUsage()) MB")
    }
    
    var body: some View {
        let _ = {
            let bodyStartTime = Date.now
            print("🔄 DEBUG [BODY]: Body recomputation started at \(bodyStartTime)")
        }()
        
        return VStack {
            if showWebView {
                let _ = {
                    let webViewRenderStart = Date.now
                    print("🌐 DEBUG [WEBVIEW]: Starting WebView render at \(webViewRenderStart)")
                    print("🌐 DEBUG [WEBVIEW]: Memory before WebView: \(getMemoryUsage()) MB")
                }()
                
                RizqWebView(
                    scannedCode: scannedCode,
                    onBackToScan: {
                        let backToScanStart = Date.now
                        print("🔄 DEBUG [BACK_TO_SCAN]: User requested back to scanning at \(backToScanStart)")
                        print("🔄 DEBUG [BACK_TO_SCAN]: Current memory usage: \(getMemoryUsage()) MB")
                        
                        // Immediate state reset for faster transition
                        showWebView = false
                        isShowingWebView = false
                        
                        // Reset scanner state immediately
                        scannedCode = ""
                        scanningEnabled = true
                        isScanning = true
                        lastScanTime = .now
                        
                        print("🔄 DEBUG [BACK_TO_SCAN]: Scanner reset completed in \(Date.now.timeIntervalSince(backToScanStart) * 1000)ms")
                        print("🔄 DEBUG [BACK_TO_SCAN]: Memory after reset: \(getMemoryUsage()) MB")
                    },
                    onDismiss: {
                        print("❌ DEBUG [DISMISS]: User dismissed scanner completely at \(Date.now)")
                        print("❌ DEBUG [DISMISS]: Memory at dismiss: \(getMemoryUsage()) MB")
                        // Complete dismissal - close both WebView and scanner
                        cleanupScanner()
                        onDismiss?()
                    }
                )
                .onAppear {
                    if let transitionStart = webViewTransitionStartTime {
                        let totalTransitionTime = Date.now.timeIntervalSince(transitionStart)
                        print("🌐 DEBUG [WEBVIEW]: WebView appeared! Total transition time: \(totalTransitionTime * 1000)ms")
                        print("🌐 DEBUG [WEBVIEW]: Memory after WebView load: \(getMemoryUsage()) MB")
                        webViewTransitionStartTime = nil
                    }
                }
            } else {
                let _ = {
                    let scannerRenderStart = Date.now
                    print("📷 DEBUG [SCANNER]: Starting QRScannerSwiftUIView render at \(scannerRenderStart)")
                    print("📷 DEBUG [SCANNER]: Memory before scanner: \(getMemoryUsage()) MB")
                }()
                
                QRScannerSwiftUIView(
                    configuration: .init(
                        focusImagePadding: 8.0, // Reduced padding
                        animationDuration: 0.1, // Faster animation
                        isBlurEffectEnabled: false // Disabled for better performance
                    ),
                    isScanning: $isScanning,
                    onSuccess: { code in
                        let scanSuccessTime = Date.now
                        print("📱 DEBUG [SCAN_SUCCESS]: QR Code detected at \(scanSuccessTime)")
                        print("📱 DEBUG [SCAN_SUCCESS]: Raw QR Code content: '\(code)'")
                        print("📱 DEBUG [SCAN_SUCCESS]: Memory at scan success: \(getMemoryUsage()) MB")
                        
                        if let scanStart = scanStartTime {
                            let scanDuration = scanSuccessTime.timeIntervalSince(scanStart)
                            print("📱 DEBUG [SCAN_SUCCESS]: Total scan duration: \(scanDuration * 1000)ms")
                        }
                        
                        // Throttle rapid scans to prevent camera slowdown
                        let currentTime = Date.now
                        let timeSinceLastScan = currentTime.timeIntervalSince(lastScanTime)
                        
                        print("📱 DEBUG [THROTTLE]: Time since last scan: \(timeSinceLastScan * 1000)ms")
                        print("📱 DEBUG [THROTTLE]: Throttle interval: \(scanThrottleInterval * 1000)ms")
                        print("📱 DEBUG [THROTTLE]: Scanning enabled: \(scanningEnabled)")
                        
                        guard scanningEnabled && timeSinceLastScan >= scanThrottleInterval else {
                            print("🚫 DEBUG [THROTTLE]: Scan throttled - too soon since last scan")
                            print("🚫 DEBUG [THROTTLE]: Need to wait \((scanThrottleInterval - timeSinceLastScan) * 1000)ms more")
                            return
                        }
                        
                        print("✅ DEBUG [THROTTLE]: Throttle check passed, processing scan")
                        
                        // Immediately disable scanning to prevent duplicates
                        let disableStart = Date.now
                        scanningEnabled = false
                        isScanning = false
                        lastScanTime = currentTime
                        print("📱 DEBUG [SCAN_SUCCESS]: Scanner disabled in \(Date.now.timeIntervalSince(disableStart) * 1000)ms")
                        
                        // Process the scanned code - immediate transition without Task wrapper
                        let processStart = Date.now
                        print("🎯 DEBUG [PROCESS]: Immediate processing started at \(processStart)")
                        
                        webViewTransitionStartTime = Date.now
                        scannedCode = code
                        
                        let stateUpdateTime = Date.now
                        print("🎯 DEBUG [PROCESS]: State updated in \(stateUpdateTime.timeIntervalSince(processStart) * 1000)ms")
                        
                        // Immediate state change for fastest transition
                        showWebView = true
                        isShowingWebView = true
                        
                        let transitionTime = Date.now
                        print("🎯 DEBUG [PROCESS]: WebView transition initiated in \(transitionTime.timeIntervalSince(stateUpdateTime) * 1000)ms")
                        print("🎯 DEBUG [PROCESS]: Total processing time: \(transitionTime.timeIntervalSince(processStart) * 1000)ms")
                        print("🎯 DEBUG [PROCESS]: Transitioning to WebView with URL: \(code)")
                        print("🎯 DEBUG [PROCESS]: Memory after state change: \(getMemoryUsage()) MB")
                    },
                    onFailure: { error in
                        let failureTime = Date.now
                        print("❌ DEBUG [SCAN_FAILURE]: QR Code scanning failed at \(failureTime)")
                        print("❌ DEBUG [SCAN_FAILURE]: Error: \(error.localizedDescription)")
                        print("❌ DEBUG [SCAN_FAILURE]: Error details: \(error)")
                        print("❌ DEBUG [SCAN_FAILURE]: Memory at failure: \(getMemoryUsage()) MB")
                        
                        if let scanStart = scanStartTime {
                            let failureDuration = failureTime.timeIntervalSince(scanStart)
                            print("❌ DEBUG [SCAN_FAILURE]: Time to failure: \(failureDuration * 1000)ms")
                        }
                        
                        // Re-enable scanning after a short delay on failure
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scanningEnabled = true
                            let recoveryEnd = Date.now
                            print("🔄 DEBUG [RECOVERY]: Scanner re-enabled after \(recoveryEnd.timeIntervalSince(failureTime) * 1000)ms")
                            print("🔄 DEBUG [RECOVERY]: Memory after recovery: \(getMemoryUsage()) MB")
                        }
                    }
                )
                .onAppear {
                    scanStartTime = Date.now
                    print("📷 DEBUG [SCANNER]: QR Scanner appeared at \(scanStartTime!)")
                    print("📷 DEBUG [SCANNER]: Initializing camera...")
                    print("📷 DEBUG [SCANNER]: Memory after scanner appear: \(getMemoryUsage()) MB")
                    checkCameraPermission()
                }
                .onDisappear {
                    let disappearTime = Date.now
                    print("📷 DEBUG [SCANNER]: QR Scanner disappeared at \(disappearTime)")
                    if let scanStart = scanStartTime {
                        let totalScanTime = disappearTime.timeIntervalSince(scanStart)
                        print("📷 DEBUG [SCANNER]: Total scanner lifetime: \(totalScanTime * 1000)ms")
                    }
                    print("📷 DEBUG [SCANNER]: Cleaning up scanner...")
                    print("📷 DEBUG [SCANNER]: Memory before cleanup: \(getMemoryUsage()) MB")
                    cleanupScanner()
                    scanStartTime = nil
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showWebView) // Fast animation for immediate feel
        .onAppear {
            let viewAppearTime = Date.now
            print("👁️ DEBUG [VIEW]: AdvancedQRScannerView appeared at \(viewAppearTime)")
            print("👁️ DEBUG [VIEW]: Memory at view appear: \(getMemoryUsage()) MB")
        }
        .onDisappear {
            let viewDisappearTime = Date.now
            print("👁️ DEBUG [VIEW]: AdvancedQRScannerView disappeared at \(viewDisappearTime)")
            print("👁️ DEBUG [VIEW]: Memory at view disappear: \(getMemoryUsage()) MB")
        }
        .onChange(of: showWebView) { oldValue, newValue in
            print("🔄 DEBUG [STATE]: showWebView changed from \(oldValue) to \(newValue) at \(Date.now)")
            if newValue {
                print("🔄 DEBUG [STATE]: Transitioning TO WebView")
            } else {
                print("🔄 DEBUG [STATE]: Transitioning FROM WebView")
            }
        }
        .onChange(of: isScanning) { oldValue, newValue in
            print("📷 DEBUG [STATE]: isScanning changed from \(oldValue) to \(newValue) at \(Date.now)")
        }
        .onChange(of: scanningEnabled) { oldValue, newValue in
            print("🎛️ DEBUG [STATE]: scanningEnabled changed from \(oldValue) to \(newValue) at \(Date.now)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func checkCameraPermission() {
        let permissionCheckStart = Date.now
        print("🎥 DEBUG [PERMISSION]: Starting camera permission check at \(permissionCheckStart)")
        print("🎥 DEBUG [PERMISSION]: Memory before permission check: \(getMemoryUsage()) MB")
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            let authorizedTime = Date.now.timeIntervalSince(permissionCheckStart)
            print("✅ DEBUG [PERMISSION]: Camera permission granted in \(authorizedTime * 1000)ms")
        case .notDetermined:
            print("🤔 DEBUG [PERMISSION]: Camera permission not determined, requesting...")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                let requestTime = Date.now.timeIntervalSince(permissionCheckStart)
                DispatchQueue.main.async {
                    if granted {
                        print("✅ DEBUG [PERMISSION]: Camera permission granted after request in \(requestTime * 1000)ms")
                        print("✅ DEBUG [PERMISSION]: Memory after permission granted: \(getMemoryUsage()) MB")
                    } else {
                        print("❌ DEBUG [PERMISSION]: Camera permission denied after request in \(requestTime * 1000)ms")
                    }
                }
            }
        case .denied, .restricted:
            let deniedTime = Date.now.timeIntervalSince(permissionCheckStart)
            print("❌ DEBUG [PERMISSION]: Camera permission denied/restricted in \(deniedTime * 1000)ms")
        @unknown default:
            let unknownTime = Date.now.timeIntervalSince(permissionCheckStart)
            print("⚠️ DEBUG [PERMISSION]: Unknown camera permission status in \(unknownTime * 1000)ms")
        }
    }
    
    private func cleanupScanner() {
        let cleanupStart = Date.now
        print("🧹 DEBUG [CLEANUP]: Starting scanner cleanup at \(cleanupStart)")
        print("🧹 DEBUG [CLEANUP]: Memory before cleanup: \(getMemoryUsage()) MB")
        
        isScanning = false
        scanningEnabled = false
        
        let cleanupTime = Date.now.timeIntervalSince(cleanupStart)
        print("🧹 DEBUG [CLEANUP]: Scanner cleanup completed in \(cleanupTime * 1000)ms")
        print("🧹 DEBUG [CLEANUP]: Memory after cleanup: \(getMemoryUsage()) MB")
    }
    
    // MARK: - Performance Monitoring
    private func getMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024.0 / 1024.0
        } else {
            return -1
        }
    }
}

#Preview {
    AdvancedQRScannerView()
}
