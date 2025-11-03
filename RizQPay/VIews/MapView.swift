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
                // Force map update whenever currentRoute changes
                if currentRoute != nil {
                    print("🗺️ Current route changed, forcing map update")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                // When BusinessDetailView is dismissed, force map to update
                if !isShowing {
                    // Small delay to ensure the view is fully dismissed before updating
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        // Get the business locations from GoogleMapsContentView
        let businesses = GoogleMapsContentView.getBusinessLocations()
        
        // Start background prefetch
        RouteCache.shared.prefetchRoutes(
            from: userLocation,
            to: businesses,
            locationManager: locationManager
        )
        
        print("🚀 Started background prefetch for \(businesses.count) business locations")
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
