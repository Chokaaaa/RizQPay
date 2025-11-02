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
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapContentView(locationManager: locationManager)
                MapOverlayView(
                    onProfileTap: handleProfileTap,
                    onCameraTap: handleCameraTap,
                    onLocationTap: handleLocationTap
                )
            }
        }
        .fullScreenCover(isPresented: $showingCamera) {
            QRScannerView()
        }
    }
}

// MARK: - MapView Actions
extension MapView {
    private func handleProfileTap() {
        // TODO: Implement profile action
        print("Profile tapped")
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
