//
//  EnergyOptimizationHelper.swift
//  RizQPay
//
//  Created by Assistant on 04/11/2025.
//

import Foundation
import CoreLocation
import SwiftUI

/// Helper class to monitor and optimize energy usage
class EnergyOptimizationHelper: ObservableObject {
    static let shared = EnergyOptimizationHelper()
    
    @Published var energyMetrics: EnergyMetrics = EnergyMetrics()
    
    private var lastLocationUpdate = Date()
    private var locationUpdateCount = 0
    private var cameraUpdateCount = 0
    private var networkRequestCount = 0
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        // Monitor energy usage every 30 seconds
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.logEnergyMetrics()
        }
    }
    
    func recordLocationUpdate() {
        locationUpdateCount += 1
        lastLocationUpdate = Date()
        energyMetrics.locationUpdatesPerMinute = locationUpdateCount
        
        // Reset counter every minute
        if lastLocationUpdate.timeIntervalSinceNow < -60 {
            locationUpdateCount = 0
        }
    }
    
    func recordCameraUpdate() {
        cameraUpdateCount += 1
        energyMetrics.cameraUpdatesPerMinute = cameraUpdateCount
    }
    
    func recordNetworkRequest() {
        networkRequestCount += 1
        energyMetrics.networkRequestsPerMinute = networkRequestCount
    }
    
    private func logEnergyMetrics() {
        print("⚡ Energy Usage Metrics:")
        print("   📍 Location updates/min: \(energyMetrics.locationUpdatesPerMinute)")
        print("   📷 Camera updates/min: \(energyMetrics.cameraUpdatesPerMinute)")
        print("   🌐 Network requests/min: \(energyMetrics.networkRequestsPerMinute)")
        
        // Reset counters
        locationUpdateCount = 0
        cameraUpdateCount = 0
        networkRequestCount = 0
    }
}

struct EnergyMetrics {
    var locationUpdatesPerMinute: Int = 0
    var cameraUpdatesPerMinute: Int = 0
    var networkRequestsPerMinute: Int = 0
    
    var energyEfficiencyScore: Double {
        // Lower values indicate better energy efficiency
        let locationPenalty = Double(locationUpdatesPerMinute) * 0.5
        let cameraPenalty = Double(cameraUpdatesPerMinute) * 0.2
        let networkPenalty = Double(networkRequestsPerMinute) * 0.3
        
        return max(0, 100 - (locationPenalty + cameraPenalty + networkPenalty))
    }
    
    var energyLevel: EnergyLevel {
        switch energyEfficiencyScore {
        case 80...100: return .excellent
        case 60...79: return .good
        case 40...59: return .moderate
        case 20...39: return .poor
        default: return .critical
        }
    }
}

enum EnergyLevel: String {
    case excellent = "Excellent"
    case good = "Good"
    case moderate = "Moderate"  
    case poor = "Poor"
    case critical = "Critical"
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .mint
        case .moderate: return .orange
        case .poor: return .red
        case .critical: return .red
        }
    }
}

// MARK: - Energy Optimization Tips

extension EnergyOptimizationHelper {
    func getOptimizationTips() -> [String] {
        var tips: [String] = []
        
        if energyMetrics.locationUpdatesPerMinute > 10 {
            tips.append("Consider reducing location update frequency")
        }
        
        if energyMetrics.cameraUpdatesPerMinute > 20 {
            tips.append("Throttle camera position updates for better energy efficiency")
        }
        
        if energyMetrics.networkRequestsPerMinute > 5 {
            tips.append("Implement request caching to reduce network calls")
        }
        
        return tips
    }
}

// MARK: - Energy Debug View (for development)

struct EnergyDebugView: View {
    @ObservedObject private var energyHelper = EnergyOptimizationHelper.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Energy Efficiency")
                    .font(.headline)
                
                Spacer()
                
                Text(energyHelper.energyMetrics.energyLevel.rawValue)
                    .foregroundColor(energyHelper.energyMetrics.energyLevel.color)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("📍 Location Updates: \(energyHelper.energyMetrics.locationUpdatesPerMinute)/min")
                Text("📷 Camera Updates: \(energyHelper.energyMetrics.cameraUpdatesPerMinute)/min")
                Text("🌐 Network Requests: \(energyHelper.energyMetrics.networkRequestsPerMinute)/min")
                Text("⚡ Efficiency Score: \(Int(energyHelper.energyMetrics.energyEfficiencyScore))/100")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            if !energyHelper.getOptimizationTips().isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Optimization Tips:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    ForEach(energyHelper.getOptimizationTips(), id: \.self) { tip in
                        Text("• \(tip)")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#if DEBUG
struct EnergyDebugView_Previews: PreviewProvider {
    static var previews: some View {
        EnergyDebugView()
            .padding()
    }
}
#endif