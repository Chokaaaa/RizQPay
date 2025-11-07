//
//  LicensePlateCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct LicensePlateCard: View {
    @Binding var licensePlate: String
    @Binding var isExpanded: Bool
    @State private var firstField: String = ""
    @State private var secondField: String = ""
    @FocusState private var focusedField: PlateField?
    @State private var hasInitialized = false
    @State private var updateTask: Task<Void, Never>?
    
    enum PlateField {
        case first, second
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerView
            
            // Expandable content with Kazakhstan license plate design
            if isExpanded {
                expandedContent
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onAppear {
            if !hasInitialized {
                parseExistingLicensePlate()
                hasInitialized = true
            }
        }
        .onDisappear {
            updateTask?.cancel()
        }
        
    }
    
    private var headerView: some View {
        HStack {
            Text("*License plate")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            if !licensePlate.isEmpty {
                Text(licensePlate)
                    .font(.body)
                    .foregroundColor(.primary)
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
            withAnimation(.linear(duration: 0.1)) {
                isExpanded.toggle()
            }
            if isExpanded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    focusedField = .first
                }
            }
        }
    }
    
    private var expandedContent: some View {
        VStack(spacing: 12) {
            Divider()
                .padding(.horizontal, 20)
            
            // Kazakhstan License Plate Input - Static Layout
            HStack(spacing: 0) {
                // Left section with flag and KZ
                flagAndCountryCode
                
                // First text field (main number and letters)
                firstTextField
                
                // Vertical divider
                divider
                
                // Second text field (region code)
                secondTextField
            }
            .background(plateBackground)
            .frame(height: 48)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
    }
    
    private var flagAndCountryCode: some View {
        VStack(spacing: 2) {
            Text("🇰🇿")
                .font(.system(size: 16, weight: .bold))
            Text("KZ")
                .font(.system(size: 14, weight: .black))
                .foregroundColor(.black)
        }
        .frame(width: 38)
        .padding(.leading, 6)
    }
    
    private var firstTextField: some View {
        TextField("100 ABC", text: $firstField)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .textCase(.uppercase)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.characters)
            .keyboardType(.asciiCapable)
            .focused($focusedField, equals: .first)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .onSubmit {
                focusedField = .second
            }
            .onChange(of: firstField) { newValue in
                handleFirstFieldChange(newValue)
            }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: 1.5, height: 32)
            .padding(.horizontal, 4)
    }
    
    private var secondTextField: some View {
        TextField("02", text: $secondField)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .textCase(.uppercase)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.characters)
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .second)
            .frame(width: 44)
            .padding(.trailing, 6)
            .background(Color.clear)
            .onChange(of: secondField) { newValue in
                handleSecondFieldChange(newValue)
            }
    }
    
    private var plateBackground: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black, lineWidth: 1.2)
            )
    }
    
    // MARK: - Helper Functions
    
    private func handleFirstFieldChange(_ newValue: String) {
        let filtered = String(newValue.prefix(7))
        if filtered != newValue {
            firstField = filtered
        }
        updateLicensePlateDebounced()
    }
    
    private func handleSecondFieldChange(_ newValue: String) {
        let filtered = String(newValue.filter { $0.isNumber }.prefix(2))
        if filtered != newValue {
            secondField = filtered
        }
        updateLicensePlateDebounced()
    }
    
    private func updateLicensePlateDebounced() {
        // Cancel previous task
        updateTask?.cancel()
        
        // Create new debounced task
        updateTask = Task {
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            
            if !Task.isCancelled {
                await MainActor.run {
                    updateLicensePlate()
                }
            }
        }
    }
    
    private func updateLicensePlate() {
        let newPlate: String
        if !firstField.isEmpty && !secondField.isEmpty {
            newPlate = "KZ \(firstField) \(secondField)"
        } else if firstField.isEmpty && secondField.isEmpty {
            newPlate = ""
        } else {
            return // Don't update if only one field is filled
        }
        
        if newPlate != licensePlate {
            licensePlate = newPlate
        }
    }
    
    private func parseExistingLicensePlate() {
        guard !licensePlate.isEmpty else { return }
        
        let components = licensePlate.components(separatedBy: " ")
        if components.count >= 4 && components[0] == "KZ" {
            firstField = "\(components[1]) \(components[2])"
            if components.count >= 4 {
                secondField = components[3]
            }
        }
    }
}
