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
    var onTapped: (() -> Void)?
    var onRegionComplete: (() -> Void)?
    @State private var numbersField: String = ""
    @State private var lettersField: String = ""
    @State private var regionField: String = ""
    @FocusState private var focusedField: PlateField?
    @State private var hasInitialized = false
    @State private var updateTask: Task<Void, Never>?
    
    enum PlateField {
        case numbers, letters, region
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
            // Always close other cards first - this is mandatory
            onTapped?()
            
            // Small delay to ensure other cards close first
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 0.1)) {
                    isExpanded.toggle()
                }
            }
        }
    }
    
    private var expandedContent: some View {
        VStack(spacing: 12) {
            Divider()
                .padding(.horizontal, 20)
            
            // Kazakhstan License Plate Input - Static Layout
            HStack(spacing: 20) {
                // Left section with flag and KZ
                flagAndCountryCode
                
                // Numbers field (100)
                numbersTextField
                
                // Letters field (ABC)
                lettersTextField
                
                // Vertical divider
                divider
                
                // Region field (02)
                regionTextField
            }
            .background(plateBackground)
            .frame(height: 75)
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
    
    private var numbersTextField: some View {
        TextField("100", text: $numbersField)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .disableAutocorrection(true)
            .autocorrectionDisabled(true)
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .numbers)
            .frame(width: 60)
            .background(Color.clear)
            .onSubmit {
                focusedField = .letters
            }
            .onChange(of: numbersField) { newValue in
                handleNumbersFieldChange(newValue)
            }
    }
    
    private var lettersTextField: some View {
        TextField("ABC", text: $lettersField)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .textCase(.uppercase)
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.characters)
            .keyboardType(.alphabet)
            .focused($focusedField, equals: .letters)
            .frame(width: 60)
            .background(Color.clear)
            .onSubmit {
                focusedField = .region
            }
            .onChange(of: lettersField) { newValue in
                handleLettersFieldChange(newValue)
            }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: 1.5, height: 52)
            .padding(.horizontal, 4)
    }
    
    private var regionTextField: some View {
        TextField("02", text: $regionField)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .disableAutocorrection(true)
            .autocorrectionDisabled(true)
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .region)
            .frame(width: 30)
            .padding(.trailing, 25)
            .background(Color.clear)
            .onChange(of: regionField) { newValue in
                handleRegionFieldChange(newValue)
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
    
    private func handleNumbersFieldChange(_ newValue: String) {
        let filtered = String(newValue.filter { $0.isNumber }.prefix(3))
        if filtered != newValue {
            numbersField = filtered
        }
        updateLicensePlateDebounced()
    }
    
    private func handleLettersFieldChange(_ newValue: String) {
        let filtered = String(newValue.filter { $0.isLetter }.prefix(3).uppercased())
        if filtered != newValue {
            lettersField = filtered
        }
        updateLicensePlateDebounced()
    }
    
    private func handleRegionFieldChange(_ newValue: String) {
        let filtered = String(newValue.filter { $0.isNumber }.prefix(2))
        if filtered != newValue {
            regionField = filtered
        }
        updateLicensePlateDebounced()
        
        // Auto-collapse and trigger next card when region is complete
        if filtered.count == 2 && !numbersField.isEmpty && !lettersField.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.linear(duration: 0.1)) {
                    isExpanded = false
                }
                // Trigger next card opening immediately after collapse starts
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onRegionComplete?()
                }
            }
        }
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
        if !numbersField.isEmpty && !lettersField.isEmpty && !regionField.isEmpty {
            newPlate = "KZ \(numbersField) \(lettersField) \(regionField)"
        } else if numbersField.isEmpty && lettersField.isEmpty && regionField.isEmpty {
            newPlate = ""
        } else {
            return // Don't update if not all fields are filled
        }
        
        if newPlate != licensePlate {
            licensePlate = newPlate
        }
    }
    
    private func parseExistingLicensePlate() {
        guard !licensePlate.isEmpty else { return }
        
        let components = licensePlate.components(separatedBy: " ")
        if components.count >= 4 && components[0] == "KZ" {
            numbersField = components[1]
            lettersField = components[2]
            if components.count >= 4 {
                regionField = components[3]
            }
        }
    }
}

