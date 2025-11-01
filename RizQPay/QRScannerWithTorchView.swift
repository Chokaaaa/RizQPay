//
//  QRScannerWithTorchView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI
import AVFoundation

struct QRScannerWithTorchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isTorchOn = false
    @State private var isShowingWebView = false
    
    var body: some View {
        ZStack {
            // Your third-party QR scanner view
            AdvancedQRScannerView(isShowingWebView: $isShowingWebView)
                .ignoresSafeArea()
            
            // Only show buttons when WebView is not showing
            if !isShowingWebView {
                // Close button overlay (top-right)
                VStack {
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                        
                    }
                    
                    Spacer()
                    
                    // Torch button at bottom center
                    Button(action: {
                        toggleTorch()
                    }) {
                        Image(systemName: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .onDisappear {
            // Turn off torch when view disappears
            if isTorchOn {
                toggleTorch()
            }
        }
    }
    
    private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            if isTorchOn {
                device.torchMode = .off
                isTorchOn = false
            } else {
                try device.setTorchModeOn(level: 1.0)
                isTorchOn = true
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    }
}

#Preview {
    QRScannerWithTorchView()
}
