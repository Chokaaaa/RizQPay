//
//  BusinessLocation.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import Foundation
import CoreLocation

// MARK: - Models
struct BusinessLocation: Identifiable, Hashable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let imageName: String
    
    // Implement Hashable conformance to include all stable properties
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(imageName)
        // We avoid hashing coordinates as they can have floating point precision issues
    }
    
    static func == (lhs: BusinessLocation, rhs: BusinessLocation) -> Bool {
        lhs.id == rhs.id && 
        lhs.title == rhs.title && 
        lhs.imageName == rhs.imageName
    }
}
