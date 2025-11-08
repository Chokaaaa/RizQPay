//
//  CarModelSearchView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct CarModelSearchView: View {
    let selectedMake: String
    @Binding var selectedModel: String
    let onSelection: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // Mapping from display name to data key
    private func getDataKey(for displayName: String) -> String {
        switch displayName {
        case "Mercedes":
            return "Mercedes-Benz"
        default:
            return displayName
        }
    }
    
    private var availableModels: [String] {
        let dataKey = getDataKey(for: selectedMake)
        return CarBrandData.carBrandModels[dataKey] ?? []
    }
    
    private var filteredModels: [String] {
        if searchText.isEmpty {
            return availableModels
        } else {
            return availableModels.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search \(selectedMake) models", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button("Clear") {
                            searchText = ""
                        }
                        .foregroundColor(.mint)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(25)
                .padding()
                
                // Models list
                List {
                    ForEach(filteredModels, id: \.self) { model in
                        Button(action: {
                            selectedModel = model
                            onSelection(model)
                            dismiss()
                        }) {
                            HStack {
                                Text(model)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                if selectedModel == model {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.mint)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("\(selectedMake) Models")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.mint)
                }
            }
        }
    }
}