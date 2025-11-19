//
//  ProfileView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
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
                            title: "Membership",
                            badge: "Bronze",
                            showsDisclosure: true,
                            destinationType: .coins
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Wallet",
                            subtitle: "2,500 ₸",
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
                            icon: "questionmark.circle",
                            title: "Support",
                            showsDisclosure: true,
                            destinationType: .support
                        )
                        
                        // Logout button that clears authentication
                        Button {
                            authManager.logout()
                        } label: {
                            HStack {
                                Image(systemName: "power")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                    .frame(width: 24)
                                
                                Text("Logout")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                        
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
        .environmentObject(AuthenticationManager())
}
