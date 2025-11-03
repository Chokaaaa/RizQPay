//
//  BusinessDetailView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI
import CoreLocation
import GoogleMaps

// MARK: - Business Detail Views (Google Maps Compatible)
struct BusinessDetailView: View {
    let business: BusinessLocation
    let locationManager: GoogleMapsLocationManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingNavigationAlert = false
    @State private var navigationMessage = ""
    @State private var isStartingNavigation = false
    @State private var isViewReady = false
    @State private var estimatedTravelTime: String = ""
    @State private var estimatedDistance: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Content loads immediately with static data
            ScrollView {
                VStack(spacing: 20) {
                    // Fast-loading sections without heavy computations
                    BusinessImageSection(business: business)
                    BusinessInfoSection(business: business)
                    
                    // Quick estimate section - shows immediately
                    if !estimatedTravelTime.isEmpty {
                        QuickEstimateSection(
                            distance: estimatedDistance,
                            travelTime: estimatedTravelTime
                        )
                    }
                    
                    BusinessContactSection(business: business)
                    
                    if isStartingNavigation {
                        NavigationLoadingView(businessTitle: business.title)
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            
            // Navigation Controls - simplified for faster rendering
            NavigationButtonSection(
                isStartingNavigation: isStartingNavigation,
                isLocationAvailable: isViewReady ? locationManager.isLocationAvailable() : true,
                onNavigationTapped: startNavigation
            )
        }
        .navigationTitle(business.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Navigation Status", isPresented: $showingNavigationAlert) {
            Button("OK") { }
        } message: {
            Text(navigationMessage)
        }
        .task {
            // Fast setup with immediate UI feedback
            await setupViewOptimized()
        }
    }
    
    @MainActor
    private func setupViewOptimized() async {
        // Immediately show UI is ready
        isViewReady = true
        
        // Calculate quick estimate without API call
        if let userLocation = locationManager.location {
            let businessLocation = CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude)
            let distance = userLocation.distance(from: businessLocation)
            
            // Use driving speed estimate for quick calculation
            let estimatedDuration = distance / TransportMode.driving.estimatedSpeed
            
            estimatedDistance = String(format: "%.1f km", distance / 1000)
            estimatedTravelTime = String(format: "~%d min", Int(estimatedDuration / 60))
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
        
        // Use optimized navigation approach
        Task {
            await startOptimizedNavigation(from: userLocation)
        }
    }
    
    @MainActor
    private func startOptimizedNavigation(from userLocation: CLLocation) async {
        do {
            let distance = userLocation.distance(from: CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude))
            
            // For very short distances, always use direct route
            if distance < 200 {
                let directRoute = createDirectRoute(from: userLocation.coordinate, to: business.coordinate)
                locationManager.currentRoute = directRoute
                locationManager.isNavigating = true
                locationManager.updateCameraForRoute(directRoute)
                
                // Ensure the map will show the polyline when we return
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    locationManager.forceMapUpdate()
                }
                
                dismiss()
                return
            }
            
            // Check if we have a cached route first (even expired ones as fallback)
            let cachedRoute = RouteCache.shared.getCachedRoute(
                from: userLocation.coordinate,
                to: business.coordinate,
                transportMode: .driving
            )
            
            if let route = cachedRoute {
                // Use cached route immediately
                print("✅ Using cached route for instant navigation")
                locationManager.currentRoute = route
                locationManager.isNavigating = true
                locationManager.updateCameraForRoute(route)
                
                // Ensure the map will show the polyline when we return
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    locationManager.forceMapUpdate()
                }
                
                dismiss()
                return
            }
            
            // Try to fetch fresh route with timeout
            let routes = try await withTimeout(seconds: 3) { // Reduced timeout for faster fallback
                try await locationManager.getAlternativeRoutes(
                    from: userLocation.coordinate,
                    to: business.coordinate,
                    transportMode: .driving
                )
            }
            
            if let firstRoute = routes.first {
                locationManager.currentRoute = firstRoute
                locationManager.isNavigating = true
                locationManager.updateCameraForRoute(firstRoute)
                
                // Ensure the map will show the polyline when we return
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    locationManager.forceMapUpdate()
                }
                
                dismiss()
            } else {
                fallbackToDirectRoute(from: userLocation.coordinate)
            }
            
        } catch {
            print("Navigation error: \(error.localizedDescription)")
            
            // Try to use an expired cached route as emergency fallback
            if let expiredRoute = RouteCache.shared.getCachedRouteEvenIfExpired(
                from: userLocation.coordinate,
                to: business.coordinate,
                transportMode: .driving
            ) {
                print("⚠️ Using expired cached route as emergency fallback")
                locationManager.currentRoute = expiredRoute
                locationManager.isNavigating = true
                locationManager.updateCameraForRoute(expiredRoute)
                
                // Ensure the map will show the polyline when we return
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    locationManager.forceMapUpdate()
                }
                
                dismiss()
                return
            }
            
            // Last resort: direct route
            fallbackToDirectRoute(from: userLocation.coordinate)
        }
    }
    
    private func fallbackToDirectRoute(from userCoordinate: CLLocationCoordinate2D) {
        let directRoute = createDirectRoute(from: userCoordinate, to: business.coordinate)
        locationManager.currentRoute = directRoute
        locationManager.isNavigating = true
        locationManager.updateCameraForRoute(directRoute)
        isStartingNavigation = false
        
        // Ensure the map will show the polyline when we return
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            locationManager.forceMapUpdate()
        }
        
        dismiss()
    }
    
    private func createDirectRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> GoogleMapsRoute {
        let path = GMSMutablePath()
        path.add(start)
        path.add(end)
        
        let distance = CLLocation(latitude: start.latitude, longitude: start.longitude)
            .distance(from: CLLocation(latitude: end.latitude, longitude: end.longitude))
        
        let estimatedDuration = distance / TransportMode.driving.estimatedSpeed
        
        return GoogleMapsRoute(
            path: path,
            distance: distance,
            duration: estimatedDuration,
            transportMode: .driving
        )
    }
}

// MARK: - Optimized Helper Views for Fast Loading

struct QuickEstimateSection: View {
    let distance: String
    let travelTime: String
    
    var body: some View {
        GroupBox("Quick Estimate") {
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "location.circle")
                                .foregroundColor(.blue)
                            Text(distance)
                        }
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                            Text(travelTime)
                        }
                    }
                    Spacer()
                    Text("Driving")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                // Add cache status indicator
                CacheStatusIndicator()
            }
        }
    }
}

// Timeout helper function
func withTimeout<T>(seconds: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
    return try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }
        
        group.addTask {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            throw TimeoutError()
        }
        
        guard let result = try await group.next() else {
            throw TimeoutError()
        }
        
        group.cancelAll()
        return result
    }
}

struct TimeoutError: Error {
    let localizedDescription = "Operation timed out"
}

struct NavigationLoadingView: View {
    let businessTitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            ProgressView("Starting navigation...")
            Text("Calculating route to \(businessTitle)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

struct NavigationButtonSection: View {
    let isStartingNavigation: Bool
    let isLocationAvailable: Bool
    let onNavigationTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: onNavigationTapped) {
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
                .background(isLocationAvailable && !isStartingNavigation ? Color.blue : Color.gray)
                .cornerRadius(12)
            }
            .disabled(!isLocationAvailable || isStartingNavigation)
        }
        .padding()
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

// MARK: - Cache Status Indicator

struct CacheStatusIndicator: View {
    @State private var hasCachedRoute = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: hasCachedRoute ? "checkmark.circle.fill" : "arrow.down.circle")
                .foregroundColor(hasCachedRoute ? .green : .blue)
                .font(.caption)
            
            Text(hasCachedRoute ? "Route ready" : "Will download route")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .onAppear {
            hasCachedRoute = RouteCache.shared.hasAnyCachedRoutes()
        }
    }
}
