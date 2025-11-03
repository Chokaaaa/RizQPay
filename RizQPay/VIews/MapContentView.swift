//
//  MapContentView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI
import GoogleMaps
import CoreLocation

// MARK: - Google Maps Content View
struct GoogleMapsContentView: View {
    @ObservedObject var locationManager: GoogleMapsLocationManager
    
    // Static business data to prevent re-creation
    private static let businessData: [BusinessLocation] = [
        BusinessLocation(
            coordinate: CLLocationCoordinate2D(latitude: 43.224868760757076, longitude: 76.95487727263975),
            title: "Honey Coffee",
            imageName: "honney-coffe"
        )
    ]
    
    // Cache for custom marker images to avoid recreating them
    fileprivate static var markerCache: [String: UIImage] = [:]
    
    private var businesses: [BusinessLocation] { Self.businessData }
    
    /// Public method to get business locations for prefetching
    static func getBusinessLocations() -> [BusinessLocation] {
        return businessData
    }
    
    var body: some View {
        GoogleMapsView(
            locationManager: locationManager,
            businesses: businesses
        )
        .ignoresSafeArea()
        .onAppear {
            locationManager.requestLocation()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("BusinessMarkerTapped"))) { notification in
            if let business = notification.object as? BusinessLocation {
                navigateToBusinessDetail(business)
            }
        }
    }
}

// MARK: - Google Maps UIViewRepresentable
struct GoogleMapsView: UIViewRepresentable {
    @ObservedObject var locationManager: GoogleMapsLocationManager
    let businesses: [BusinessLocation]
    
    // Keep references to markers and polyline for efficient updates
    fileprivate static var businessMarkers: [GMSMarker] = []
    fileprivate static var currentPolyline: GMSPolyline?
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        
        // Configure map appearance
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false // We'll use our custom button
        mapView.settings.compassButton = false
        mapView.mapType = .normal
        
        // Set the map view reference in location manager
        locationManager.setMapView(mapView)
        
        // Set initial camera position
        mapView.camera = locationManager.camera
        
        // Set delegate
        mapView.delegate = context.coordinator
        
        // Add business markers
        addBusinessMarkers(to: mapView)
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        // Always update route polyline first (this is most important for user experience)
        updateRoute(on: mapView)
        
        // Then handle camera updates
        guard locationManager.hasPendingCameraUpdate else {
            return
        }
        
        // Only update camera if there's a significant change
        let currentCamera = mapView.camera
        let newCamera = locationManager.camera
        
        let latDiff = abs(currentCamera.target.latitude - newCamera.target.latitude)
        let lonDiff = abs(currentCamera.target.longitude - newCamera.target.longitude)
        let zoomDiff = abs(currentCamera.zoom - newCamera.zoom)
        
        // Only update if changes are significant enough
        if latDiff > 0.001 || lonDiff > 0.001 || zoomDiff > 0.5 {
            mapView.animate(to: newCamera)
            locationManager.clearPendingCameraUpdate()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func addBusinessMarkers(to mapView: GMSMapView) {
        // Clear existing markers first
        Self.businessMarkers.forEach { $0.map = nil }
        Self.businessMarkers.removeAll()
        
        for business in businesses {
            let marker = GMSMarker()
            marker.position = business.coordinate
            marker.title = business.title
            marker.userData = business
            marker.map = mapView
            
            // Create custom marker icon (now cached for performance)
            if let markerImage = createCustomMarker(for: business) {
                marker.icon = markerImage
            }
            
            // Store reference for future updates
            Self.businessMarkers.append(marker)
        }
    }
    
    private func updateRoute(on mapView: GMSMapView) {
        // Remove only the existing polyline, not all markers
        Self.currentPolyline?.map = nil
        Self.currentPolyline = nil
        
        // Add route polyline if navigation is active
        if let route = locationManager.currentRoute {
            print("🗺️ DEBUG: Adding polyline to map - Path count: \(route.path.count())")
            print("🗺️ DEBUG: Polyline color: \(route.polyline.strokeColor), width: \(route.polyline.strokeWidth)")
            
            // Ensure polyline is visible with enhanced styling
            route.polyline.strokeColor = UIColor.systemBlue
            route.polyline.strokeWidth = 8.0
            route.polyline.zIndex = 1000
            route.polyline.geodesic = true
            
            // Add the polyline to the map
            route.polyline.map = mapView
            Self.currentPolyline = route.polyline
            
            print("🗺️ DEBUG: Polyline added to map successfully")
            
            // Force a small delay to ensure map is ready, then verify polyline is still visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Double check the polyline is still on the map
                if Self.currentPolyline?.map == nil {
                    print("⚠️ WARNING: Polyline disappeared from map, re-adding...")
                    route.polyline.map = mapView
                    Self.currentPolyline = route.polyline
                }
                
                // Additional verification after a longer delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if Self.currentPolyline?.map == nil {
                        print("⚠️ CRITICAL: Polyline still not visible, forcing re-add...")
                        route.polyline.map = mapView
                        Self.currentPolyline = route.polyline
                    } else {
                        print("✅ Polyline confirmed visible on map")
                    }
                }
            }
        } else {
            print("🗺️ DEBUG: No current route available")
        }
    }
    
    func createCustomMarker(for business: BusinessLocation) -> UIImage? {
        // Check cache first
        if let cachedImage = GoogleMapsContentView.markerCache[business.imageName] {
            return cachedImage
        }
        
        let markerSize = CGSize(width: 80, height: 90)
        
        let renderer = UIGraphicsImageRenderer(size: markerSize)
        let markerImage = renderer.image { context in
            let cgContext = context.cgContext
            
            // Draw white circle with shadow
            let circleRect = CGRect(x: 10, y: 5, width: 60, height: 60)
            
            // Shadow
            cgContext.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.black.withAlphaComponent(0.3).cgColor)
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.fillEllipse(in: circleRect)
            
            // Border
            cgContext.setStrokeColor(UIColor.black.withAlphaComponent(0.1).cgColor)
            cgContext.setLineWidth(1)
            cgContext.strokeEllipse(in: circleRect)
            
            // Business image
            if let businessImage = UIImage(named: business.imageName) {
                let imageRect = circleRect.insetBy(dx: 5, dy: 5)
                
                // Clip to circle
                cgContext.saveGState()
                cgContext.addEllipse(in: imageRect)
                cgContext.clip()
                businessImage.draw(in: imageRect)
                cgContext.restoreGState()
            }
            
            // Draw triangle pointer
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: markerSize.width / 2, y: 75))
            trianglePath.addLine(to: CGPoint(x: markerSize.width / 2 - 8, y: 65))
            trianglePath.addLine(to: CGPoint(x: markerSize.width / 2 + 8, y: 65))
            trianglePath.close()
            
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.addPath(trianglePath.cgPath)
            cgContext.fillPath()
            
            cgContext.setStrokeColor(UIColor.black.withAlphaComponent(0.1).cgColor)
            cgContext.addPath(trianglePath.cgPath)
            cgContext.strokePath()
        }
        
        // Cache the image for future use
        GoogleMapsContentView.markerCache[business.imageName] = markerImage
        return markerImage
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        let parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard let business = marker.userData as? BusinessLocation else {
                return false
            }
            
            // Use DispatchQueue.main.async for immediate UI response
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: NSNotification.Name("BusinessMarkerTapped"),
                    object: business
                )
            }
            
            return true
        }
        
        @MainActor func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            // Only update location manager if this is a user-initiated change
            // Prevent feedback loop during programmatic updates
            guard !parent.locationManager.isUpdatingCamera else { return }
            
            // Throttle camera updates to improve performance
            parent.locationManager.updateCameraFromUserGesture(position)
        }
    }
}

// MARK: - Business Detail Navigation Helper
extension GoogleMapsContentView {
    func navigateToBusinessDetail(_ business: BusinessLocation) {
        // This will be handled by the parent MapView
    }
}
