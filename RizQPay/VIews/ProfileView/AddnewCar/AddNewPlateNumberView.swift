//
//  AddNewPlateNumberView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct AddNewPlateNumberView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vehicleManager: VehicleManager
    @State private var selectedColor: CarColor? = nil
    @State private var carMake = ""
    @State private var carModel = ""
    @State private var licensePlate = ""
    @State private var showingMakeSelection = false
    @State private var isColorCardExpanded = false
    @State private var isMakeCardExpanded = false
    @State private var isModelCardExpanded = false
    @State private var isLicensePlateExpanded = false
    @State private var isUpdatingFromSearch = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // License plate
                    LicensePlateCard(
                        licensePlate: $licensePlate,
                        isExpanded: $isLicensePlateExpanded,
                        onTapped: {
                            // Close all other cards when license plate is tapped
                            isColorCardExpanded = false
                            isMakeCardExpanded = false
                            isModelCardExpanded = false
                        },
                        onRegionComplete: {
                            // Open make card when license plate region is completed
                            withAnimation(.linear(duration: 0.1)) {
                                isMakeCardExpanded = true
                            }
                        }
                    )
                    
                                        
                    // Make Selection - Controlled expansion
                    MakeSelectionCard(
                        selectedMake: $carMake,
                        isExpanded: $isMakeCardExpanded,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                // Close other cards first
                                isColorCardExpanded = false
                                isModelCardExpanded = false
                                isLicensePlateExpanded = false
                                // Then toggle this card
                                isMakeCardExpanded.toggle()
                            }
                        },
                        onSearchTap: {
                            showingMakeSelection = true
                        }
                    )
                    .onChange(of: carMake) { oldMake, newMake in
                        // Reset model when make changes, but not when updating from search
                        if oldMake != newMake && !newMake.isEmpty && !isUpdatingFromSearch {
                            carModel = ""
                            // First collapse the make card, then expand model card
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMakeCardExpanded = false
                            }
                            // Delay the model card expansion for smooth transition
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isModelCardExpanded = true
                                }
                            }
                        }
                        
                        // Reset the flag after processing
                        if isUpdatingFromSearch {
                            isUpdatingFromSearch = false
                        }
                    }
                    
                    // Model Selection - Controlled expansion  
                    ModelSelectionCard(
                        selectedModel: $carModel,
                        isExpanded: $isModelCardExpanded,
                        selectedMake: carMake,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                // Close other cards first
                                isColorCardExpanded = false
                                isMakeCardExpanded = false
                                isLicensePlateExpanded = false
                                // Then toggle this card
                                isModelCardExpanded.toggle()
                            }
                        },
                        onMakeRequired: {
                            // Close all cards and open make card when make is required
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isColorCardExpanded = false
                                isModelCardExpanded = false
                                isLicensePlateExpanded = false
                                isMakeCardExpanded = true
                            }
                        },
                        onModelSelected: {
                            // Open color card when model is selected
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isColorCardExpanded = true
                            }
                        }
                    )
                    
                    ColorSelectionCard(
                        selectedColor: $selectedColor,
                        isExpanded: $isColorCardExpanded,
                        isMakeCardExpanded: $isMakeCardExpanded,
                        isModelCardExpanded: $isModelCardExpanded,
                        isLicensePlateExpanded: $isLicensePlateExpanded
                    )

                    
                    Spacer(minLength: 40)
                    
                    // Save Button
                    Button(action: {
                        // Create new vehicle and add it to the manager using the helper function
                        vehicleManager.addVehicle(
                            brand: carMake,
                            model: carModel,
                            plateNumber: licensePlate
                        )
                        
                        print("Saving car details:")
                        print("Color: \(selectedColor?.rawValue ?? "None")")
                        print("Make: \(carMake)")
                        print("Model: \(carModel)")
                        print("License Plate: \(licensePlate)")
                        dismiss()
                    }) {
                        Text("Save details")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.mint : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!isFormValid)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .onAppear {
                // Expand license plate card without triggering keyboard
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear(duration: 0.1)) {
                        isLicensePlateExpanded = true
                    }
                }
            }
            .sheet(isPresented: $showingMakeSelection) {
                CarMakeSearchView(
                    selectedMake: $carMake,
                    selectedModel: $carModel,
                    onSelection: { make, model in
                        // Set flag to prevent onChange from resetting model
                        isUpdatingFromSearch = true
                        carMake = make
                        carModel = model
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMakeCardExpanded = false
                            isModelCardExpanded = false
                        }
                        // Open color card when both make and model are selected from search
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isColorCardExpanded = true
                            }
                        }
                    }
                )
            }
        }
    }
    
    private var isFormValid: Bool {
        return selectedColor != nil && !carMake.isEmpty && !carModel.isEmpty && !licensePlate.isEmpty
    }
}
