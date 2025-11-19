//
//  RootView.swift
//  RizQPay
//
//  Created by Authentication System
//

import SwiftUI

struct RootView: View {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var vehicleManager = VehicleManager()
    @State private var isLoading = true
    @State private var loadingProgress: Double = 0.0
    @State private var currentLoadingPhase: LoadingPhase = .initializing
    @StateObject private var appInitializer = AppInitializer()
    
    var body: some View {
        Group {
            if isLoading {
                LaunchScreenView(progress: loadingProgress, currentPhase: currentLoadingPhase)
                    .onAppear {
                        startAppInitialization()
                    }
            } else {
                // After loading, check authentication status
                if authManager.isAuthenticated {
                    // User is logged in - show main content (MapView)
                    MapView()
                        .environmentObject(authManager)
                        .environmentObject(vehicleManager)
                } else {
                    // User is not logged in - show login
                    NavigationStack {
                        LoginView()
                            .environmentObject(authManager)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLoading)
        .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
    }
    
    private func startAppInitialization() {
        // Monitor the app initializer's progress
        appInitializer.onProgressUpdate = { phase, progress in
            Task { @MainActor in
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.currentLoadingPhase = phase
                    self.loadingProgress = progress
                }
            }
        }
        
        appInitializer.onInitializationComplete = {
            Task { @MainActor in
                // Update to ready state and immediately animate to 100%
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.currentLoadingPhase = .ready
                    self.loadingProgress = 1.0
                }
                
                // Brief pause to show completion, then transition to main view
                try? await Task.sleep(for: .seconds(0.3))
                
                // Transition to authentication check
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.isLoading = false
                }
            }
        }
        
        // Start the initialization process
        appInitializer.initialize()
    }
}

#Preview {
    RootView()
}