//
//  BackgroundRoutePrefetcher.swift
//  RizQPay
//
//  Created by Assistant on 03/11/2025.
//

import Foundation
import BackgroundTasks
import CoreLocation
import GoogleMaps

/// Handles background route prefetching for better user experience
class BackgroundRoutePrefetcher {
    static let shared = BackgroundRoutePrefetcher()
    
    private let backgroundTaskIdentifier = "com.rizqpay.route-prefetch"
    
    private init() {}
    
    /// Register background task for route prefetching
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
            self.handleBackgroundRoutePrefetch(task: task as! BGAppRefreshTask)
        }
    }
    
    /// Schedule background task for route prefetching
    func scheduleBackgroundRoutePrefetch() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("✅ Background route prefetch scheduled")
        } catch {
            print("❌ Could not schedule background route prefetch: \(error)")
        }
    }
    
    private func handleBackgroundRoutePrefetch(task: BGAppRefreshTask) {
        // Schedule next background task
        scheduleBackgroundRoutePrefetch()
        
        // Set expiration handler
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        // Perform the prefetch work
        Task {
            await performBackgroundPrefetch()
            task.setTaskCompleted(success: true)
        }
    }
    
    @MainActor
    private func performBackgroundPrefetch() async {
        print("🔄 Starting background route prefetch...")
        
        // This would ideally get the user's current location
        // For now, we'll skip the background prefetch if we don't have location access
        // In a real app, you might want to store the last known location
        
        // Get cached/stored user location if available
        guard let lastKnownLocation = UserDefaults.standard.object(forKey: "lastKnownLocation") as? Data,
              let location = try? JSONDecoder().decode(CLLocationCoordinate2D.self, from: lastKnownLocation) else {
            print("⚠️ No stored location for background prefetch")
            return
        }
        
        let businesses = GoogleMapsContentView.getBusinessLocations()
        
        // Create a temporary location manager for background fetch
        // Note: In production, you might want to use a singleton or dependency injection
        let locationManager = GoogleMapsLocationManager()
        
        // Background prefetching disabled - RouteCache removed
        print("⚠️ Background route prefetching disabled - RouteCache has been removed")
        print("✅ Background route prefetch completed")
    }
}

// MARK: - CLLocationCoordinate2D Codable Extension

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
}
