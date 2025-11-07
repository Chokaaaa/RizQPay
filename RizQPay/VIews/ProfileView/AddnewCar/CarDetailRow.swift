//
//  CarDetailRow.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct CarDetailRow: View {
    let title: String
    let value: String
    let hasValue: Bool
    let isOptional: Bool
    let action: () -> Void
    
    init(title: String, value: String, hasValue: Bool, isOptional: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.value = value
        self.hasValue = hasValue
        self.isOptional = isOptional
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(isOptional ? .secondary : .primary)
                
                Spacer()
                
                Text(hasValue ? value : "Add")
                    .font(.body)
                    .foregroundColor(.mint)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}