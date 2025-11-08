//
//  CarMakeSearchView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct CarMakeSearchView: View {
    @Binding var selectedMake: String
    @Binding var selectedModel: String
    let onSelection: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedBrand: String?
    @State private var showingModels = false
    
    // Full list of car makes for search
    private let allCarMakes = [
        "Acura", "Alfa Romeo", "Aston Martin", "Audi", "Avatr",
        "Baic", "Bentley", "BMW", "Buick", "BYD",
        "Cadillac", "Changan", "Chery", "Chevrolet", "Chrysler", "Citroen",
        "Dodge",
        "Exeed",
        "Ford", "Ferrari", "Fiat", "Forthing",
        "Gac", "Geely", "Genesis", "GMC", "GWM",
        "Haval", "Honda", "Hongqi", "Hummer", "Hyundai",
        "Infiniti",
        "Jac", "Jaecoo", "Jaguar", "Jeep", "Jetour",
        "Kia", "Kaiyi", "Koenigsegg",
        "Lada", "Lamborghini", "Land Rover", "Lexus", "Leapmotor", "Li Auto", "Lincoln", "Lotus", "Lucid", "Lynk & Co",
        "Mahindra", "Maserati", "Maybach", "Mazda", "McLaren", "Mercedes-Benz", "MG", "Mini", "Mitsubishi",
        "Nissan", "NIO",
        "Omoda", "Opel",
        "Pagani", "Peugeot", "Polaris", "Pontiac", "Porsche",
        "Ram", "Renault", "Rivian", "Rolls-Royce", "Rox",
        "Subaru", "Skoda", "Smart", "Soueast", "SsangYong", "Suzuki",
        "Tata", "Tesla", "Toyota",
        "UAZ",
        "Volkswagen", "Volvo", "Voyah",
        "Xpeng",
        "Zeekr",
        "Other"
    ]
    
    private var filteredMakes: [String] {
        if searchText.isEmpty {
            return allCarMakes
        } else {
            return allCarMakes.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !showingModels {
                    // Makes list view
                    makesListView
                } else {
                    // Models list view
                    modelsListView
                }
            }
            .navigationTitle(showingModels ? selectedBrand ?? "" : "Select Make")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if showingModels {
                        Button("Back") {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showingModels = false
                            }
                        }
                    } else {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                
                if !showingModels {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    private var makesListView: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search make", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Car makes list
            List {
                ForEach(filteredMakes, id: \.self) { make in
                    Button(action: {
                        selectedBrand = make
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showingModels = true
                        }
                    }) {
                        HStack(spacing: 15) {
                            // Brand logo
                            Image("\(make.lowercased())-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            // Brand name
                            Text(make)
                                .foregroundColor(.primary)
                                .font(.body)
                            
                            Spacer()
                            
                            // Chevron
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.plain)
        }
    }
    
    private var modelsListView: some View {
        List {
            if let brand = selectedBrand,
               let models = CarBrandData.carBrandModels[brand] {
                ForEach(models, id: \.self) { model in
                    Button(action: {
                        onSelection(brand, model)
                        dismiss()
                    }) {
                        HStack {
                            Text(model)
                                .foregroundColor(.primary)
                                .font(.body)
                            
                            Spacer()
                            
                            if selectedModel == model && selectedMake == brand {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.mint)
                                    .font(.body)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets())
                }
            } else {
                Text("No models available")
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(.plain)
    }
}
