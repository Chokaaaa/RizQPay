//
//  ProfileView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI


struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Profile Header
                    ProfileHeaderView()
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        ProfileMenuItem(
                            icon: "doc.text",
                            title: "Order history",
                            showsDisclosure: true,
                            destinationType: .orderHistory
                        )
                        
                        ProfileMenuItem(
                            icon: "circle.circle",
                            title: "d-coins",
                            subtitle: "200",
                            badge: "Bronze",
                            showsDisclosure: true,
                            destinationType: .coins
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Wallet",
                            subtitle: "4.00 AED",
                            subtitleColor: .orange,
                            showsDisclosure: true,
                            destinationType: .wallet
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard.circle",
                            title: "Payments",
                            showsDisclosure: true,
                            destinationType: .payments
                        )
                        
                        ProfileMenuItem(
                            icon: "car",
                            title: "Plate numbers",
                            showsDisclosure: true,
                            destinationType: .plateNumbers
                        )
                        
                        ProfileMenuItem(
                            icon: "seal",
                            title: "Loyalty",
                            showsDisclosure: true,
                            destinationType: .loyalty
                        )
                        
                        ProfileMenuItem(
                            icon: "bookmark",
                            title: "Lists",
                            showsDisclosure: true,
                            destinationType: .lists
                        )
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle",
                            title: "Support",
                            showsDisclosure: true,
                            destinationType: .support
                        )
                        
                        ProfileMenuItem(
                            icon: "power",
                            title: "Logout",
                            showsDisclosure: true,
                            destinationType: .logout
                        )
                        
                    }
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
    }
    
}

#Preview {
    ProfileView()
}
