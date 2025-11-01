//
//  QRScannerView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 01/11/2025.
//

import SwiftUI

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingWebView = false
    
    var body: some View {
        ZStack {
            // Your third-party QR scanner view
            AdvancedQRScannerView(
                isShowingWebView: $isShowingWebView,
                onDismiss: {
                    dismiss() // This will dismiss the entire scanner view
                }
            )
                .ignoresSafeArea()
            
            // Only show close button when WebView is not showing
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
                }
            }
        }
    }
}

#Preview {
    QRScannerView()
}
