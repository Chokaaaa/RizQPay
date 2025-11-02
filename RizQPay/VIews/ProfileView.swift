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
                            destination: AnyView(OrderHistoryView())
                        )
                        
                        ProfileMenuItem(
                            icon: "circle.circle",
                            title: "d-coins",
                            subtitle: "200",
                            badge: "Bronze",
                            showsDisclosure: true,
                            destination: AnyView(CoinsView())
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Wallet",
                            subtitle: "4.00 AED",
                            subtitleColor: .orange,
                            showsDisclosure: true,
                            destination: AnyView(WalletView())
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard.circle",
                            title: "Payments",
                            showsDisclosure: true,
                            destination: AnyView(PaymentsView())
                        )
                        
                        ProfileMenuItem(
                            icon: "car",
                            title: "Plate numbers",
                            showsDisclosure: true,
                            destination: AnyView(PlateNumbersView())
                        )
                        
                        ProfileMenuItem(
                            icon: "seal",
                            title: "Loyalty",
                            showsDisclosure: true,
                            destination: AnyView(LoyaltyView())
                        )
                        
                        ProfileMenuItem(
                            icon: "bookmark",
                            title: "Lists",
                            showsDisclosure: true,
                            destination: AnyView(ListsView())
                        )
                        
                      
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle",
                            title: "Support",
                            showsDisclosure: true,
                            destination: AnyView(SupportView())
                            
                        )
                        
                        ProfileMenuItem(
                            icon: "power",
                            title: "Logout",
                            showsDisclosure: true,
                            destination: AnyView(SuggestShopView())
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

struct ProfileHeaderView: View {
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            Circle()
                .fill(.orange)
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("NursultanYelemessov")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "phone")
                            .font(.caption)
                        Text("+971554258496")
                            .font(.subheadline)
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "car")
                            .font(.caption)
                        Text("v45528")
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let subtitleColor: Color
    let badge: String?
    let showsDisclosure: Bool
    let destination: AnyView?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        subtitleColor: Color = .secondary,
        badge: String? = nil,
        showsDisclosure: Bool = false,
        destination: AnyView? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.badge = badge
        self.showsDisclosure = showsDisclosure
        self.destination = destination
    }
    
    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination) {
                menuItemContent
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            Button(action: {
                // Handle menu item tap for items without destinations
                print("\(title) tapped")
            }) {
                menuItemContent
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        Divider()
            .padding(.leading, 59) // Align with text, not icon
    }
    
    private var menuItemContent: some View {
        HStack(spacing: 15) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(width: 24, height: 24)
            
            // Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Subtitle or Badge
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(subtitleColor)
            }
            
            if let badge = badge {
                Text(badge)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Disclosure Indicator
            if showsDisclosure {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    ProfileView()
}

// MARK: - Example Destination Views
struct OrderHistoryView: View {
    var body: some View {
        Text("Order History")
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoinsView: View {
    var body: some View {
        Text("d-coins")
            .navigationTitle("d-coins")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WalletView: View {
    var body: some View {
        Text("Wallet")
            .navigationTitle("Wallet")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaymentsView: View {
    var body: some View {
        Text("Payments")
            .navigationTitle("Payments")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlateNumbersView: View {
    var body: some View {
        Text("Plate Numbers")
            .navigationTitle("Plate Numbers")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoyaltyView: View {
    var body: some View {
        Text("Loyalty")
            .navigationTitle("Loyalty")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListsView: View {
    var body: some View {
        Text("Lists")
            .navigationTitle("Lists")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SuggestShopView: View {
    var body: some View {
        Text("Suggest a Shop")
            .navigationTitle("Suggest Shop")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupportView: View {
    var body: some View {
        Text("Support")
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
    }
}
