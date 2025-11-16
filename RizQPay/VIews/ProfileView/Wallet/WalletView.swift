//
//  WalletView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct WalletView: View {
    // MARK: - Properties
    @StateObject private var viewModel = WalletViewModel()
    @State private var showingAddAmount = false
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                WalletGradient()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    WalletHeaderView(
                        balance: viewModel.availableBalance,
                        onAddAmountTapped: { showingAddAmount = true }
                    )
                    
                    WalletTransactionsView(transactions: viewModel.transactions)
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                NavigationLogoView()
            }
        }
        .sheet(isPresented: $showingAddAmount) {
            AddAmountView(viewModel: viewModel)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        WalletView()
    }
}
