//
//  AddAmountView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct AddAmountView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WalletViewModel
    @State private var amountText = ""
    @FocusState private var isAmountFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                headerText
                amountInputSection
                addButton
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
            .onAppear {
                isAmountFieldFocused = true
            }
        }
    }
    
    private var headerText: some View {
        Text("Add Amount to Wallet")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 32)
    }
    
    private var amountInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Amount (₸)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            TextField("0.00", text: $amountText)
                .font(.title)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isAmountFieldFocused)
        }
    }
    
    private var addButton: some View {
        Button("Add Amount") {
            addAmountToWallet()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(isAddButtonEnabled ? Color.orange : Color.gray.opacity(0.3))
        .foregroundColor(.white)
        .font(.headline)
        .cornerRadius(12)
        .disabled(!isAddButtonEnabled)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    private var isAddButtonEnabled: Bool {
        !amountText.isEmpty && Double(amountText) != nil && Double(amountText)! > 0
    }
    
    private func addAmountToWallet() {
        guard let amount = Double(amountText), amount > 0 else { return }
        viewModel.addAmount(amount)
        dismiss()
    }
}