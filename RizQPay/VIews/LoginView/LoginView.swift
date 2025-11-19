//
//  LoginView.swift
//  Stories
//
//  Created by Gwinyai Nyatsoka on 31/10/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    private let selectedCountry = Country(name: "Kazakhstan", code: "KZ", dialCode: "+7", flag: "🇰🇿")
    @State private var phoneNumber: String = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var verificationID: String?
    @State private var showVerifyView = false
    
    var fullPhoneNumber: String {
        selectedCountry.dialCode + phoneNumber.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome")
                        .font(.system(size: 34, weight: .bold))
                    
                    Text("Enter your phone number to continue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 48)
                
                // Phone input section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Phone Number")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 12) {
                        // Static country display
                        HStack(spacing: 6) {
                            Text(selectedCountry.flag)
                                .font(.title3)
                            Text(selectedCountry.dialCode)
                                .foregroundStyle(.primary)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        // Phone number field
                        TextField("123 123 123", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .textContentType(.telephoneNumber)
                            .font(.body)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(.tertiarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .disabled(isLoading)
                    }
                }
                .padding(.bottom, 32)
                
                // Verify button
                Button {
                    sendVerificationCode()
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Verify")
                                .font(.body.weight(.semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(phoneNumber.isEmpty || isLoading ? Color.gray.opacity(0.3) : Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(phoneNumber.isEmpty || isLoading)
                .animation(.easeInOut(duration: 0.2), value: phoneNumber.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .navigationDestination(isPresented: $showVerifyView) {
                if let verificationID = verificationID {
                    VerifyView(
                        phoneNumber: fullPhoneNumber,
                        verificationID: verificationID,
                        onLoginSuccess: {
                            // Handle successful login
                            authManager.login(phoneNumber: fullPhoneNumber)
                        }
                    )
                }
            }
        }
    }
    
    private func sendVerificationCode() {
        isLoading = true
        
        // Simulate loading delay for demo purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            
            // Generate a demo verification ID
            self.verificationID = "demo-verification-id-\(UUID().uuidString.prefix(8))"
            self.showVerifyView = true
        }
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
}
