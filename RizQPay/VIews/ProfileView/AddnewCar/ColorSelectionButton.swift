//
//  ColorSelectionButton.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct ColorSelectionButton: View {
    let color: CarColor
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    // Reserve space for the border by always having a 54x54 frame
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 54, height: 54)
                    
                    // Main color circle
                    Circle()
                        .fill(color.displayColor)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color(.systemGray5), lineWidth: color == .white ? 1 : 0)
                        )
                    
                    // Selection border - always present but transparent when not selected
                    Circle()
                        .stroke(isSelected ? Color.mint : Color.clear, lineWidth: 3)
                        .frame(width: 50, height: 50)
                    
                    // Checkmark - always present but transparent when not selected
                    Image(systemName: "checkmark")
                        .foregroundColor(isSelected ? (color == .white || color == .yellow ? .mint : .white) : .clear)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}