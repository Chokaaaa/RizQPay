//
//  CarColor.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

enum CarColor: String, CaseIterable {
    case white = "White"
    case silver = "Silver"
    case gray = "Grey"
    case black = "Black"
    case blue = "Blue"
    case red = "Red"
    case green = "Green"
    case yellow = "Yellow"
    case orange = "Orange"
    case other = "Other"
    
    var displayColor: Color {
        switch self {
        case .white: return .white
        case .silver: return Color(.systemGray3)
        case .gray: return Color(.systemGray)
        case .black: return .black
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .other: return Color(.systemGray4)
        }
    }
}