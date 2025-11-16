//
//  WalletViewModel.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

@MainActor
class WalletViewModel: ObservableObject {
    @Published var availableBalance: Double = 2500
    @Published var transactions: [WalletTransaction] = []
    
    init() {
        loadInitialData()
    }
    
    func addAmount(_ amount: Double) {
        availableBalance += amount
        
        // Add a new credit transaction
        let creditTransaction = WalletTransaction(
            id: UUID().uuidString,
            title: "Credit",
            subtitle: "Added \(amount.formattedCurrency) ₸ to wallet",
            amount: amount,
            date: Date(),
            type: .credit,
            icon: "plus.circle"
        )
        
        transactions.insert(creditTransaction, at: 0)
    }
    
    private func loadInitialData() {
        transactions = [
            WalletTransaction(
                id: "1",
                title: "Honey Coffee",
                subtitle: "Order",
                amount: -27.0,
                date: Date(),
                type: .purchase,
                icon: "cup.and.saucer"
            ),
            WalletTransaction(
                id: "2",
                title: "Credit",
                subtitle: "Converted 1550 d-coins to 31.0 ₸ in wallet",
                amount: 31.0,
                date: Date().addingTimeInterval(-780),
                type: .credit,
                icon: "star.fill"
            )
        ]
    }
}