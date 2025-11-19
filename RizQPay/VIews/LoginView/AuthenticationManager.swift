//
//  AuthenticationManager.swift
//  RizQPay
//
//  Created by Authentication System
//

import SwiftUI

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userPhoneNumber: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let isLoggedInKey = "isLoggedIn"
    private let phoneNumberKey = "userPhoneNumber"
    
    init() {
        loadAuthenticationState()
    }
    
    /// Load authentication state from UserDefaults
    private func loadAuthenticationState() {
        isLoggedIn = userDefaults.bool(forKey: isLoggedInKey)
        userPhoneNumber = userDefaults.string(forKey: phoneNumberKey) ?? ""
    }
    
    /// Save authentication state to UserDefaults
    private func saveAuthenticationState() {
        userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
        userDefaults.set(userPhoneNumber, forKey: phoneNumberKey)
    }
    
    /// Login user with phone number
    func login(phoneNumber: String) {
        isLoggedIn = true
        userPhoneNumber = phoneNumber
        saveAuthenticationState()
    }
    
    /// Logout user
    func logout() {
        isLoggedIn = false
        userPhoneNumber = ""
        saveAuthenticationState()
    }
    
    /// Check if user is authenticated
    var isAuthenticated: Bool {
        return isLoggedIn && !userPhoneNumber.isEmpty
    }
}