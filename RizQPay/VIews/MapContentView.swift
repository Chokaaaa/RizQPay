//
//  MapContentView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Map Content View
struct MapContentView: View {
    @ObservedObject var locationManager: LocationManager
    
    // Make businesses static to prevent re-creation and flickering
    private static let businessData: [BusinessLocation] = [
        BusinessLocation(
            coordinate: CLLocationCoordinate2D(latitude: 43.224868760757076, longitude: 76.95487727263975),
            title: "Honey Coffee",
            imageName: "honney-coffe"
        )
    ]
    
    private var businesses: [BusinessLocation] { Self.businessData }
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                userTrackingMode: .constant(.none),
                annotationItems: businesses
            ) { business in
                MapAnnotation(coordinate: business.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                    NavigationLink(destination: BusinessDetailView(business: business, locationManager: locationManager)) {
                        CustomMapMarker(business: business)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove button styling that might cause flicker
                }
            }
            .mapStyle(.standard(elevation: .flat)) // Use flat elevation for better performance
            
            // Add polyline overlay if navigation is active
            if let route = locationManager.currentRoute {
                RouteOverlayView(route: route, region: $locationManager.region)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

// MARK: - Custom Map Marker (inline to prevent flickering)
struct CustomMapMarker: View {
    let business: BusinessLocation
    
    var body: some View {
        ZStack {
            // Optimized marker design for better performance
            VStack(spacing: 0) {
                // Main marker circle
                ZStack {
                    // White background circle with minimal shadow
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                    
                    // Business image
                    Image(business.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                
                // Simple triangle pointer
                MarkerTriangle()
                    .fill(Color.white)
                    .frame(width: 16, height: 10)
                    .overlay(
                        MarkerTriangle()
                            .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                    )
                    .offset(y: -2)
            }
        }
        .drawingGroup() // This renders the view as a single layer for better performance
    }
}

struct MarkerTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}

// MARK: - Route Overlay View for Route Display
struct RouteOverlayView: UIViewRepresentable {
    let route: MKRoute
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false
        mapView.backgroundColor = .clear
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Sync the map view region with the SwiftUI Map
        uiView.setRegion(region, animated: false)
        
        // Remove existing overlays
        uiView.removeOverlays(uiView.overlays)
        
        // Add the new route polyline
        uiView.addOverlay(route.polyline)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4.0
                renderer.lineCap = .round
                renderer.lineJoin = .round
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
