//
//  ColorSelectionCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct ColorSelectionCard: View {
    @Binding var selectedColor: CarColor?
    @Binding var isExpanded: Bool
    @Binding var isMakeCardExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("*Color")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let color = selectedColor {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(color.displayColor)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemGray5), lineWidth: color == .white ? 1 : 0)
                            )
                        Text(color.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
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
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                    if isExpanded {
                        isMakeCardExpanded = false
                    }
                }
            }
            
            // Expandable content
            if isExpanded {
                VStack(spacing: 16) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        // First row of colors
                        HStack(spacing: 30) {
                            ColorSelectionButton(color: .white, title: "White", isSelected: selectedColor == .white) {
                                selectedColor = .white
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .silver, title: "Silver", isSelected: selectedColor == .silver) {
                                selectedColor = .silver
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .gray, title: "Grey", isSelected: selectedColor == .gray) {
                                selectedColor = .gray
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .black, title: "Black", isSelected: selectedColor == .black) {
                                selectedColor = .black
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                          
                        }
                        
                        // Second row of colors
                        HStack(spacing: 30) {
                            ColorSelectionButton(color: .red, title: "Red", isSelected: selectedColor == .red) {
                                selectedColor = .red
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .yellow, title: "Yellow", isSelected: selectedColor == .yellow) {
                                selectedColor = .yellow
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                           
                            ColorSelectionButton(color: .orange, title: "Orange", isSelected: selectedColor == .orange) {
                                selectedColor = .orange
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .other, title: "Other", isSelected: selectedColor == .other) {
                                selectedColor = .other
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
