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
    @FocusState private var isKeyboardWarmerFocused: Bool
    @State private var keyboardWarmerText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Hidden keyboard warmer
                    TextField("", text: $keyboardWarmerText)
                        .focused($isKeyboardWarmerFocused)
                        .frame(width: 0, height: 0)
                        .opacity(0)
                    
                    
                    // License plate
                    LicensePlateCard(
                        licensePlate: $licensePlate,
                        isExpanded: $isLicensePlateExpanded
                    )
                    
                                        
                    // Make Selection - Controlled expansion
                    MakeSelectionCard(
                        selectedMake: $carMake,
                        isExpanded: $isMakeCardExpanded,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMakeCardExpanded.toggle()
                                if isMakeCardExpanded {
                                    isColorCardExpanded = false
                                    isModelCardExpanded = false
                                }
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
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isModelCardExpanded.toggle()
                                if isModelCardExpanded {
                                    isColorCardExpanded = false
                                    isMakeCardExpanded = false
                                }
                            }
                        }
                    )
                    
                    ColorSelectionCard(
                        selectedColor: $selectedColor,
                        isExpanded: $isColorCardExpanded,
                        isMakeCardExpanded: $isMakeCardExpanded
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
                // Trigger keyboard immediately in background using hidden field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isKeyboardWarmerFocused = true
                }
                
                // Then expand license plate card after keyboard is warmed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
