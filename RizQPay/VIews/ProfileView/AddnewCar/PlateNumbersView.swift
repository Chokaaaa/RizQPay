//
//  PlateNumbersView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct PlateNumbersView: View {
    @State private var selectedPlateNumber: String = "KZ 100 ZLO 02"
    
    // Mock plate numbers including KZ format
    private let plateNumbers = [
        "KZ 100 ZLO 02",
        "KZ 101 ABC 03",
        "KZ 102 XYZ 01"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Plate Numbers List
            List {
                ForEach(plateNumbers, id: \.self) { plateNumber in
                    PlateNumberRow(
                        plateNumber: plateNumber,
                        isSelected: selectedPlateNumber == plateNumber
                    ) {
                        selectedPlateNumber = plateNumber
                    }
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                .listRowSeparator(.visible)
                .listRowSeparatorTint(.gray.opacity(0.3))
            }
            .listStyle(.plain)
            .background(Color(.systemBackground))
            
            // Add New Plate Number Button
            VStack(spacing: 0) {
                Divider()
                
                NavigationLink(destination: AddNewPlateNumberView()) {
                    HStack {
                        Text("Add New Plate Number")
                            .font(.body)
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemBackground))
            }
        }
        .navigationTitle("Plate numbers")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    // Handle edit action
                    print("Edit tapped")
                }
                .foregroundColor(.blue)
            }
        }
    }
}
