////
////  RoutesAPIExample.swift
////  RizQPay
////
////  Created by Assistant on 03/11/2025.
////
//
//import SwiftUI
//import CoreLocation
//import GoogleMaps
//
///// Example view demonstrating how to use the updated Google Routes API
//struct RoutesAPIExample: View {
//    @StateObject private var locationManager = GoogleMapsLocationManager()
//    @State private var transportMode: TransportMode = .driving
//    @State private var alternativeRoutes: [GoogleMapsRoute] = []
//    @State private var isLoadingRoutes = false
//    
//    // Example business location (Apple Park)
//    private let exampleBusiness = BusinessLocation(
//        coordinate: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0089),
//        title: "Apple Park",
//        imageName: "building.2.crop.circle"
//    )
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Google Routes API Example")
//                .font(.title)
//                .bold()
//            
//            // Transport Mode Picker
//            Picker("Transport Mode", selection: $transportMode) {
//                ForEach(TransportMode.allCases, id: \.self) { mode in
//                    Text(mode.displayName).tag(mode)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            
//            // Navigation Controls
//            VStack(spacing: 12) {
//                Button(action: {
//                    startNavigation()
//                }) {
//                    HStack {
//                        Image(systemName: "location.fill")
//                        Text("Start Navigation")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .disabled(!locationManager.isLocationAvailable())
//                
//                Button(action: {
//                    getAlternativeRoutes()
//                }) {
//                    HStack {
//                        Image(systemName: "map.fill")
//                        Text("Get Alternative Routes")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .disabled(!locationManager.isLocationAvailable() || isLoadingRoutes)
//                
//                if locationManager.isNavigating {
//                    Button(action: {
//                        locationManager.stopNavigation()
//                    }) {
//                        HStack {
//                            Image(systemName: "stop.fill")
//                            Text("Stop Navigation")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//                }
//            }
//            
//            // Current Route Info
//            if let route = locationManager.currentRoute {
//                GroupBox("Current Route") {
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Image(systemName: "location.circle")
//                            Text("Distance: \(String(format: "%.1f", route.distance / 1000)) km")
//                        }
//                        HStack {
//                            Image(systemName: "clock")
//                            Text("Duration: \(Int(route.duration / 60)) min")
//                        }
//                        HStack {
//                            Image(systemName: transportModeIcon(route.transportMode))
//                            Text("Mode: \(route.transportMode.displayName)")
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//            
//            // Alternative Routes List
//            if !alternativeRoutes.isEmpty {
//                GroupBox("Alternative Routes") {
//                    ScrollView {
//                        LazyVStack(spacing: 8) {
//                            ForEach(0..<alternativeRoutes.count, id: \.self) { index in
//                                let route = alternativeRoutes[index]
//                                AlternativeRouteRow(
//                                    route: route,
//                                    index: index + 1,
//                                    onSelect: {
//                                        selectAlternativeRoute(route)
//                                    }
//                                )
//                            }
//                        }
//                    }
//                    .frame(maxHeight: 200)
//                }
//            }
//            
//            if isLoadingRoutes {
//                ProgressView("Loading alternative routes...")
//            }
//            
//            // Location Status
//            VStack {
//                Text("Location Status:")
//                    .font(.headline)
//                
//                if locationManager.isLocationAvailable() {
//                    HStack {
//                        Image(systemName: "checkmark.circle.fill")
//                            .foregroundColor(.green)
//                        Text("Location available")
//                    }
//                } else {
//                    HStack {
//                        Image(systemName: "exclamationmark.triangle.fill")
//                            .foregroundColor(.orange)
//                        Text("Location not available")
//                    }
//                    Button("Request Location") {
//                        locationManager.requestLocation()
//                    }
//                    .buttonStyle(.bordered)
//                }
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .onAppear {
//            locationManager.requestLocation()
//        }
//        .alert("Error", isPresented: .constant(locationManager.errorMessage != nil)) {
//            Button("OK") {
//                locationManager.errorMessage = nil
//            }
//        } message: {
//            Text(locationManager.errorMessage ?? "")
//        }
//    }
//    
//    private func startNavigation() {
//        locationManager.startNavigation(to: exampleBusiness, transportMode: transportMode)
//    }
//    
//    private func getAlternativeRoutes() {
//        guard let userLocation = locationManager.location else { return }
//        
//        isLoadingRoutes = true
//        
//        Task {
//            do {
//                let routes = try await locationManager.getAlternativeRoutes(
//                    from: userLocation.coordinate,
//                    to: exampleBusiness.coordinate,
//                    transportMode: transportMode
//                )
//                
//                await MainActor.run {
//                    self.alternativeRoutes = routes
//                    self.isLoadingRoutes = false
//                }
//            } catch {
//                await MainActor.run {
//                    print("Error fetching alternative routes: \(error.localizedDescription)")
//                    self.isLoadingRoutes = false
//                    // You could show an alert here
//                }
//            }
//        }
//    }
//    
//    private func selectAlternativeRoute(_ route: GoogleMapsRoute) {
//        locationManager.currentRoute = route
//        locationManager.isNavigating = true
//        locationManager.updateCameraForRoute(route)
//        
//        // Clear alternatives after selection
//        alternativeRoutes = []
//    }
//    
//    private func transportModeIcon(_ mode: TransportMode) -> String {
//        switch mode {
//        case .driving: return "car.fill"
//        case .walking: return "figure.walk"
//        case .bicycling: return "bicycle"
//        case .transit: return "bus.fill"
//        }
//    }
//}
//
//struct AlternativeRouteRow: View {
//    let route: GoogleMapsRoute
//    let index: Int
//    let onSelect: () -> Void
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Route \(index)")
//                    .font(.headline)
//                
//                HStack(spacing: 16) {
//                    HStack {
//                        Image(systemName: "location.circle")
//                            .foregroundColor(.blue)
//                        Text("\(String(format: "%.1f", route.distance / 1000)) km")
//                            .font(.caption)
//                    }
//                    
//                    HStack {
//                        Image(systemName: "clock")
//                            .foregroundColor(.orange)
//                        Text("\(Int(route.duration / 60)) min")
//                            .font(.caption)
//                    }
//                }
//            }
//            
//            Spacer()
//            
//            Button("Select") {
//                onSelect()
//            }
//            .buttonStyle(.borderedProminent)
//            .buttonBorderShape(.roundedRectangle)
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 12)
//        .background(Color.secondary.opacity(0.1))
//        .cornerRadius(8)
//    }
//}
//
//#Preview {
//    RoutesAPIExample()
//}
