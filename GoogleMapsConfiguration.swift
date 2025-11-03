//
//  GoogleMapsConfiguration.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import Foundation
import GoogleMaps


/// Configuration class for Google Maps SDK
/// 
/// NOTE: This app now uses the Google Routes API instead of the deprecated Directions API.
/// The Routes API provides better route quality and more features including:
/// - Traffic-aware routing
/// - Alternative routes
/// - Better polyline encoding
/// - Enhanced route modifiers
class GoogleMapsConfiguration {
    static let shared = GoogleMapsConfiguration()
    
    // IMPORTANT: Replace with your actual Google Maps API key
    // Make sure to enable both:
    // - Maps SDK for iOS
    // - Routes API (replaces Directions API)
    private let apiKey = "AIzaSyDzutXe4rbv6nycRRJaSSSVQz_egFL0oEc"
    
    private init() {}
    
    /// Initialize Google Maps SDK - call this in AppDelegate
    func configure() {
        GMSServices.provideAPIKey(apiKey)
        print("🗺️ DEBUG: Google Maps SDK configured with API key")
        print("🛣️ DEBUG: Using Google Routes API (Directions API deprecated)")
    }
    
    /// Get the API key for Routes API requests
    func getAPIKey() -> String {
        return apiKey
    }
    
    /// Create a properly authenticated URLRequest for Routes API
    func createRoutesAPIRequest(endpoint: String) -> URLRequest? {
        let urlString = "\(endpoint)?key=\(apiKey)"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("routes.duration,routes.distanceMeters,routes.polyline", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Add bundle identifier for iOS authentication
        let bundleId = getBundleIdentifier()
        if !bundleId.isEmpty {
            request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        }
        
        return request
    }
    
    /// Validate that the API key is properly set
    func validateAPIKey() -> Bool {
        guard !apiKey.isEmpty && apiKey != "AIzaSyDzutXe4rbv6nycRRJaSSSVQz_egFL0oEc" else {
            print("⚠️ WARNING: Google Maps API key not properly configured!")
            print("⚠️ Please set your API key in GoogleMapsConfiguration.swift")
            print("⚠️ Make sure to enable Routes API in Google Cloud Console")
            return false
        }
        return true
    }
    
    /// Get the app's bundle identifier
    private func getBundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    /// Check if Routes API is properly configured
    func validateRoutesAPI() async -> Bool {
        // Test the Routes API with a simple request
        let testURL = "https://routes.googleapis.com/directions/v2:computeRoutes?key=\(apiKey)"
        guard let url = URL(string: testURL) else { return false }
        
        let requestBody: [String: Any] = [
            "origin": [
                "location": [
                    "latLng": [
                        "latitude": 37.7749,
                        "longitude": -122.4194
                    ]
                ]
            ],
            "destination": [
                "location": [
                    "latLng": [
                        "latitude": 37.7849,
                        "longitude": -122.4094
                    ]
                ]
            ],
            "travelMode": "DRIVE"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("routes.duration", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Add bundle identifier for iOS authentication
        let bundleId = getBundleIdentifier()
        if !bundleId.isEmpty {
            request.setValue(bundleId, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        }
        
        print("🔍 DEBUG: Testing Routes API with bundle ID: \(bundleId)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                let isValid = httpResponse.statusCode == 200
                
                if !isValid {
                    // Print response data for debugging
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("❌ Routes API error response: \(responseString)")
                    }
                }
                
                print(isValid ? "✅ Routes API is working correctly" : "❌ Routes API validation failed with status: \(httpResponse.statusCode)")
                return isValid
            }
        } catch {
            print("❌ Routes API validation error: \(error.localizedDescription)")
        }
        
        return false
    }
}
