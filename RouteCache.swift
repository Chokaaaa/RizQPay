//
//  RouteCache.swift
//  RizQPay
//
//  Created by Assistant on 03/11/2025.
//

import Foundation
import CoreLocation
import GoogleMaps

/// Enhanced route cache with persistent storage and background prefetching
class RouteCache {
    static let shared = RouteCache()
    
    // Memory cache for quick access
    private var memoryCache: [String: CachedRoute] = [:]
    
    // Cache expiration times
    private let memoryCacheExpiration: TimeInterval = 300 // 5 minutes
    private let diskCacheExpiration: TimeInterval = 86400 * 7 // 1 week
    
    // File URLs for persistent storage
    private let cacheDirectory: URL
    private let routesCacheFile: URL
    
    private init() {
        // Setup cache directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cacheDirectory = documentsPath.appendingPathComponent("RouteCache")
        routesCacheFile = cacheDirectory.appendingPathComponent("cached_routes.json")
        
        // Create cache directory if needed
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // Load cached routes from disk
        loadCachedRoutesFromDisk()
    }
    
    private struct CachedRoute: Codable {
        let encodedPath: String
        let distance: CLLocationDistance
        let duration: TimeInterval
        let transportMode: TransportMode
        let timestamp: Date
        let sourceLatitude: Double
        let sourceLongitude: Double
        let destinationLatitude: Double
        let destinationLongitude: Double
        
        var isMemoryExpired: Bool {
            Date().timeIntervalSince(timestamp) > RouteCache.shared.memoryCacheExpiration
        }
        
        var isDiskExpired: Bool {
            Date().timeIntervalSince(timestamp) > RouteCache.shared.diskCacheExpiration
        }
        
        // Convert to GoogleMapsRoute
        func toGoogleMapsRoute() -> GoogleMapsRoute? {
            guard let path = GMSPath(fromEncodedPath: encodedPath) else { return nil }
            return GoogleMapsRoute(path: path, distance: distance, duration: duration, transportMode: transportMode)
        }
        
        // Create from GoogleMapsRoute and coordinates
        static func from(route: GoogleMapsRoute, source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> CachedRoute? {
            let encodedPath = route.path.encodedPath()
            guard !encodedPath.isEmpty else { return nil }
            
            return CachedRoute(
                encodedPath: encodedPath,
                distance: route.distance,
                duration: route.duration,
                transportMode: route.transportMode,
                timestamp: Date(),
                sourceLatitude: source.latitude,
                sourceLongitude: source.longitude,
                destinationLatitude: destination.latitude,
                destinationLongitude: destination.longitude
            )
        }
    }
    
    private func cacheKey(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode) -> String {
        // Round coordinates to reduce cache key variations for nearby points
        let srcLat = round(source.latitude * 10000) / 10000
        let srcLng = round(source.longitude * 10000) / 10000
        let dstLat = round(destination.latitude * 10000) / 10000
        let dstLng = round(destination.longitude * 10000) / 10000
        
        return "\(srcLat),\(srcLng)-\(dstLat),\(dstLng)-\(transportMode.rawValue)"
    }
    
    func getCachedRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode) -> GoogleMapsRoute? {
        let key = cacheKey(from: source, to: destination, transportMode: transportMode)
        
        // Check memory cache first
        if let cachedRoute = memoryCache[key], !cachedRoute.isMemoryExpired {
            return cachedRoute.toGoogleMapsRoute()
        }
        
        // Remove expired memory cache entry
        if memoryCache[key]?.isMemoryExpired == true {
            memoryCache.removeValue(forKey: key)
        }
        
        return nil
    }
    
    func cacheRoute(_ route: GoogleMapsRoute, from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode) {
        guard let cachedRoute = CachedRoute.from(route: route, source: source, destination: destination) else { return }
        
        let key = cacheKey(from: source, to: destination, transportMode: transportMode)
        
        // Store in memory cache
        memoryCache[key] = cachedRoute
        
        // Store in persistent cache (async to avoid blocking UI)
        Task.detached { [weak self] in
            await self?.saveCachedRoutesToDisk()
        }
        
        // Clean up old cache entries periodically
        if memoryCache.count > 100 { // Limit memory cache size
            cleanupExpiredEntries()
        }
    }
    
    private func cleanupExpiredEntries() {
        // Clean memory cache
        memoryCache = memoryCache.filter { !$0.value.isMemoryExpired }
    }
    
    func clearCache() {
        memoryCache.removeAll()
        try? FileManager.default.removeItem(at: routesCacheFile)
    }
    
    // MARK: - Persistent Storage
    
    private func loadCachedRoutesFromDisk() {
        guard FileManager.default.fileExists(atPath: routesCacheFile.path) else { return }
        
        do {
            let data = try Data(contentsOf: routesCacheFile)
            let cachedRoutes = try JSONDecoder().decode([String: CachedRoute].self, from: data)
            
            // Only load non-expired routes into memory
            memoryCache = cachedRoutes.filter { !$0.value.isDiskExpired }
            
            print("✅ Loaded \(memoryCache.count) cached routes from disk")
        } catch {
            print("❌ Failed to load cached routes from disk: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func saveCachedRoutesToDisk() async {
        // Collect all routes (memory + any long-term routes)
        let routesToSave = memoryCache.filter { !$0.value.isDiskExpired }
        
        do {
            let data = try JSONEncoder().encode(routesToSave)
            try data.write(to: routesCacheFile)
            print("✅ Saved \(routesToSave.count) routes to disk cache")
        } catch {
            print("❌ Failed to save cached routes to disk: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Background Prefetching
    
    /// Pre-fetch routes to popular business locations in the background
    func prefetchRoutes(from userLocation: CLLocationCoordinate2D, to businesses: [BusinessLocation], locationManager: GoogleMapsLocationManager) {
        Task.detached { [weak self] in
            await self?.performBackgroundPrefetch(from: userLocation, to: businesses, locationManager: locationManager)
        }
    }
    
    @MainActor
    func performBackgroundPrefetch(from userLocation: CLLocationCoordinate2D, to businesses: [BusinessLocation], locationManager: GoogleMapsLocationManager) async {
        print("🔄 Starting background route prefetch for \(businesses.count) businesses...")
        
        // Limit concurrent requests to avoid overwhelming the API
        let maxConcurrentRequests = 3
        let businessChunks = businesses.chunked(into: maxConcurrentRequests)
        
        for chunk in businessChunks {
            await withTaskGroup(of: Void.self) { group in
                for business in chunk {
                    // Skip if we already have a recent cache
                    let key = cacheKey(from: userLocation, to: business.coordinate, transportMode: .driving)
                    if let cached = memoryCache[key], !cached.isMemoryExpired {
                        continue
                    }
                    
                    group.addTask { [weak self, weak locationManager] in
                        guard let self = self, let locationManager = locationManager else { return }
                        
                        do {
                            let routes = try await locationManager.getAlternativeRoutes(
                                from: userLocation,
                                to: business.coordinate,
                                transportMode: .driving
                            )
                            
                            if let route = routes.first {
                                self.cacheRoute(route, from: userLocation, to: business.coordinate, transportMode: .driving)
                                print("✅ Prefetched route to \(business.title)")
                            }
                        } catch {
                            print("⚠️ Failed to prefetch route to \(business.title): \(error.localizedDescription)")
                        }
                        
                        // Add small delay to be respectful to the API
                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                    }
                }
            }
            
            // Delay between chunks
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        }
        
        print("✅ Background route prefetch completed")
    }
    
    /// Check if we have a cached route (including expired ones that could be used as fallback)
    func hasCachedRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode) -> Bool {
        let key = cacheKey(from: source, to: destination, transportMode: transportMode)
        return memoryCache[key] != nil
    }
    
    /// Get a cached route even if expired (for emergency fallback)
    func getCachedRouteEvenIfExpired(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportMode: TransportMode) -> GoogleMapsRoute? {
        let key = cacheKey(from: source, to: destination, transportMode: transportMode)
        return memoryCache[key]?.toGoogleMapsRoute()
    }
    
    /// Check if any routes are cached (for UI indicators)
    func hasAnyCachedRoutes() -> Bool {
        return !memoryCache.isEmpty
    }
}

// MARK: - Extensions

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// MARK: - TransportMode Codable Conformance
extension TransportMode: Codable {}