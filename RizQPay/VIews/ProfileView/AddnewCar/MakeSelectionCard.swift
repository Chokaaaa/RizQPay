//
//  MakeSelectionCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct MakeSelectionCard: View {
    @Binding var selectedMake: String
    @Binding var isExpanded: Bool
    let onTap: () -> Void
    let onSearchTap: () -> Void
    
    // Car makes data with real asset names based on the image you showed
    private let carMakes = [
        CarMake(name: "Nissan", imageName: "nissan-logo"),
        CarMake(name: "Toyota", imageName: "toyota-logo"),
        CarMake(name: "BMW", imageName: "bmw-logo"),
        CarMake(name: "Mercedes", imageName: "mercedes-logo"),
        CarMake(name: "Audi", imageName: "audi-logo"),
        CarMake(name: "Ford", imageName: "ford-logo"),
        CarMake(name: "Honda", imageName: "honda-logo"),
        CarMake(name: "Hyundai", imageName: "hyundai-logo")
    ]
    
    // Mapping from display name to data key
    private func getDataKey(for displayName: String) -> String {
        switch displayName {
        case "Mercedes":
            return "Mercedes-Benz"
        default:
            return displayName
        }
    }
    
    // Mapping from data key to display name
    private func getDisplayName(for dataKey: String) -> String {
        switch dataKey {
        case "Mercedes-Benz":
            return "Mercedes"
        default:
            return dataKey
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("*Make")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !selectedMake.isEmpty {
                    Text(getDisplayName(for: selectedMake))
                        .font(.body)
                        .foregroundColor(.black)
                } else {
                    Text("Add")
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .onTapGesture {
                onTap()
            }
            
            // Expandable content
            if isExpanded {
                VStack(spacing: 20) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Search button
                    Button(action: onSearchTap) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search make")
                                .foregroundColor(.gray)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    
                    // Car makes grid - 2 rows exactly like in the image
                    VStack(spacing: 15) {
                        // First row
                        HStack(spacing: 15) {
                            ForEach(Array(carMakes.prefix(4)), id: \.name) { make in
                                CarMakeButton(make: make) {
                                    selectedMake = getDataKey(for: make.name)
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isExpanded = false
                                    }
                                }
                            }
                        }
                        
                        // Second row
                        HStack(spacing: 15) {
                            ForEach(Array(carMakes.suffix(4)), id: \.name) { make in
                                CarMakeButton(make: make) {
                                    selectedMake = getDataKey(for: make.name)
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isExpanded = false
                                    }
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
