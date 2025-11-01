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