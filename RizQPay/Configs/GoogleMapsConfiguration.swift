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
    
    // API key is now loaded from Config.plist for security
    // Make sure to enable both:
    // - Maps SDK for iOS
    // - Routes API (replaces Directions API)
    private let apiKey: String
    
    private init() {
        // Load API key from Config.plist
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["GoogleMapsAPIKey"] as? String else {
            fatalError("❌ ERROR: Could not load GoogleMapsAPIKey from Config.plist. Make sure Config.plist exists and contains the GoogleMapsAPIKey.")
        }
        self.apiKey = key
    }
    
    /// Initialize Google Maps SDK - call this in AppDelegate
    func configure() {
        // Only configure if not already done
        guard !isConfigured else { 
            print("🗺️ DEBUG: Google Maps already configured")
            return 
        }
        
        GMSServices.provideAPIKey(apiKey)
        isConfigured = true
        print("🗺️ DEBUG: Google Maps SDK configured with API key")
        print("🛣️ DEBUG: Using Google Routes API (Directions API deprecated)")
    }
    
    private var isConfigured = false
    
    /// Get the API key for Routes API requests
    func getAPIKey() -> String {
        return apiKey
    }
    
    /// Validate that the API key is properly set
    func validateAPIKey() -> Bool {
        guard !apiKey.isEmpty && 
              apiKey != "YOUR_GOOGLE_MAPS_API_KEY_HERE" &&
              apiKey != "AIzaSyDzutXe4rbv6nycRRJaSSSVQz_egFL0oEc" else {
            print("⚠️ WARNING: Google Maps API key not properly configured!")
            print("⚠️ Please set your API key in Config.plist")
            print("⚠️ Copy Config.plist.template to Config.plist and add your key")
            print("⚠️ Make sure to enable Routes API in Google Cloud Console")
            return false
        }
        return true
    }
}
