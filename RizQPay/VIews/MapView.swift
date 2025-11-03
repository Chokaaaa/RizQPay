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
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BusinessMarkerTapped"))) { notification in
                if let business = notification.object as? BusinessLocation {
                    selectedBusiness = business
                    showingBusinessDetail = true
                }
            }
            .navigationDestination(isPresented: $showingBusinessDetail) {
                if let business = selectedBusiness {
                    BusinessDetailView(business: business, locationManager: locationManager)
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
}

#Preview {
    MapView()
}
