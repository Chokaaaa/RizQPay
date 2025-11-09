//
//  PlateNumbersView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct PlateNumbersView: View {
    @EnvironmentObject var vehicleManager: VehicleManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Vehicles List
            List {
                ForEach(vehicleManager.vehicles) { vehicle in
                    VehicleRow(
                        vehicle: vehicle,
                        isSelected: vehicleManager.selectedVehicle?.id == vehicle.id
                    ) {
                        vehicleManager.selectVehicle(vehicle)
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .listRowSeparator(.visible)
                .listRowSeparatorTint(Color.gray.opacity(0.3))
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .background(Color(.systemGroupedBackground))
        }
        .navigationTitle("Vehicles")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddNewPlateNumberView()
                    .environmentObject(vehicleManager)) {
                    Text("Add new")
                        .font(.body)
                        .foregroundColor(.cyan)
                }
            }
        }
    }
}

struct VehicleRow: View {
    let vehicle: Vehicle
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Vehicle Logo
                VStack {
                    Image(vehicle.logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Vehicle Info
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(vehicle.brand) \(vehicle.model)")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(vehicle.plateNumber)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Selection Indicator
                if isSelected {
                    Image(systemName: "checkmark.square.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.cyan)
                } else {
                    Image(systemName: "square")
                        .font(.system(size: 24))
                        .foregroundColor(.gray.opacity(0.3))
                }
            }
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        PlateNumbersView()
            .environmentObject(VehicleManager())
    }
}
