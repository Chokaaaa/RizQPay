//
//  AppDelegate.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import Foundation
import UIKit
import SwiftUI
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Initialize Google Maps SDK immediately
        GoogleMapsConfiguration.shared.configure()
        
        // Validate API key is properly set
        if !GoogleMapsConfiguration.shared.validateAPIKey() {
            print("❌ ERROR: Google Maps API key validation failed!")
        }
        
        print("🚀 DEBUG: App launched - Google Maps SDK initialized")
        return true
    }
}
