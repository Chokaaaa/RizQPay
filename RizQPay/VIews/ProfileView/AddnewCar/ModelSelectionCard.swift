//
//  ModelSelectionCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

// MARK: - TagsView Component
struct TagsView<T: Hashable, Content: View>: View {
    let items: [T]
    let content: (T) -> Content
    
    init(items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(computeRows(), id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func computeRows() -> [[T]] {
        var rows: [[T]] = []
        var currentRow: [T] = []
        
        for item in items {
            currentRow.append(item)
            
            // Fill up first row with more items, then second row
            if currentRow.count >= 3 {
                rows.append(currentRow)
                currentRow = []
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
}

struct ModelSelectionCard: View {
    @Binding var selectedModel: String
    @Binding var isExpanded: Bool
    @State private var searchText: String = ""
    @State private var showingAlert = false
    @State private var showingModelSearch = false
    
    let selectedMake: String
    let onTap: () -> Void
    let onMakeRequired: () -> Void  // Callback to open make card when make is not selected
    let onModelSelected: () -> Void  // New callback for when model is selected
    
    // Mapping from data key to display name
    private func getDisplayName(for dataKey: String) -> String {
        switch dataKey {
        case "Mercedes-Benz":
            return "Mercedes"
        default:
            return dataKey
        }
    }
    
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
        .sheet(isPresented: $showingModelSearch) {
            CarModelSearchView(
                selectedMake: selectedMake,
                selectedModel: $selectedModel,
                onSelection: { model in
                    selectedModel = model
                    withAnimation(.linear(duration: 0.1)) {
                        isExpanded = false
                    }
                    // Trigger next card opening after collapse
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onModelSelected()
                    }
                }
            )
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
                    .foregroundColor(.black)
            } else {
                Text("Add")
                    .font(.body)
                    .foregroundColor(.black)
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
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, 20)
            
            // Search field
            Button(action: {
                showingModelSearch = true
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    Text("Search \(getDisplayName(for: selectedMake)) model")
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(25)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Model tags (maximum 5) with added spacing
            if !filteredModels.isEmpty {
                TagsView(items: filteredModels) { model in
                    Button(action: {
                        selectedModel = model
                        withAnimation(.linear(duration: 0.1)) {
                            isExpanded = false
                        }
                        searchText = "" // Reset search
                        // Trigger next card opening after collapse
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onModelSelected()
                        }
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
                .padding(.horizontal, 20)
                .padding(.top, 20)
            } else if !searchText.isEmpty {
                Text("No models found")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }
            
            // Bottom padding to maintain card height
            Spacer(minLength: 16)
        }
        .padding(.bottom, 16)
    }
}
