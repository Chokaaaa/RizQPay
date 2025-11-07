//
//  ModelSelectionCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct ModelSelectionCard: View {
    @Binding var selectedModel: String
    @Binding var isExpanded: Bool
    @State private var searchText: String = ""
    @State private var showingAlert = false
    
    let selectedMake: String
    let onTap: () -> Void
    let onMakeRequired: () -> Void  // Callback to open make card when make is not selected
    
    private var availableModels: [String] {
        guard !selectedMake.isEmpty else { return [] }
        return CarBrandData.carBrandModels[selectedMake] ?? []
    }
    
    private var filteredModels: [String] {
        if searchText.isEmpty {
            return Array(availableModels.prefix(5))
        } else {
            let filtered = availableModels.filter { $0.localizedCaseInsensitiveContains(searchText) }
            return Array(filtered.prefix(5))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerView
            
            // Expandable content
            if isExpanded {
                expandedContent
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("Make Required", isPresented: $showingAlert) {
            Button("OK") {
                onMakeRequired()
            }
        } message: {
            Text("Please select a car make first before choosing a model.")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("*Model")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            if !selectedModel.isEmpty {
                Text(selectedModel)
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
            if selectedMake.isEmpty {
                showingAlert = true
            } else {
                onTap()
            }
        }
    }
    
    private var expandedContent: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal, 20)
            
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search \(selectedMake) model", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .padding(.horizontal, 20)
            
            // Model capsules (maximum 5)
            if !filteredModels.isEmpty {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], alignment: .leading, spacing: 12) {
                    ForEach(filteredModels, id: \.self) { model in
                        Button(action: {
                            selectedModel = model
                            withAnimation(.linear(duration: 0.1)) {
                                isExpanded = false
                            }
                            searchText = "" // Reset search
                        }) {
                            Text(model)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            } else if !searchText.isEmpty {
                Text("No models found")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }
            
            Spacer(minLength: 20)
        }
        .padding(.bottom, 16)
    }
}