//
//  CountryPickerView.swift
//  Stories
//
//  Created for demo purposes
//

import SwiftUI

struct CountryPickerView: View {
    @Binding var selectedCountry: Country
    @Binding var isPresented: Bool
    
    let countries = [
        Country(name: "United Arab Emirates", code: "AE", dialCode: "+971", flag: "🇦🇪"),
        Country(name: "United States", code: "US", dialCode: "+1", flag: "🇺🇸"),
        Country(name: "United Kingdom", code: "GB", dialCode: "+44", flag: "🇬🇧"),
        Country(name: "Germany", code: "DE", dialCode: "+49", flag: "🇩🇪"),
        Country(name: "France", code: "FR", dialCode: "+33", flag: "🇫🇷"),
        Country(name: "India", code: "IN", dialCode: "+91", flag: "🇮🇳"),
        Country(name: "China", code: "CN", dialCode: "+86", flag: "🇨🇳"),
        Country(name: "Japan", code: "JP", dialCode: "+81", flag: "🇯🇵"),
        Country(name: "Kazakhstan", code: "KZ", dialCode: "+7", flag: "🇰🇿"),
        Country(name: "Canada", code: "CA", dialCode: "+1", flag: "🇨🇦")
    ]
    
    var body: some View {
        NavigationView {
            List(countries, id: \.code) { country in
                Button {
                    selectedCountry = country
                    isPresented = false
                } label: {
                    HStack {
                        Text(country.flag)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(country.name)
                                .font(.body)
                                .foregroundStyle(.primary)
                            
                            Text(country.dialCode)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedCountry.code == country.code {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    CountryPickerView(
        selectedCountry: .constant(Country(name: "United Arab Emirates", code: "AE", dialCode: "+971", flag: "🇦🇪")),
        isPresented: .constant(true)
    )
}