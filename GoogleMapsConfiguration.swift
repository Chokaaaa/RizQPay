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
}
