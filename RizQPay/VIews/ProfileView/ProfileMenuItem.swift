//
//  ProfileMenuItem.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let subtitleColor: Color
    let badge: String?
    let showsDisclosure: Bool
    let destinationType: ProfileDestinationType?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        subtitleColor: Color = .secondary,
        badge: String? = nil,
        showsDisclosure: Bool = false,
        destinationType: ProfileDestinationType? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.badge = badge
        self.showsDisclosure = showsDisclosure
        self.destinationType = destinationType
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let destinationType = destinationType {
                NavigationLink(destination: destinationView(for: destinationType)) {
                    menuItemContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: {
                    print("\(title) tapped")
                }) {
                    menuItemContent
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Divider()
                .padding(.leading, 59)
        }
    }
    
    @ViewBuilder
    private func destinationView(for type: ProfileDestinationType) -> some View {
        switch type {
        case .orderHistory: OrderHistoryView()
        case .coins: CoinsView()
        case .wallet: WalletView()
        case .payments: PaymentsView()
        case .plateNumbers: PlateNumbersView()
        case .loyalty: LoyaltyView()
        case .lists: ListsView()
        case .support: SupportView()
        case .logout: SuggestShopView()
        }
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
