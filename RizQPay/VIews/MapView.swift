//
//  MapView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - Main Map View (Google Maps)
struct MapView: View {
    @State private var showingCamera = false
    @State private var showingProfile = false
    @State private var selectedBusiness: BusinessLocation?
    @State private var showingBusinessDetail = false
    @StateObject private var locationManager = GoogleMapsLocationManager()
    @State private var hasTriggeredPrefetch = false
    
    // Static notification name for performance
    private static let businessMarkerTappedNotification = NSNotification.Name("BusinessMarkerTapped")
    
    var body: some View {
        NavigationStack {
            ZStack {
                GoogleMapsContentView(locationManager: locationManager)
                MapOverlayView(
                    locationManager: locationManager,
                    onProfileTap: handleProfileTap,
                    onCameraTap: handleCameraTap,
                    onLocationTap: handleLocationTap
                )
            }
            .onReceive(NotificationCenter.default.publisher(for: Self.businessMarkerTappedNotification)) { notification in
                // Handle business marker tap immediately
                if let business = notification.object as? BusinessLocation {
                    selectedBusiness = business
                    showingBusinessDetail = true
                }
            }
            .onReceive(locationManager.$location) { location in
                // Trigger background prefetch when location becomes available
                if let userLocation = location, !hasTriggeredPrefetch {
                    hasTriggeredPrefetch = true
                    
                    // Store location for background tasks
                    storeLocationForBackground(userLocation.coordinate)
                    
                    // Trigger immediate prefetch
                    triggerBackgroundPrefetch(from: userLocation.coordinate)
                }
            }
            .onReceive(locationManager.$currentRoute) { currentRoute in
                // Optimize map updates for energy efficiency
                if currentRoute != nil {
                    print("🗺️ Current route changed, updating map efficiently")
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(200))
                        locationManager.forceMapUpdate()
                    }
                }
            }
            .fullScreenCover(isPresented: $showingBusinessDetail) {
                if let business = selectedBusiness {
                    NavigationStack {
                        BusinessDetailView(business: business, locationManager: locationManager)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Close") {
                                        showingBusinessDetail = false
                                    }
                                }
                            }
                    }
                }
            }
            .onChange(of: showingBusinessDetail) { isShowing in
                // When BusinessDetailView is dismissed, update map efficiently
                if !isShowing {
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(100))
                        locationManager.forceMapUpdate()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingCamera) {
            QRCodeScannerView()
        }
        .fullScreenCover(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

// MARK: - MapView Actions
extension MapView {
    private func handleProfileTap() {
        showingProfile = true
    }
    
    private func handleCameraTap() {
        showingCamera = true
    }
    
    private func handleLocationTap() {
        locationManager.centerOnUser()
    }
    
    /// Trigger background prefetching of routes to all business locations
    private func triggerBackgroundPrefetch(from userLocation: CLLocationCoordinate2D) {
        // Background prefetching disabled for energy efficiency
        let businesses = GoogleMapsContentView.getBusinessLocations()
        print("⚡ Background prefetch disabled for energy efficiency - routes will be calculated on demand for \(businesses.count) business locations")
        
        // Stop continuous location updates to save energy once we have initial location
        locationManager.stopUpdatingLocation()
    }
    
    /// Store user location for background tasks
    private func storeLocationForBackground(_ location: CLLocationCoordinate2D) {
        if let locationData = try? JSONEncoder().encode(location) {
            UserDefaults.standard.set(locationData, forKey: "lastKnownLocation")
            print("📍 Stored location for background tasks")
        }
    }
}

#Preview {
    MapView()
}
