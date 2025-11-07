//
//  ModelSelectionCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct ModelSelectionCard: View {
    @Binding var selectedModel: String
    @Binding var isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("*Model")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !selectedModel.isEmpty {
                    Text(selectedModel)
                        .font(.body)
                        .foregroundColor(.mint)
                } else {
                    Text("Add")
                        .font(.body)
                        .foregroundColor(.mint)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .onTapGesture {
                onTap()
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}