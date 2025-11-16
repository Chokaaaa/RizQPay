//
//  WalletTransactionComponents.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct WalletTransactionsView: View {
    let transactions: [WalletTransaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                handleIndicator
                transactionsHeader
                dateHeader
                transactionsList
            }
            .background(Color.white)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 24
                )
            )
        }
        .background(Color.white) // Ensure white background extends fully
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var handleIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.gray.opacity(0.3))
            .frame(width: 36, height: 6)
            .padding(.top, 16)
    }
    
    private var transactionsHeader: some View {
        HStack {
            Text("Wallet Transactions")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }
    
    private var dateHeader: some View {
        HStack {
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    private var transactionsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(transactions) { transaction in
                    WalletTransactionRowView(transaction: transaction)
                }
            }
            .padding(.bottom, 100) // Add padding at the bottom of scroll content
        }
        .background(Color.white) // Ensure scroll view has white background
    }
}

struct WalletTransactionRowView: View {
    let transaction: WalletTransaction
    
    var body: some View {
        HStack(spacing: 16) {
            transactionIcon
            transactionDetails
            Spacer()
            amountAndTime
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
    
    private var transactionIcon: some View {
        ZStack {
            Circle()
                .fill(transaction.iconBackgroundColor)
                .frame(width: 48, height: 48)
            
            transaction.iconView
        }
    }
    
    private var transactionDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(transaction.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Text(transaction.subtitle)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .lineLimit(2)
        }
    }
    
    private var amountAndTime: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(transaction.formattedAmount)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text(transaction.formattedTime)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
// MARK: - Preview
#Preview {
    NavigationView {
        WalletView()
    }
}
