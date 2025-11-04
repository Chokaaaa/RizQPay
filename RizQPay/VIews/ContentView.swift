//
//  ContentView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 24/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var loadingProgress: Double = 0.0
    @State private var currentLoadingPhase: LoadingPhase = .initializing
    @StateObject private var appInitializer = AppInitializer()
    
    var body: some View {
        if isLoading {
            LaunchScreenView(progress: loadingProgress, currentPhase: currentLoadingPhase)
                .onAppear {
                    startRealProgressTracking()
                }
        } else {
            MapView()
        }
    }
    
    private func startRealProgressTracking() {
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
                
                // Brief pause to show completion, then transition to map
                try? await Task.sleep(for: .seconds(0.3))
                
                // Transition to main view
                withAnimation(.easeInOut(duration: 0.4)) {
                    self.isLoading = false
                }
            }
        }
        
        // Start the initialization process
        appInitializer.initialize()
    }
}

// MARK: - Loading Phases
enum LoadingPhase {
    case initializing
    case configuringMaps
    case requestingLocation
    case loadingMapData
    case ready
    
    var displayText: String {
        switch self {
        case .initializing:
            return "Initializing..."
        case .configuringMaps:
            return "Configuring maps..."
        case .requestingLocation:
            return "Requesting location..."
        case .loadingMapData:
            return "Loading map data..."
        case .ready:
            return "Ready!"
        }
    }
}

// MARK: - App Initializer
@MainActor
class AppInitializer: ObservableObject {
    private let locationManager = GoogleMapsLocationManager()
    private var initializationComplete = false
    private let maxInitializationTime: TimeInterval = 4.0 // Reduced timeout to 4 seconds
    
    var onProgressUpdate: ((LoadingPhase, Double) -> Void)?
    var onInitializationComplete: (() -> Void)?
    
    func initialize() {
        Task {
            // Start timeout protection
            let timeoutTask = Task {
                try? await Task.sleep(for: .seconds(maxInitializationTime))
                if !initializationComplete {
                    print("⚠️ Initialization timeout - forcing completion")
                    forceComplete()
                }
            }
            
            await performInitialization()
            timeoutTask.cancel()
        }
    }
    
    private func forceComplete() {
        guard !initializationComplete else { return }
        initializationComplete = true
        onProgressUpdate?(.ready, 1.0)
        onInitializationComplete?()
    }
    
    private func performInitialization() async {
        guard !initializationComplete else { return }
        
        // Phase 1: Basic initialization (15%)
        onProgressUpdate?(.initializing, 0.0)
        try? await Task.sleep(for: .milliseconds(200)) // Reduced delay
        onProgressUpdate?(.initializing, 0.15)
        
        // Phase 2: Configure Google Maps (35%)
        onProgressUpdate?(.configuringMaps, 0.15)
        await configureGoogleMaps()
        onProgressUpdate?(.configuringMaps, 0.35)
        
        // Phase 3: Request location permissions and get location (65%)
        onProgressUpdate?(.requestingLocation, 0.35)
        await requestLocationAndWait()
        onProgressUpdate?(.requestingLocation, 0.65)
        
        // Phase 4: Final map preparation (85%)
        onProgressUpdate?(.loadingMapData, 0.65)
        await prepareMap()
        onProgressUpdate?(.loadingMapData, 0.85)
        
        // Phase 5: Final preparations - progress bar should be at 85%, not 100%
        onProgressUpdate?(.ready, 0.85)
        
        initializationComplete = true
        onInitializationComplete?()
    }
    
    private func configureGoogleMaps() async {
        // Configure Google Maps SDK synchronously (no delay needed)
        GoogleMapsConfiguration.shared.configure()
        
        // Validate API key
        let isValidKey = GoogleMapsConfiguration.shared.validateAPIKey()
        if !isValidKey {
            print("⚠️ Warning: Google Maps API key not properly configured")
        }
        
        print("✅ Google Maps configuration completed")
    }
    
    private func requestLocationAndWait() async {
        // Request location permission
        locationManager.requestLocation()
        
        // Wait for permission status to be determined, but don't wait too long
        var attempts = 0
        let maxAttempts = 20 // Reduced to 2 seconds maximum
        
        while attempts < maxAttempts {
            let status = locationManager.authorizationStatus
            
            // If permission is determined (granted or denied), we can continue
            if status != .notDetermined {
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    print("✅ Location permission granted")
                    // Don't wait for actual location, just permission
                } else {
                    print("⚠️ Location permission denied, but continuing...")
                }
                return
            }
            
            try? await Task.sleep(for: .milliseconds(100))
            attempts += 1
        }
        
        print("⚠️ Location permission timeout, continuing anyway")
    }
    
    private func prepareMap() async {
        // Minimal delay for map preparation
        try? await Task.sleep(for: .milliseconds(300))
        print("✅ Map ready for display")
    }
}

struct LaunchScreenView: View {
    let progress: Double
    let currentPhase: LoadingPhase
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Your app logo/icon here
                Image(systemName: "map.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .scaleEffect(progress > 0 ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                
                Text("RizQPay")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(progress > 0.05 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: progress)
                
                // Progress Bar
                VStack(spacing: 16) {
                    // Progress Bar Background
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5))
                            .frame(width: 220, height: 10)
                        
                        // Progress Bar Fill with enhanced gradient
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .orange.opacity(0.8), .yellow.opacity(0.6)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(4, 220 * progress), height: 10) // Minimum width for visibility
                            .animation(.easeInOut(duration: 0.3), value: progress)
                            .overlay(
                                // Animated shimmer effect when progress is moving
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 40, height: 10)
                                    .offset(x: progress > 0 ? -110 + (220 * progress) : -110)
                                    .animation(.easeInOut(duration: 0.3), value: progress)
                                    .opacity(progress > 0.05 && progress < 0.99 ? 0.9 : 0)
                            )
                    }
                    
                    // Progress Percentage and Phase Text
                    VStack(spacing: 8) {
                        Text("\(Int(progress * 100))%")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .contentTransition(.numericText())
                            .animation(.easeInOut(duration: 0.3), value: progress)
                        
                        Text(currentPhase.displayText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                            .contentTransition(.opacity)
                            .animation(.easeInOut(duration: 0.2), value: currentPhase.displayText)
                        
                        // Loading indicator dots
                        HStack(spacing: 4) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color.orange.opacity(0.6))
                                    .frame(width: 6, height: 6)
                                    .scaleEffect(progress < 0.99 ? (index == Int((progress * 12).truncatingRemainder(dividingBy: 3)) ? 1.3 : 0.8) : 1.0)
                                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: progress < 0.99)
                            }
                        }
                        .opacity(progress > 0.05 && progress < 0.99 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                    }
                }
                .opacity(progress > 0.02 ? 1 : 0)
                .animation(.easeInOut(duration: 0.4).delay(0.1), value: progress)
            }
        }
    }
}

#Preview {
    ContentView()
}
