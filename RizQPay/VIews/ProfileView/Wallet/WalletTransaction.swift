//
//  WalletTransaction.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct WalletTransaction: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let icon: String
    
    var formattedAmount: String {
        let prefix = amount >= 0 ? "+" : ""
        return "\(prefix)\(amount.formattedCurrency) ₸"
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var iconBackgroundColor: Color {
        switch type {
        case .purchase:
            return Color.black.opacity(0.05)
        case .credit:
            return Color.orange.opacity(0.1)
        }
    }
    
    @ViewBuilder
    var iconView: some View {
        switch type {
        case .purchase:
            Image(systemName: "percent")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
        case .credit:
            Image(systemName: "star.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.orange)
                .overlay(
                    Image(systemName: "plus.circle")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.orange)
                        .offset(x: 8, y: 8)
                )
        }
    }
}

enum TransactionType: CaseIterable, Hashable {
    case purchase
    case credit
    
    var displayName: String {
        switch self {
        case .purchase: return "Purchase"
        case .credit: return "Credit"
        }
    }
}