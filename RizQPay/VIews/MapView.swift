//
//  MapView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Main Map View
struct MapView: View {
    @State private var showingCamera = false
    @State private var showingProfile = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapContentView(locationManager: locationManager)
                MapOverlayView(
                    locationManager: locationManager,
                    onProfileTap: handleProfileTap,
                    onCameraTap: handleCameraTap,
                    onLocationTap: handleLocationTap
                )
            }
        }
        .fullScreenCover(isPresented: $showingCamera) {
            QRScannerView()
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
