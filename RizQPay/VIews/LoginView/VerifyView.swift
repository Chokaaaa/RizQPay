//
//  VerifyView.swift
//  Stories
//
//  Created by Gwinyai Nyatsoka on 31/10/2025.
//


import SwiftUI

struct VerifyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var otpCode: String = ""
    @State private var isLoading = false
    @State private var showLoginError = false
    @FocusState private var isTextFieldFocused: Bool
    let phoneNumber: String
    let verificationID: String
    let onLoginSuccess: () -> Void  // Closure to handle successful login
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Verify Code")
                    .font(.system(size: 34, weight: .bold))
                
                Text("Enter the 6-digit code sent to \(phoneNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 48)
            
            // OTP Input
            VStack(spacing: 24) {
                HStack(spacing: 12) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPDigitView(
                            digit: otpCode.count > index ? String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: index)]) : "",
                            isFocused: isTextFieldFocused && otpCode.count == index
                        )
                    }
                }
                
                // Hidden TextField
                TextField("", text: $otpCode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isTextFieldFocused)
                    .frame(width: 1, height: 1)
                    .opacity(0.01)
                    .onChange(of: otpCode) { oldValue, newValue in
                        // Limit to 6 digits
                        if newValue.count > 6 {
                            otpCode = String(newValue.prefix(6))
                        }
                        // Only allow digits
                        otpCode = otpCode.filter { $0.isNumber }
                    }
            }
            .onTapGesture {
                isTextFieldFocused = true
            }
            .padding(.bottom, 32)
            
            // Submit button
            Button {
                attemptLogin()
            } label: {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Submit")
                            .font(.body.weight(.semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(otpCode.count < 6 || isLoading ? Color.gray.opacity(0.3) : Color.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(otpCode.count < 6 || isLoading)
            .animation(.easeInOut(duration: 0.2), value: otpCode.count)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
        .onAppear {
            isTextFieldFocused = true
        }
        .alert("Login Error", isPresented: $showLoginError) {
            Button {
                
            } label: {
                Text("OK")
            }
        } message: {
            Text("Invalid code. Please enter 123456 to continue.")
        }
    }
    
    func attemptLogin() {
        isLoading = true
        
        // Simulate loading delay for demo purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            
            // Only accept the specific code "123456" for demo purposes
            if self.otpCode == "123456" {
                // Login successful - call the closure
                self.onLoginSuccess()
            } else {
                self.showLoginError = true
            }
        }
    }
    
    
}

struct OTPDigitView: View {
    let digit: String
    let isFocused: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemBackground))
                .frame(width: 50, height: 56)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1)
                .frame(width: 50, height: 56)
            
            Text(digit)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    VerifyView(
        phoneNumber: "+7 712 345 678", 
        verificationID: "23123",
        onLoginSuccess: { print("Login successful!") }
    )
}
