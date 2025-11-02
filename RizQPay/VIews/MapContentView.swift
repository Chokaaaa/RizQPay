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
        Map(
            coordinateRegion: $locationManager.region,
            showsUserLocation: true,
            userTrackingMode: .constant(.none),
            annotationItems: businesses
        ) { business in
            MapAnnotation(coordinate: business.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1.0)) {
                NavigationLink(destination: BusinessDetailView(business: business)) {
                    CustomMapMarker(business: business)
                }
                .buttonStyle(PlainButtonStyle()) // Remove button styling that might cause flicker
            }
        }
        .mapStyle(.standard(elevation: .flat)) // Use flat elevation for better performance
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
