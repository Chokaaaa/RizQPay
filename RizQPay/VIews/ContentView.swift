//
//  ContentView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 24/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var hasRequestedLocation = false
    @State private var loadingProgress: Double = 0.0
    @State private var loadingTask: Task<Void, Never>?
    
    var body: some View {
        if isLoading {
            LaunchScreenView(progress: loadingProgress)
                .onAppear {
                    startProgressAnimation()
                }
                .onDisappear {
                    // Cancel loading task if view disappears
                    loadingTask?.cancel()
                }
        } else {
            MapView()
        }
    }
    
    private func startProgressAnimation() {
        // Cancel any existing task
        loadingTask?.cancel()
        
        loadingTask = Task { @MainActor in
            // Simulate actual loading phases with realistic progress updates
            let phases = [
                ("Initializing...", 0.2, 0.3),
                ("Loading maps...", 0.5, 0.4),
                ("Getting location...", 0.8, 0.4),
                ("Ready!", 1.0, 0.3)
            ]
            
            for (_, targetProgress, duration) in phases {
                // Check if task was cancelled
                if Task.isCancelled { return }
                
                // Animate to target progress
                withAnimation(.easeInOut(duration: duration)) {
                    loadingProgress = targetProgress
                }
                
                // Wait for animation to complete
                try? await Task.sleep(for: .seconds(duration))
            }
            
            // Final transition to main view
            if !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.2))
                withAnimation(.easeInOut(duration: 0.3)) {
                    isLoading = false
                }
            }
        }
    }
}

struct LaunchScreenView: View {
    let progress: Double
    @State private var currentPhaseText = "Initializing..."
    
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
                    .opacity(progress > 0.1 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.2), value: progress)
                
                // Progress Bar
                VStack(spacing: 16) {
                    // Progress Bar Background
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                            .frame(width: 200, height: 8)
                        
                        // Progress Bar Fill with gradient
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.orange, .orange.opacity(0.7)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(8, 200 * progress), height: 8)
                            .animation(.easeInOut(duration: 0.3), value: progress)
                    }
                    
                    // Progress Percentage and Phase Text
                    VStack(spacing: 4) {
                        Text("\(Int(progress * 100))%")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                        
                        Text(getPhaseText(for: progress))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                            .animation(.easeInOut(duration: 0.2), value: progress)
                    }
                }
                .opacity(progress > 0.05 ? 1 : 0)
                .animation(.easeInOut(duration: 0.3).delay(0.1), value: progress)
            }
        }
    }
    
    private func getPhaseText(for progress: Double) -> String {
        switch progress {
        case 0..<0.3:
            return "Initializing..."
        case 0.3..<0.6:
            return "Loading maps..."
        case 0.6..<0.9:
            return "Getting location..."
        case 0.9...:
            return "Ready!"
        default:
            return "Starting up..."
        }
    }
}

#Preview {
    ContentView()
}
