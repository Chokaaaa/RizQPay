//
//  BusinessDetailView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI

// MARK: - Business Detail Views (Google Maps Compatible)
struct BusinessDetailView: View {
    let business: BusinessLocation
    let locationManager: GoogleMapsLocationManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingNavigationAlert = false
    @State private var navigationMessage = ""
    @State private var isStartingNavigation = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    BusinessImageSection(business: business)
                    BusinessInfoSection(business: business)
                    BusinessContactSection(business: business)
                    
                    if isStartingNavigation {
                        VStack(spacing: 12) {
                            ProgressView("Starting navigation...")
                            Text("Calculating route to \(business.title)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            
            // Navigation Controls at bottom
            VStack(spacing: 12) {
                // Get Directions Button
                Button(action: {
                    startNavigation()
                }) {
                    HStack {
                        Image(systemName: isStartingNavigation ? "location.circle" : "location.fill")
                        Text(isStartingNavigation ? "Starting Navigation..." : "Get Directions")
                        
                        if isStartingNavigation {
                            Spacer()
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(locationManager.isLocationAvailable() && !isStartingNavigation ? Color.blue : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(!locationManager.isLocationAvailable() || isStartingNavigation)
            }
            .padding()
        }
        .navigationTitle(business.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Navigation Status", isPresented: $showingNavigationAlert) {
            Button("OK") { }
        } message: {
            Text(navigationMessage)
        }
    }
    
    private func startNavigation() {
        guard locationManager.checkLocationPermissions() else {
            navigationMessage = "Location permission is required to provide directions. Please enable location access in Settings."
            showingNavigationAlert = true
            return
        }
        
        guard let userLocation = locationManager.location else {
            navigationMessage = "Unable to get your current location. Please make sure location services are enabled."
            showingNavigationAlert = true
            return
        }
        
        isStartingNavigation = true
        
        Task {
            do {
                // Get the first available route (driving mode by default)
                let routes = try await locationManager.getAlternativeRoutes(
                    from: userLocation.coordinate,
                    to: business.coordinate,
                    transportMode: .driving
                )
                
                await MainActor.run {
                    if let firstRoute = routes.first {
                        // Set the route and start navigation
                        locationManager.currentRoute = firstRoute
                        locationManager.isNavigating = true
                        locationManager.updateCameraForRoute(firstRoute)
                        
                        // Close the detail view to show the map
                        dismiss()
                    } else {
                        isStartingNavigation = false
                        navigationMessage = "Unable to find a route to this location. Please try again."
                        showingNavigationAlert = true
                    }
                }
            } catch {
                await MainActor.run {
                    print("Error starting navigation: \(error.localizedDescription)")
                    isStartingNavigation = false
                    navigationMessage = "Unable to start navigation. Please try again."
                    showingNavigationAlert = true
                }
            }
        }
    }
}

struct BusinessImageSection: View {
    let business: BusinessLocation
    
    var body: some View {
        Image(business.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct BusinessInfoSection: View {
    let business: BusinessLocation
    
    var body: some View {
        VStack(spacing: 12) {
            Text(business.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Business Details")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct BusinessContactSection: View {
    let business: BusinessLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ContactRow(
                icon: "location",
                text: String(format: "Location: %.4f, %.4f", business.coordinate.latitude, business.coordinate.longitude)
            )
            
            ContactRow(
                icon: "clock",
                text: "Open: 9:00 AM - 10:00 PM"
            )
            
            ContactRow(
                icon: "phone",
                text: "+971 50 123 4567"
            )
        }
    }
}

struct ContactRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .font(.body)
        .foregroundColor(.secondary)
    }
}
