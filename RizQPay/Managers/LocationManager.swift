//
//  LocationManager.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import Foundation
import CoreLocation
import MapKit
import Contacts

// MARK: - Mock Route for Fallback
class MockRoute: MKRoute {
    private let _polyline: MKPolyline
    private let _distance: CLLocationDistance
    
    init(polyline: MKPolyline, distance: CLLocationDistance) {
        _polyline = polyline
        _distance = distance
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var polyline: MKPolyline {
        return _polyline
    }
    
    override var distance: CLLocationDistance {
        return _distance
    }
    
    override var expectedTravelTime: TimeInterval {
        // Rough estimate: walking speed ~5 km/h
        return _distance / 1.39 // meters per second for walking
    }
}

// MARK: - Transport Type Extensions
extension MKDirectionsTransportType {
    var description: String {
        switch self {
        case .automobile:
            return "automobile"
        case .walking:
            return "walking"
        case .transit:
            return "transit"
        default:
            return "unknown"
        }
    }
}

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentRoute: MKRoute?
    @Published var isNavigating = false
    
    private let locationManager = CLLocationManager()
    private var shouldUpdateRegion = true // Flag to control region updates
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
    }
    
    func requestLocation() {
        print("🔍 Requesting location...")
        print("   Current authorization status: \(authorizationStatus)")
        print("   Location services enabled: \(CLLocationManager.locationServicesEnabled())")
        
        switch authorizationStatus {
        case .notDetermined:
            print("🔒 Requesting location permission...")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted, starting location updates...")
            locationManager.startUpdatingLocation()
            
            // Also request a one-time location fix
            locationManager.requestLocation()
        case .denied, .restricted:
            print("❌ Location access denied or restricted")
        @unknown default:
            print("⚠️ Unknown authorization status")
            break
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // Method to center map on user location manually
    func centerOnUser() {
        guard let location = location else { return }
        shouldUpdateRegion = true
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        shouldUpdateRegion = false
    }
    
    // Method to disable automatic region updates when user interacts with map
    func userDidInteractWithMap() {
        shouldUpdateRegion = false
    }
    
    // MARK: - Navigation Methods
    func startNavigation(to business: BusinessLocation) {
        // Enhanced validation
        guard let userLocation = location else {
            print("❌ User location not available. Please enable location services.")
            return
        }
        
        // Validate coordinates
        guard CLLocationCoordinate2DIsValid(userLocation.coordinate) else {
            print("❌ Invalid user location coordinates")
            return
        }
        
        guard CLLocationCoordinate2DIsValid(business.coordinate) else {
            print("❌ Invalid business location coordinates")
            return
        }
        
        print("🗺️ Starting navigation from \(userLocation.coordinate) to \(business.coordinate)")
        
        // Calculate distance to ensure it's reasonable for driving
        let distance = userLocation.distance(from: CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude))
        print("📏 Distance between points: \(String(format: "%.2f", distance / 1000)) km")
        
        // If distance is very short (< 100m), create direct route
        if distance < 100 {
            print("⚠️ Distance too short for routing, creating direct route")
            createStraightLineRoute(to: business, userLocation: userLocation)
            return
        }
        
        // Try automobile routing only (as requested)
        tryAutomobileNavigation(to: business, userLocation: userLocation)
    }
    
    private func tryAutomobileNavigation(to business: BusinessLocation, userLocation: CLLocation) {
        // First, try with simple placemarks (minimal metadata)
        trySimpleAutomobileRoute(to: business, userLocation: userLocation) { [weak self] success in
            if !success {
                // If simple route fails, try with detailed placemarks
                self?.tryDetailedAutomobileRoute(to: business, userLocation: userLocation)
            }
        }
    }
    
    private func trySimpleAutomobileRoute(to business: BusinessLocation, userLocation: CLLocation, completion: @escaping (Bool) -> Void) {
        print("🔄 Trying simple automobile route...")
        
        // Create simple placemarks without extra metadata
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: business.coordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        Task {
            do {
                let response = try await directions.calculate()
                
                await MainActor.run {
                    if let route = response.routes.first {
                        print("✅ Simple automobile route calculated successfully!")
                        print("📏 Route distance: \(String(format: "%.2f", route.distance / 1000)) km")
                        print("⏱️ Expected travel time: \(Int(route.expectedTravelTime / 60)) minutes")
                        
                        self.currentRoute = route
                        self.isNavigating = true
                        self.updateRegionForRoute(route)
                        completion(true)
                    } else {
                        print("❌ No simple automobile routes found")
                        completion(false)
                    }
                }
            } catch {
                await MainActor.run {
                    print("❌ Simple automobile route failed: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    private func tryDetailedAutomobileRoute(to business: BusinessLocation, userLocation: CLLocation) {
        print("🔄 Trying detailed automobile route...")
        
        // Create more detailed placemarks with additional context
        let sourcePlacemark = MKPlacemark(
            coordinate: userLocation.coordinate,
            addressDictionary: [
                CNPostalAddressStreetKey: "Current Location"
            ]
        )
        
        let destinationPlacemark = MKPlacemark(
            coordinate: business.coordinate,
            addressDictionary: [
                CNPostalAddressStreetKey: business.title,
                "Name": business.title
            ]
        )
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        sourceMapItem.name = "Current Location"
        destinationMapItem.name = business.title
        
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        Task {
            do {
                let response = try await directions.calculate()
                
                await MainActor.run {
                    if let route = response.routes.first {
                        print("✅ Detailed automobile route calculated successfully!")
                        print("📏 Route distance: \(String(format: "%.2f", route.distance / 1000)) km")
                        print("⏱️ Expected travel time: \(Int(route.expectedTravelTime / 60)) minutes")
                        print("🛣️ Found \(response.routes.count) route(s)")
                        
                        self.currentRoute = route
                        self.isNavigating = true
                        self.updateRegionForRoute(route)
                    } else {
                        print("❌ No detailed automobile routes found, creating direct line route")
                        self.createStraightLineRoute(to: business, userLocation: userLocation)
                    }
                }
            } catch let error as NSError {
                await MainActor.run {
                    print("❌ Failed to calculate detailed automobile route:")
                    print("   Error Code: \(error.code)")
                    print("   Description: \(error.localizedDescription)")
                    print("   Domain: \(error.domain)")
                    
                    // Create a direct line route when automobile routing fails completely
                    print("⚠️ All automobile routing failed. Creating direct line route as fallback...")
                    self.createStraightLineRoute(to: business, userLocation: userLocation)
                    
                    // Log specific error details for debugging
                    self.logRoutingError(error)
                }
            }
        }
    }
    
    private func updateRegionForRoute(_ route: MKRoute) {
        let routeRect = route.polyline.boundingMapRect
        let region = MKCoordinateRegion(routeRect)
        
        // Add some padding around the route (minimum span to avoid too zoomed in)
        let minSpan: Double = 0.01 // Minimum span to prevent over-zooming
        self.region = MKCoordinateRegion(
            center: region.center,
            span: MKCoordinateSpan(
                latitudeDelta: max(region.span.latitudeDelta * 1.5, minSpan),
                longitudeDelta: max(region.span.longitudeDelta * 1.5, minSpan)
            )
        )
        self.shouldUpdateRegion = false
    }
    
    private func logRoutingError(_ error: NSError) {
        switch error.code {
        case Int(MKError.directionsNotFound.rawValue):
            print("💡 MKError.directionsNotFound: No driving route found between these locations")
            print("💡 This often happens in areas without detailed road data or remote locations")
        case Int(MKError.serverFailure.rawValue):
            print("💡 MKError.serverFailure: Apple's routing service temporarily unavailable")
        case Int(MKError.loadingThrottled.rawValue):
            print("💡 MKError.loadingThrottled: Too many requests, wait before trying again")
        case Int(MKError.placemarkNotFound.rawValue):
            print("💡 MKError.placemarkNotFound: Unable to resolve location coordinates")
        default:
            print("💡 Unknown routing error: \(error.code)")
            
            // Check if it's a network-related error by examining the domain
            if error.domain == NSURLErrorDomain {
                print("💡 Network-related error detected")
            }
        }
    }
    
    private func createStraightLineRoute(to business: BusinessLocation, userLocation: CLLocation) {
        // Create a simple polyline from user location to business
        let coordinates = [userLocation.coordinate, business.coordinate]
        let polyline = MKPolyline(coordinates: coordinates, count: 2)
        
        // Create a mock route with the polyline
        let mockRoute = MockRoute(polyline: polyline, distance: userLocation.distance(from: CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude)))
        
        self.currentRoute = mockRoute
        self.isNavigating = true
        
        // Set region to show both points
        let centerLat = (userLocation.coordinate.latitude + business.coordinate.latitude) / 2
        let centerLng = (userLocation.coordinate.longitude + business.coordinate.longitude) / 2
        let latDelta = abs(userLocation.coordinate.latitude - business.coordinate.latitude) * 1.5
        let lngDelta = abs(userLocation.coordinate.longitude - business.coordinate.longitude) * 1.5
        
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng),
            span: MKCoordinateSpan(latitudeDelta: max(latDelta, 0.01), longitudeDelta: max(lngDelta, 0.01))
        )
        self.shouldUpdateRegion = false
        
        print("✅ Created direct line route as fallback")
    }
    
    func stopNavigation() {
        currentRoute = nil
        isNavigating = false
    }
    
    // MARK: - Helper Methods
    func checkLocationPermissions() -> Bool {
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    func isLocationAvailable() -> Bool {
        return location != nil && checkLocationPermissions()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("📍 Location updated: \(location.coordinate)")
        print("   Accuracy: \(location.horizontalAccuracy) meters")
        print("   Timestamp: \(location.timestamp)")
        
        self.location = location
        
        // Only update region if it's the first time getting location or explicitly requested
        if shouldUpdateRegion {
            print("🗺️ Updating map region to user location")
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            shouldUpdateRegion = false // Prevent further automatic updates
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("   Location is currently unknown, but Core Location will keep trying")
            case .denied:
                print("   Location services are disabled or denied")
            case .network:
                print("   Network error occurred")
            default:
                print("   Other location error: \(clError.localizedDescription)")
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("🔒 Authorization status changed to: \(manager.authorizationStatus)")
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted")
            shouldUpdateRegion = true // Allow initial centering when permission is granted
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        case .denied, .restricted:
            print("❌ Location permission denied or restricted")
        case .notDetermined:
            print("🔒 Location permission not determined")
        @unknown default:
            print("⚠️ Unknown authorization status")
            break
        }
    }
}
