//
//  GoogleMapsLocationManager.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import Foundation
import CoreLocation
import GoogleMaps


/// Transport modes for routing
enum TransportMode: String, CaseIterable {
    case driving = "driving"
    case walking = "walking"
    case bicycling = "bicycling"
    case transit = "transit"
    
    var displayName: String {
        switch self {
        case .driving: return "Driving"
        case .walking: return "Walking"
        case .bicycling: return "Bicycling"
        case .transit: return "Public Transit"
        }
    }
    
    var estimatedSpeed: Double { // meters per second
        switch self {
        case .driving: return 13.9 // ~50 km/h
        case .walking: return 1.39 // ~5 km/h
        case .bicycling: return 4.17 // ~15 km/h
        case .transit: return 8.33 // ~30 km/h
        }
    }
    
    /// Routes API travel mode value
    var routesAPIValue: String {
        switch self {
        case .driving: return "DRIVE"
        case .walking: return "WALK"
        case .bicycling: return "BICYCLE"
        case .transit: return "TRANSIT"
        }
    }
}

/// Google Maps route wrapper to maintain compatibility with existing code
class GoogleMapsRoute {
    let path: GMSPath
    let polyline: GMSPolyline
    let distance: CLLocationDistance
    let duration: TimeInterval
    let bounds: GMSCoordinateBounds
    let transportMode: TransportMode
    
    init(path: GMSPath, distance: CLLocationDistance, duration: TimeInterval, transportMode: TransportMode = .driving) {
        self.path = path
        self.distance = distance
        self.duration = duration
        self.transportMode = transportMode
        self.polyline = GMSPolyline(path: path)
        self.bounds = GMSCoordinateBounds(path: path)
        
        // Configure polyline appearance based on transport mode
        configurePolylineAppearance()
    }
    
    private func configurePolylineAppearance() {
        // Make polyline clearly visible with enhanced styling
        polyline.strokeWidth = 6.0
        polyline.zIndex = 100 // Ensure it appears above other map elements
        
        switch transportMode {
        case .driving:
            polyline.strokeColor = .systemBlue
            // Create a solid blue line with border for better visibility
            let borderSpan = GMSStyleSpan(color: UIColor.white.withAlphaComponent(0.8))
            let mainSpan = GMSStyleSpan(color: .systemBlue)
            polyline.spans = [mainSpan]
        case .walking:
            polyline.strokeColor = .systemGreen
            polyline.strokeWidth = 5.0
            // Create dashed pattern for walking
            let solidSpan = GMSStyleSpan(color: .systemGreen, segments: 10)
            let gapSpan = GMSStyleSpan(color: .clear, segments: 5)
            polyline.spans = [solidSpan, gapSpan]
        case .bicycling:
            polyline.strokeColor = .systemOrange
            polyline.strokeWidth = 5.0
            // Create different dash pattern for bicycling
            let solidSpan = GMSStyleSpan(color: .systemOrange, segments: 15)
            let gapSpan = GMSStyleSpan(color: .clear, segments: 5)
            polyline.spans = [solidSpan, gapSpan]
        case .transit:
            polyline.strokeColor = .systemPurple
            polyline.strokeWidth = 5.0
            // Create longer dash pattern for transit
            let solidSpan = GMSStyleSpan(color: .systemPurple, segments: 20)
            let gapSpan = GMSStyleSpan(color: .clear, segments: 10)
            polyline.spans = [solidSpan, gapSpan]
        }
        
        // Add debug logging
        print("🗺️ DEBUG: Configured polyline - Color: \(polyline.strokeColor), Width: \(polyline.strokeWidth), ZIndex: \(polyline.zIndex)")
    }
}

/// Google Routes API response structure for easier parsing
struct GoogleRoutesResponse: Codable {
    let routes: [Route]
    
    struct Route: Codable {
        let distanceMeters: Int?
        let duration: String?
        let polyline: Polyline
        let legs: [Leg]?
        
        struct Polyline: Codable {
            let encodedPolyline: String
        }
        
        struct Leg: Codable {
            let distanceMeters: Int?
            let duration: String?
        }
    }
}

@MainActor
class GoogleMapsLocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentRoute: GoogleMapsRoute?
    @Published var isNavigating = false
    @Published var errorMessage: String?
    
    // Google Maps specific properties
    @Published var mapView: GMSMapView?
    @Published var camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 15.0)
    
    // Performance optimization properties
    private var _hasPendingCameraUpdate = false
    var isUpdatingCamera = false
    private var lastUserGestureUpdate = Date()
    
    private let locationManager = CLLocationManager()
    private let apiKey = GoogleMapsConfiguration.shared.getAPIKey()
    
    /// Create a properly configured URLRequest for Routes API calls
    private func createRoutesAPIRequest(for endpoint: String) -> URLRequest? {
        let urlString = "\(endpoint)?key=\(apiKey)"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Add bundle identifier for iOS authentication
        if let bundleId = Bundle.main.bundleIdentifier, !bundleId.isEmpty {
            request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
            print("🔍 DEBUG: Using bundle ID for authentication: \(bundleId)")
        } else {
            print("⚠️ WARNING: Bundle identifier not found")
        }
        
        return request
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        print("🗺️ GoogleMapsLocationManager initialized")
    }
    
    func requestLocation() {
        print("🔍 Requesting location...")
        print("   Current authorization status: \(authorizationStatus)")
        
        switch authorizationStatus {
        case .notDetermined:
            print("🔒 Requesting location permission...")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted, starting location updates...")
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        case .denied, .restricted:
            print("❌ Location access denied or restricted")
            errorMessage = "Location access denied. Please enable location services in Settings."
        @unknown default:
            print("⚠️ Unknown authorization status")
            break
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Center map on user location
    func centerOnUser() {
        guard let location = location else { return }
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
        updateCamera(camera, animated: true)
    }
    
    /// Update camera position
    func updateCamera(_ cameraPosition: GMSCameraPosition, animated: Bool = false) {
        isUpdatingCamera = true
        _hasPendingCameraUpdate = true
        camera = cameraPosition
        if animated {
            mapView?.animate(to: cameraPosition)
        } else {
            mapView?.camera = cameraPosition
        }
        
        // Small delay to prevent immediate feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isUpdatingCamera = false
        }
    }
    
    /// Handle camera updates from user gestures (throttled for performance)
    func updateCameraFromUserGesture(_ cameraPosition: GMSCameraPosition) {
        let now = Date()
        
        // Throttle user gesture updates to every 100ms for smooth performance
        guard now.timeIntervalSince(lastUserGestureUpdate) > 0.1 else { return }
        
        lastUserGestureUpdate = now
        camera = cameraPosition
    }
    
    /// Clear pending camera update flag
    func clearPendingCameraUpdate() {
        _hasPendingCameraUpdate = false
    }
    
    /// Check if there's a pending camera update
    var hasPendingCameraUpdate: Bool {
        return _hasPendingCameraUpdate
    }
    
    /// Set the map view reference
    func setMapView(_ mapView: GMSMapView) {
        self.mapView = mapView
    }
    
    // MARK: - Navigation Methods
    
    func startNavigation(to business: BusinessLocation, transportMode: TransportMode = .driving) {
        guard let userLocation = location else {
            errorMessage = "User location not available. Please enable location services."
            print("❌ User location not available")
            return
        }
        
        guard CLLocationCoordinate2DIsValid(userLocation.coordinate) else {
            errorMessage = "Invalid user location coordinates"
            print("❌ Invalid user location coordinates")
            return
        }
        
        guard CLLocationCoordinate2DIsValid(business.coordinate) else {
            errorMessage = "Invalid business location coordinates"
            print("❌ Invalid business location coordinates")
            return
        }
        
        let distance = userLocation.distance(from: CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude))
        print("🗺️ Starting navigation from \(userLocation.coordinate) to \(business.coordinate)")
        print("📏 Distance: \(String(format: "%.2f", distance / 1000)) km")
        
        // If distance is very short, create direct route
        if distance < 100 {
            print("⚠️ Distance too short for routing, creating direct route")
            createDirectRoute(to: business, userLocation: userLocation, transportMode: transportMode)
            return
        }
        
        // Calculate route using Google Routes API
        calculateRoute(from: userLocation.coordinate, to: business.coordinate, for: business, transportMode: transportMode)
    }
    
    private func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, for business: BusinessLocation, transportMode: TransportMode = .driving) {
        print("🔄 Calculating route using Google Routes API...")
        
        // Create URL for Google Routes API with API key parameter
        let baseURL = "https://routes.googleapis.com/directions/v2:computeRoutes?key=\(apiKey)"
        
        guard let url = URL(string: baseURL) else {
            print("❌ Failed to create URL")
            createDirectRoute(to: business, userLocation: CLLocation(latitude: source.latitude, longitude: source.longitude), transportMode: transportMode)
            return
        }
        
        // Create the request body for Routes API
        let requestBody: [String: Any] = [
            "origin": [
                "location": [
                    "latLng": [
                        "latitude": source.latitude,
                        "longitude": source.longitude
                    ]
                ]
            ],
            "destination": [
                "location": [
                    "latLng": [
                        "latitude": destination.latitude,
                        "longitude": destination.longitude
                    ]
                ]
            ],
            "travelMode": transportMode.routesAPIValue,
            "routingPreference": transportMode == .driving ? "TRAFFIC_AWARE" : "TRAFFIC_UNAWARE",
            "computeAlternativeRoutes": false,
            "routeModifiers": [
                "avoidTolls": false,
                "avoidHighways": false,
                "avoidFerries": false
            ],
            "languageCode": "en-US",
            "units": "IMPERIAL"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Add bundle identifier for iOS authentication
        if let bundleId = Bundle.main.bundleIdentifier, !bundleId.isEmpty {
            request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
            print("🔍 DEBUG: Using bundle ID for authentication: \(bundleId)")
        } else {
            print("⚠️ WARNING: Bundle identifier not found")
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("❌ Failed to serialize request body: \(error.localizedDescription)")
            createDirectRoute(to: business, userLocation: CLLocation(latitude: source.latitude, longitude: source.longitude), transportMode: transportMode)
            return
        }
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Routes API response status: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        if let errorString = String(data: data, encoding: .utf8) {
                            print("❌ Routes API error response: \(errorString)")
                        }
                    }
                }
                
                await MainActor.run {
                    parseRoutesResponse(data, for: business, transportMode: transportMode)
                }
            } catch {
                await MainActor.run {
                    print("❌ Routes API request failed: \(error.localizedDescription)")
                    createDirectRoute(to: business, userLocation: CLLocation(latitude: source.latitude, longitude: source.longitude), transportMode: transportMode)
                }
            }
        }
    }
    
    private func parseRoutesResponse(_ data: Data, for business: BusinessLocation, transportMode: TransportMode = .driving) {
        do {
            let response = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let routes = response?["routes"] as? [[String: Any]],
                  let route = routes.first else {
                print("❌ No routes found in response")
                createDirectRoute(to: business, userLocation: location, transportMode: transportMode)
                return
            }
            
            // Parse polyline from Routes API response
            guard let polyline = route["polyline"] as? [String: Any],
                  let encodedPolyline = polyline["encodedPolyline"] as? String else {
                print("❌ No polyline found in route")
                createDirectRoute(to: business, userLocation: location, transportMode: transportMode)
                return
            }
            
            // Parse distance and duration
            var distance: CLLocationDistance = 0
            var duration: TimeInterval = 0
            
            if let legs = route["legs"] as? [[String: Any]], let leg = legs.first {
                // Routes API returns distance and duration in different format
                if let distanceInfo = leg["distanceMeters"] as? Double {
                    distance = distanceInfo
                }
                if let durationInfo = leg["duration"] as? String {
                    // Duration comes as string like "123s", parse it
                    let durationSeconds = Double(durationInfo.replacingOccurrences(of: "s", with: "")) ?? 0
                    duration = durationSeconds
                }
            }
            
            // If we didn't get distance/duration from legs, try route level
            if distance == 0, let distanceMeters = route["distanceMeters"] as? Double {
                distance = distanceMeters
            }
            if duration == 0, let durationString = route["duration"] as? String {
                let durationSeconds = Double(durationString.replacingOccurrences(of: "s", with: "")) ?? 0
                duration = durationSeconds
            }
            
            // Decode polyline points
            guard let path = GMSPath(fromEncodedPath: encodedPolyline) else {
                print("❌ Failed to decode polyline")
                createDirectRoute(to: business, userLocation: location, transportMode: transportMode)
                return
            }
            
            // Create Google Maps route
            let googleRoute = GoogleMapsRoute(path: path, distance: distance, duration: duration, transportMode: transportMode)
            self.currentRoute = googleRoute
            self.isNavigating = true
            
            // Update camera to show the route
            updateCameraForRoute(googleRoute)
            
            print("✅ Google Routes API route calculated successfully!")
            print("📏 Route distance: \(String(format: "%.2f", distance / 1000)) km")
            print("⏱️ Expected travel time: \(Int(duration / 60)) minutes")
            print("🚗 Transport mode: \(transportMode.displayName)")
            
        } catch {
            print("❌ Failed to parse routes response: \(error.localizedDescription)")
            createDirectRoute(to: business, userLocation: location, transportMode: transportMode)
        }
    }
    
    private func createDirectRoute(to business: BusinessLocation, userLocation: CLLocation?, transportMode: TransportMode = .driving) {
        guard let userLocation = userLocation else { return }
        
        print("✅ Creating direct line route as fallback")
        
        // Create a path with just two points
        let path = GMSMutablePath()
        path.add(userLocation.coordinate)
        path.add(business.coordinate)
        
        let distance = userLocation.distance(from: CLLocation(latitude: business.coordinate.latitude, longitude: business.coordinate.longitude))
        let duration = distance / transportMode.estimatedSpeed
        
        let directRoute = GoogleMapsRoute(path: path, distance: distance, duration: duration, transportMode: transportMode)
        self.currentRoute = directRoute
        self.isNavigating = true
        
        // Update camera to show both points
        updateCameraForRoute(directRoute)
    }
    
    func updateCameraForRoute(_ route: GoogleMapsRoute) {
        let bounds = route.bounds
        
        // Add padding around the route
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        
        if let mapView = mapView {
            mapView.animate(with: update)
        } else {
            // Fallback: center on route
            let center = CLLocationCoordinate2D(
                latitude: (bounds.southWest.latitude + bounds.northEast.latitude) / 2,
                longitude: (bounds.southWest.longitude + bounds.northEast.longitude) / 2
            )
            let camera = GMSCameraPosition.camera(withTarget: center, zoom: 14.0)
            updateCamera(camera, animated: true)
        }
    }
    
    
    /// Get alternative routes for better route selection (with caching)
    func getAlternativeRoutes(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode = .driving) async throws -> [GoogleMapsRoute] {
        print("🔄 Fetching alternative routes using Google Routes API...")
        
        // Check cache first for performance
        if let cachedRoute = RouteCache.shared.getCachedRoute(from: source, to: destination, transportMode: transportMode) {
            print("✅ Using cached route")
            return [cachedRoute]
        }
        
        // Create URL for Google Routes API with API key parameter
        let baseURL = "https://routes.googleapis.com/directions/v2:computeRoutes?key=\(apiKey)"
        
        guard let url = URL(string: baseURL) else {
            throw NSError(domain: "GoogleRoutesError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])
        }
        
        // Create the request body for Routes API with alternatives enabled
        let requestBody: [String: Any] = [
            "origin": [
                "location": [
                    "latLng": [
                        "latitude": source.latitude,
                        "longitude": source.longitude
                    ]
                ]
            ],
            "destination": [
                "location": [
                    "latLng": [
                        "latitude": destination.latitude,
                        "longitude": destination.longitude
                    ]
                ]
            ],
            "travelMode": transportMode.routesAPIValue,
            "routingPreference": transportMode == .driving ? "TRAFFIC_AWARE" : "TRAFFIC_UNAWARE",
            "computeAlternativeRoutes": true, // Enable alternatives
            "routeModifiers": [
                "avoidTolls": false,
                "avoidHighways": false,
                "avoidFerries": false
            ],
            "languageCode": "en-US",
            "units": "IMPERIAL"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Add bundle identifier for iOS authentication
        if let bundleId = Bundle.main.bundleIdentifier, !bundleId.isEmpty {
            request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
            print("🔍 DEBUG: Using bundle ID for authentication: \(bundleId)")
        } else {
            print("⚠️ WARNING: Bundle identifier not found")
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if let errorString = String(data: data, encoding: .utf8) {
                print("❌ Routes API error response: \(errorString)")
            }
            throw NSError(domain: "GoogleRoutesError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Routes API returned status code: \(httpResponse.statusCode)"])
        }
        
        // Parse response using the structured approach
        do {
            let routesResponse = try JSONDecoder().decode(GoogleRoutesResponse.self, from: data)
            var routes: [GoogleMapsRoute] = []
            
            for route in routesResponse.routes {
                guard let path = GMSPath(fromEncodedPath: route.polyline.encodedPolyline) else {
                    continue
                }
                
                let distance = CLLocationDistance(route.distanceMeters ?? 0)
                let durationSeconds = Double(route.duration?.replacingOccurrences(of: "s", with: "") ?? "0") ?? 0
                
                let googleRoute = GoogleMapsRoute(
                    path: path,
                    distance: distance,
                    duration: durationSeconds,
                    transportMode: transportMode
                )
                
                routes.append(googleRoute)
            }
            
            print("✅ Retrieved \(routes.count) alternative routes")
            
            // Cache the first route if available
            if let firstRoute = routes.first {
                RouteCache.shared.cacheRoute(firstRoute, from: source, to: destination, transportMode: transportMode)
            }
            
            return routes
            
        } catch {
            // Fallback to manual JSON parsing if structured decoding fails
            print("⚠️ Structured decoding failed, falling back to manual parsing")
            return try parseRoutesManually(data, from: source, to: destination, transportMode: transportMode)
        }
    }
    
    private func parseRoutesManually(_ data: Data, from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode) throws -> [GoogleMapsRoute] {
        guard let response = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let routesArray = response["routes"] as? [[String: Any]] else {
            throw NSError(domain: "GoogleRoutesError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
        }
        
        var routes: [GoogleMapsRoute] = []
        
        for routeDict in routesArray {
            guard let polyline = routeDict["polyline"] as? [String: Any],
                  let encodedPolyline = polyline["encodedPolyline"] as? String,
                  let path = GMSPath(fromEncodedPath: encodedPolyline) else {
                continue
            }
            
            let distance = CLLocationDistance(routeDict["distanceMeters"] as? Int ?? 0)
            let durationString = routeDict["duration"] as? String ?? "0s"
            let durationSeconds = Double(durationString.replacingOccurrences(of: "s", with: "")) ?? 0
            
            let googleRoute = GoogleMapsRoute(
                path: path,
                distance: distance,
                duration: durationSeconds,
                transportMode: transportMode
            )
            
            routes.append(googleRoute)
        }
        
        // Cache the first route if available
        if let firstRoute = routes.first {
            RouteCache.shared.cacheRoute(firstRoute, from: source, to: destination, transportMode: transportMode)
        }
        
        return routes
    }
    
    func stopNavigation() {
        currentRoute = nil
        isNavigating = false
        print("🛑 Navigation stopped")
    }
    
    /// Force the map to update its polylines and display
    func forceMapUpdate() {
        // Trigger a property update that will cause SwiftUI to refresh the map
        objectWillChange.send()
        
        // If we have a current route, ensure it's properly displayed
        if let route = currentRoute {
            print("🔄 Forcing map update with current route")
            // Force the polyline to be re-added to the map
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let mapView = self.mapView else { return }
                
                // Remove existing polyline and re-add it
                route.polyline.map = nil
                
                // Re-configure polyline styling
                route.polyline.strokeColor = UIColor.systemBlue
                route.polyline.strokeWidth = 8.0
                route.polyline.zIndex = 1000
                route.polyline.geodesic = true
                
                // Add back to map
                route.polyline.map = mapView
                
                print("✅ Forced polyline update completed")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func checkLocationPermissions() -> Bool {
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    func isLocationAvailable() -> Bool {
        return location != nil && checkLocationPermissions()
    }
}

// MARK: - CLLocationManagerDelegate

extension GoogleMapsLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("📍 Location updated: \(location.coordinate)")
        print("   Accuracy: \(location.horizontalAccuracy) meters")
        
        self.location = location
        
        // Update camera to user location if it's the first time
        if camera.target.latitude == 37.7749 && camera.target.longitude == -122.4194 {
            let newCamera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15.0)
            updateCamera(newCamera, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                errorMessage = "Location is currently unknown, but trying to get location"
            case .denied:
                errorMessage = "Location services are disabled. Please enable in Settings."
            case .network:
                errorMessage = "Network error occurred while getting location"
            default:
                errorMessage = "Location error: \(clError.localizedDescription)"
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("🔒 Authorization status changed to: \(manager.authorizationStatus)")
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted")
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
            errorMessage = nil
        case .denied, .restricted:
            print("❌ Location permission denied or restricted")
            errorMessage = "Location access denied. Please enable location services in Settings."
        case .notDetermined:
            print("🔒 Location permission not determined")
        @unknown default:
            print("⚠️ Unknown authorization status")
            break
        }
    }
}
