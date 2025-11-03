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
    
    private var businesses: [BusinessLocation] { Self.businessData }
    
    var body: some View {
        GoogleMapsView(
            locationManager: locationManager,
            businesses: businesses
        )
        .ignoresSafeArea()
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

// MARK: - Google Maps UIViewRepresentable
struct GoogleMapsView: UIViewRepresentable {
    @ObservedObject var locationManager: GoogleMapsLocationManager
    let businesses: [BusinessLocation]
    
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
        // Update camera position
        if mapView.camera.target.latitude != locationManager.camera.target.latitude ||
           mapView.camera.target.longitude != locationManager.camera.target.longitude ||
           mapView.camera.zoom != locationManager.camera.zoom {
            mapView.camera = locationManager.camera
        }
        
        // Update route polyline
        updateRoute(on: mapView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func addBusinessMarkers(to mapView: GMSMapView) {
        // Clear existing markers
        mapView.clear()
        
        for business in businesses {
            let marker = GMSMarker()
            marker.position = business.coordinate
            marker.title = business.title
            marker.userData = business
            marker.map = mapView
            
            // Create custom marker icon
            if let markerImage = createCustomMarker(for: business) {
                marker.icon = markerImage
            }
        }
        
        // Re-add route if it exists
        updateRoute(on: mapView)
    }
    
    private func updateRoute(on mapView: GMSMapView) {
        // Remove existing polylines
        mapView.clear()
        
        // Re-add business markers
        for business in businesses {
            let marker = GMSMarker()
            marker.position = business.coordinate
            marker.title = business.title
            marker.userData = business
            marker.map = mapView
            
            if let markerImage = createCustomMarker(for: business) {
                marker.icon = markerImage
            }
        }
        
        // Add route polyline if navigation is active
        if let route = locationManager.currentRoute {
            route.polyline.map = mapView
        }
    }
    
    private func createCustomMarker(for business: BusinessLocation) -> UIImage? {
        let markerSize = CGSize(width: 80, height: 90)
        
        UIGraphicsBeginImageContextWithOptions(markerSize, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw white circle with shadow
        let circleRect = CGRect(x: 10, y: 5, width: 60, height: 60)
        
        // Shadow
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.black.withAlphaComponent(0.3).cgColor)
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: circleRect)
        
        // Border
        context.setStrokeColor(UIColor.black.withAlphaComponent(0.1).cgColor)
        context.setLineWidth(1)
        context.strokeEllipse(in: circleRect)
        
        // Business image
        if let businessImage = UIImage(named: business.imageName) {
            let imageRect = circleRect.insetBy(dx: 5, dy: 5)
            
            // Clip to circle
            context.saveGState()
            context.addEllipse(in: imageRect)
            context.clip()
            businessImage.draw(in: imageRect)
            context.restoreGState()
        }
        
        // Draw triangle pointer
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: markerSize.width / 2, y: 75))
        trianglePath.addLine(to: CGPoint(x: markerSize.width / 2 - 8, y: 65))
        trianglePath.addLine(to: CGPoint(x: markerSize.width / 2 + 8, y: 65))
        trianglePath.close()
        
        context.setFillColor(UIColor.white.cgColor)
        context.addPath(trianglePath.cgPath)
        context.fillPath()
        
        context.setStrokeColor(UIColor.black.withAlphaComponent(0.1).cgColor)
        context.addPath(trianglePath.cgPath)
        context.strokePath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
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
            
            // Handle marker tap - navigate to business detail
            DispatchQueue.main.async {
                // We need to present the business detail view
                // This will be handled by the NavigationStack in the parent view
                NotificationCenter.default.post(
                    name: NSNotification.Name("BusinessMarkerTapped"),
                    object: business
                )
            }
            
            return true
        }
        
        @MainActor func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            // Update location manager camera
            parent.locationManager.camera = position
        }
    }
}

// MARK: - Business Detail Navigation Helper
extension GoogleMapsContentView {
    func navigateToBusinessDetail(_ business: BusinessLocation) {
        // This will be handled by the parent MapView
    }
}
