//
//  AddNewPlateNumberView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct AddNewPlateNumberView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedColor: CarColor? = nil
    @State private var carMake = ""
    @State private var carModel = ""
    @State private var licensePlate = ""
    @State private var showingMakeSelection = false
    @State private var isColorCardExpanded = false
    @State private var isMakeCardExpanded = false
    @State private var isModelCardExpanded = false
    @State private var isLicensePlateExpanded = false
    
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
                        // Handle saving car details
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
                        carMake = make
                        carModel = model
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMakeCardExpanded = false
                            isModelCardExpanded = false
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
