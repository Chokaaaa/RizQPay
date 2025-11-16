//
//  WalletHeaderComponents.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct WalletGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.7, blue: 0.2),
                Color(red: 1.0, green: 0.6, blue: 0.1)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct NavigationLogoView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("RizQ")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Pay")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

struct WalletHeaderView: View {
    let balance: Double
    let onAddAmountTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            balanceSection
            addAmountButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
    
    private var logoView: some View {
        HStack {
            Text("RizQ")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Pay")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
    
    private var balanceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Available Balance")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(balance.formattedCurrency)
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(.white)
                
                Text("₸")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                Spacer()
            }
        }
    }
    
    private var addAmountButton: some View {
        Button(action: onAddAmountTapped) {
            HStack {
                Image(systemName: "plus.circle")
                    .font(.system(size: 20, weight: .medium))
                
                Text("Add Amount")
                    .font(.system(size: 18, weight: .medium))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}
