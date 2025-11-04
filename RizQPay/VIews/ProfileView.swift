//
//  ProfileView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

enum ProfileDestinationType {
    case orderHistory, coins, wallet, payments, plateNumbers, loyalty, lists, support, logout
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Profile Header
                    ProfileHeaderView()
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        ProfileMenuItem(
                            icon: "doc.text",
                            title: "Order history",
                            showsDisclosure: true,
                            destinationType: .orderHistory
                        )
                        
                        ProfileMenuItem(
                            icon: "circle.circle",
                            title: "d-coins",
                            subtitle: "200",
                            badge: "Bronze",
                            showsDisclosure: true,
                            destinationType: .coins
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard",
                            title: "Wallet",
                            subtitle: "4.00 AED",
                            subtitleColor: .orange,
                            showsDisclosure: true,
                            destinationType: .wallet
                        )
                        
                        ProfileMenuItem(
                            icon: "creditcard.circle",
                            title: "Payments",
                            showsDisclosure: true,
                            destinationType: .payments
                        )
                        
                        ProfileMenuItem(
                            icon: "car",
                            title: "Plate numbers",
                            showsDisclosure: true,
                            destinationType: .plateNumbers
                        )
                        
                        ProfileMenuItem(
                            icon: "seal",
                            title: "Loyalty",
                            showsDisclosure: true,
                            destinationType: .loyalty
                        )
                        
                        ProfileMenuItem(
                            icon: "bookmark",
                            title: "Lists",
                            showsDisclosure: true,
                            destinationType: .lists
                        )
                        
                        ProfileMenuItem(
                            icon: "questionmark.circle",
                            title: "Support",
                            showsDisclosure: true,
                            destinationType: .support
                        )
                        
                        ProfileMenuItem(
                            icon: "power",
                            title: "Logout",
                            showsDisclosure: true,
                            destinationType: .logout
                        )
                        
                    }
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        HStack(spacing: 15) {
            // Profile Image
            Circle()
                .fill(.orange)
                .frame(width: 70, height: 70)
                .overlay(
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("NursultanYelemessov")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack(spacing: 15) {
                    HStack(spacing: 5) {
                        Image(systemName: "phone")
                            .font(.caption)
                        Text("+971554258496")
                            .font(.subheadline)
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "car")
                            .font(.caption)
                        Text("v45528")
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String?
    let subtitleColor: Color
    let badge: String?
    let showsDisclosure: Bool
    let destinationType: ProfileDestinationType?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        subtitleColor: Color = .secondary,
        badge: String? = nil,
        showsDisclosure: Bool = false,
        destinationType: ProfileDestinationType? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.badge = badge
        self.showsDisclosure = showsDisclosure
        self.destinationType = destinationType
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let destinationType = destinationType {
                NavigationLink(destination: destinationView(for: destinationType)) {
                    menuItemContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: {
                    print("\(title) tapped")
                }) {
                    menuItemContent
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Divider()
                .padding(.leading, 59)
        }
    }
    
    @ViewBuilder
    private func destinationView(for type: ProfileDestinationType) -> some View {
        switch type {
        case .orderHistory: OrderHistoryView()
        case .coins: CoinsView()
        case .wallet: WalletView()
        case .payments: PaymentsView()
        case .plateNumbers: PlateNumbersView()
        case .loyalty: LoyaltyView()
        case .lists: ListsView()
        case .support: SupportView()
        case .logout: SuggestShopView()
        }
    }
    
    private var menuItemContent: some View {
        HStack(spacing: 15) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(width: 24, height: 24)
            
            // Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Subtitle or Badge
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(subtitleColor)
            }
            
            if let badge = badge {
                Text(badge)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // Disclosure Indicator
            if showsDisclosure {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}

// MARK: - Example Destination Views
struct OrderHistoryView: View {
    var body: some View {
        Text("Order History")
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoinsView: View {
    var body: some View {
        Text("d-coins")
            .navigationTitle("d-coins")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WalletView: View {
    var body: some View {
        Text("Wallet")
            .navigationTitle("Wallet")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaymentsView: View {
    var body: some View {
        Text("Payments")
            .navigationTitle("Payments")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlateNumbersView: View {
    @State private var selectedPlateNumber: String = "KZ 100 ZLO 02"
    @State private var showingAddNewPlate = false
    
    // Mock plate numbers including KZ format
    private let plateNumbers = [
        "KZ 100 ZLO 02",
        "KZ 101 ABC 03",
        "KZ 102 XYZ 01"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Plate Numbers List
            List {
                ForEach(plateNumbers, id: \.self) { plateNumber in
                    PlateNumberRow(
                        plateNumber: plateNumber,
                        isSelected: selectedPlateNumber == plateNumber
                    ) {
                        selectedPlateNumber = plateNumber
                    }
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                .listRowSeparator(.visible)
                .listRowSeparatorTint(.gray.opacity(0.3))
            }
            .listStyle(.plain)
            .background(Color(.systemBackground))
            
            // Add New Plate Number Button
            VStack(spacing: 0) {
                Divider()
                
                Button(action: {
                    showingAddNewPlate = true
                }) {
                    HStack {
                        Text("Add New Plate Number")
                            .font(.body)
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemBackground))
            }
        }
        .navigationTitle("Plate numbers")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    // Handle edit action
                    print("Edit tapped")
                }
                .foregroundColor(.blue)
            }
        }
        .fullScreenCover(isPresented: $showingAddNewPlate) {
            AddNewPlateNumberView()
        }
    }
}

struct PlateNumberRow: View {
    let plateNumber: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(plateNumber)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddNewPlateNumberView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedColor: CarColor? = nil
    @State private var carMake = ""
    @State private var carModel = ""
    @State private var licensePlate = ""
    @State private var showingMakeSelection = false
    @State private var showingModelSheet = false
    @State private var showingLicensePlateSheet = false
    @State private var isColorCardExpanded = true
    @State private var isMakeCardExpanded = false
    @State private var isModelCardExpanded = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Color Selection - Controlled expansion
                    ColorSelectionCard(
                        selectedColor: $selectedColor,
                        isExpanded: $isColorCardExpanded,
                        isMakeCardExpanded: $isMakeCardExpanded
                    )
                    
                    // Make Selection - Controlled expansion
                    MakeSelectionCard(
                        selectedMake: $carMake,
                        isExpanded: $isMakeCardExpanded,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMakeCardExpanded.toggle()
                                if isMakeCardExpanded {
                                    isColorCardExpanded = false
                                    isModelCardExpanded = false
                                }
                            }
                        },
                        onSearchTap: {
                            showingMakeSelection = true
                        }
                    )
                    
                    // Model Selection - Controlled expansion  
                    ModelSelectionCard(
                        selectedModel: $carModel,
                        isExpanded: $isModelCardExpanded,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isModelCardExpanded.toggle()
                                if isModelCardExpanded {
                                    isColorCardExpanded = false
                                    isMakeCardExpanded = false
                                }
                            }
                        }
                    )
                    
                    // License plate
                    CarDetailRow(
                        title: "*License plate",
                        value: licensePlate,
                        hasValue: !licensePlate.isEmpty
                    ) {
                        showingLicensePlateSheet = true
                    }
                    
                    Spacer(minLength: 40)
                    
                    // Save Button
                    Button(action: {
                        // Handle saving car details
                        print("Saving car details:")
                        print("Color: \(selectedColor?.rawValue ?? "None")")
                        print("Make: \(carMake)")
                        print("Model: \(carModel)")
                        print("License Plate: \(licensePlate)")
                        dismiss()
                    }) {
                        Text("Save details")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.mint : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!isFormValid)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingMakeSelection) {
                CarMakeSearchView(
                    selectedMake: $carMake,
                    selectedModel: $carModel,
                    onSelection: { make, model in
                        carMake = make
                        carModel = model
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMakeCardExpanded = false
                            isModelCardExpanded = false
                        }
                    }
                )
            }
            .sheet(isPresented: $showingLicensePlateSheet) {
                LicensePlateInputView(licensePlate: $licensePlate)
            }
        }
    }
    
    private var isFormValid: Bool {
        return selectedColor != nil && !carMake.isEmpty && !carModel.isEmpty && !licensePlate.isEmpty
    }
}



// MARK: - Car Selection Components

enum CarColor: String, CaseIterable {
    case white = "White"
    case silver = "Silver"
    case gray = "Grey"
    case black = "Black"
    case blue = "Blue"
    case red = "Red"
    case green = "Green"
    case yellow = "Yellow"
    case orange = "Orange"
    case other = "Other"
    
    var displayColor: Color {
        switch self {
        case .white: return .white
        case .silver: return Color(.systemGray3)
        case .gray: return Color(.systemGray)
        case .black: return .black
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .other: return Color(.systemGray4)
        }
    }
}

struct CarMake {
    let name: String
    let imageName: String
}

struct ColorSelectionCard: View {
    @Binding var selectedColor: CarColor?
    @Binding var isExpanded: Bool
    @Binding var isMakeCardExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("*Color")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let color = selectedColor {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(color.displayColor)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemGray5), lineWidth: color == .white ? 1 : 0)
                            )
                        Text(color.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
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
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                    if isExpanded {
                        isMakeCardExpanded = false
                    }
                }
            }
            
            // Expandable content
            if isExpanded {
                VStack(spacing: 16) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 16) {
                        // First row of colors
                        HStack(spacing: 20) {
                            ColorSelectionButton(color: .white, title: "White", isSelected: selectedColor == .white) {
                                selectedColor = .white
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .silver, title: "Silver", isSelected: selectedColor == .silver) {
                                selectedColor = .silver
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .gray, title: "Grey", isSelected: selectedColor == .gray) {
                                selectedColor = .gray
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .black, title: "Black", isSelected: selectedColor == .black) {
                                selectedColor = .black
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .blue, title: "Blue", isSelected: selectedColor == .blue) {
                                selectedColor = .blue
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                        }
                        
                        // Second row of colors
                        HStack(spacing: 20) {
                            ColorSelectionButton(color: .red, title: "Red", isSelected: selectedColor == .red) {
                                selectedColor = .red
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .green, title: "Green", isSelected: selectedColor == .green) {
                                selectedColor = .green
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .yellow, title: "Yellow", isSelected: selectedColor == .yellow) {
                                selectedColor = .yellow
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .orange, title: "Orange", isSelected: selectedColor == .orange) {
                                selectedColor = .orange
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                            ColorSelectionButton(color: .other, title: "Other", isSelected: selectedColor == .other) {
                                selectedColor = .other
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isExpanded = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct MakeSelectionCard: View {
    @Binding var selectedMake: String
    @Binding var isExpanded: Bool
    let onTap: () -> Void
    let onSearchTap: () -> Void
    
    // Car makes data with real asset names based on the image you showed
    private let carMakes = [
        CarMake(name: "Nissan", imageName: "nissan-logo"),
        CarMake(name: "Toyota", imageName: "toyota-logo"),
        CarMake(name: "BMW", imageName: "bmw-logo"),
        CarMake(name: "Mercedes", imageName: "mercedes-logo"),
        CarMake(name: "Audi", imageName: "audi-logo"),
        CarMake(name: "Ford", imageName: "ford-logo"),
        CarMake(name: "Honda", imageName: "honda-logo"),
        CarMake(name: "Hyundai", imageName: "hyundai-logo")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("*Make")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !selectedMake.isEmpty {
                    Text(selectedMake)
                        .font(.body)
                        .foregroundColor(.mint)
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
                onTap()
            }
            
            // Expandable content
            if isExpanded {
                VStack(spacing: 20) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Search button
                    Button(action: onSearchTap) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search make")
                                .foregroundColor(.gray)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    
                    // Car makes grid - 2 rows exactly like in the image
                    VStack(spacing: 15) {
                        // First row
                        HStack(spacing: 15) {
                            ForEach(Array(carMakes.prefix(4)), id: \.name) { make in
                                CarMakeButton(make: make) {
                                    selectedMake = make.name
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isExpanded = false
                                    }
                                }
                            }
                        }
                        
                        // Second row
                        HStack(spacing: 15) {
                            ForEach(Array(carMakes.suffix(4)), id: \.name) { make in
                                CarMakeButton(make: make) {
                                    selectedMake = make.name
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isExpanded = false
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct CarMakeButton: View {
    let make: CarMake
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Car logo image from assets
                Image(make.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .background(Color.clear)
                
                Text(make.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct ModelSelectionCard: View {
    @Binding var selectedModel: String
    @Binding var isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("*Model")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !selectedModel.isEmpty {
                    Text(selectedModel)
                        .font(.body)
                        .foregroundColor(.mint)
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
                onTap()
            }
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ColorSelectionButton: View {
    let color: CarColor
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    // Reserve space for the border by always having a 54x54 frame
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 54, height: 54)
                    
                    // Main color circle
                    Circle()
                        .fill(color.displayColor)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color(.systemGray5), lineWidth: color == .white ? 1 : 0)
                        )
                    
                    // Selection border - always present but transparent when not selected
                    Circle()
                        .stroke(isSelected ? Color.mint : Color.clear, lineWidth: 3)
                        .frame(width: 50, height: 50)
                    
                    // Checkmark - always present but transparent when not selected
                    Image(systemName: "checkmark")
                        .foregroundColor(isSelected ? (color == .white || color == .yellow ? .mint : .white) : .clear)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CarDetailRow: View {
    let title: String
    let value: String
    let hasValue: Bool
    let isOptional: Bool
    let action: () -> Void
    
    init(title: String, value: String, hasValue: Bool, isOptional: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.value = value
        self.hasValue = hasValue
        self.isOptional = isOptional
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(isOptional ? .secondary : .primary)
                
                Spacer()
                
                Text(hasValue ? value : "Add")
                    .font(.body)
                    .foregroundColor(.mint)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Car Data Structure
struct CarBrandData {
    static let carBrandModels: [String: [String]] = [
        "Acura": ["CL", "EL", "ILX", "Integra", "Legend", "MDX", "NSX", "RDX", "RL", "RLX", "RSX", "SLX", "TL", "TLX", "TSX", "Vigor", "ZDX"],
        "Alfa Romeo": ["145", "146", "147", "155", "156", "159", "164", "166", "33", "4C", "75", "90", "Alfa 6", "Arna", "Brera", "GT", "GTV", "Giulia", "Giulietta", "MiTo", "Spider", "Stelvio", "Tonale"],
        "Aston Martin": ["Cygnet", "DB11", "DB7", "DB9", "DBS", "DBX", "Lagonda", "One-77", "Rapide", "V12 Vantage", "V8 Vantage", "Vanquish", "Vantage", "Virage"],
        "Audi": ["100", "200", "80", "90", "A1", "A3", "A4", "A4 Allroad", "A5", "A6", "A6 Allroad", "A7", "A8", "E-Tron", "E-Tron GT", "Q2", "Q3", "Q4 E-Tron", "Q5", "Q7", "Q8", "R8", "RS3", "RS4", "RS5", "RS6", "RS7", "RS8", "RSQ8", "S1", "S3", "S4", "S5", "S6", "S7", "S8", "SQ2", "SQ5", "SQ7", "SQ8", "TT", "TTS", "TT RS"],
        "BMW": ["1 Series", "2 Series", "3 Series", "4 Series", "5 Series", "6 Series", "7 Series", "8 Series", "i3", "i4", "i8", "iX", "iX3", "M1", "M2", "M3", "M4", "M5", "M6", "M8", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "XM", "Z1", "Z3", "Z4", "Z8"],
        "Buick": ["Cascada", "Century", "Enclave", "Encore", "Envision", "Envista", "LaCrosse", "LeSabre", "Lucerne", "Park Avenue", "Rainier", "Regal", "Rendezvous", "Riviera", "Roadmaster", "Skylark", "Terraza", "Verano"],
        "BYD": ["Atto 3", "Dolphin", "E6", "F0", "F3", "F6", "G3", "G6", "Han", "L3", "M6", "S6", "S7", "Seal", "Song", "Tang", "Yuan"],
        "Cadillac": ["ATS", "CTS", "CT4", "CT5", "CT6", "DeVille", "DTS", "Eldorado", "Escalade", "Fleetwood", "Lyriq", "SRX", "STS", "Seville", "XT4", "XT5", "XT6", "XTS"],
        "Chevrolet": ["Aveo", "Blazer", "Bolt", "Camaro", "Captiva", "Cobalt", "Colorado", "Corvette", "Cruze", "Equinox", "Express", "HHR", "Impala", "Kalos", "Lacetti", "Malibu", "Matiz", "Monte Carlo", "Orlando", "Silverado", "Sonic", "Spark", "Suburban", "Tahoe", "Tracker", "Trailblazer", "Traverse", "Volt"],
        "Chrysler": ["200", "300", "300C", "300M", "Aspen", "Concorde", "Crossfire", "Grand Voyager", "LHS", "Neon", "Pacifica", "PT Cruiser", "Sebring", "Town & Country", "Voyager"],
        "Citroen": ["Berlingo", "C1", "C2", "C3", "C3 Aircross", "C4", "C4 Cactus", "C4 Picasso", "C5", "C5 Aircross", "C6", "C8", "DS3", "DS4", "DS5", "Jumper", "Jumpy", "Nemo", "Saxo", "Spacetourer", "Xantia", "XM", "Xsara"],
        "Dodge": ["Avenger", "Caliber", "Challenger", "Charger", "Dakota", "Dart", "Durango", "Grand Caravan", "Journey", "Magnum", "Nitro", "Ram", "Stratus", "Viper"],
        "Ford": ["Aerostar", "B-Max", "Bronco", "C-Max", "Contour", "Crown Victoria", "EcoSport", "Edge", "Escape", "Escort", "Expedition", "Explorer", "F-150", "F-250", "F-350", "Fiesta", "Five Hundred", "Flex", "Focus", "Freestar", "Freestyle", "Fusion", "Galaxy", "Ka", "Kuga", "Mondeo", "Mustang", "Puma", "Ranger", "S-Max", "Taurus", "Territory", "Thunderbird", "Transit", "Windstar"],
        "Honda": ["Accord", "Civic", "CR-V", "CR-Z", "Element", "Fit", "HR-V", "Insight", "Odyssey", "Passport", "Pilot", "Prelude", "Ridgeline", "S2000"],
        "Hyundai": ["Accent", "Azera", "Elantra", "Equus", "Genesis", "Ioniq", "Kona", "Palisade", "Santa Fe", "Sonata", "Tucson", "Veloster", "Venue"],
        "Infiniti": ["EX", "FX", "G", "I", "J", "M", "Q30", "Q40", "Q50", "Q60", "Q70", "QX30", "QX50", "QX60", "QX70", "QX80"],
        "Jaguar": ["E-Pace", "F-Pace", "F-Type", "I-Pace", "S-Type", "X-Type", "XE", "XF", "XJ", "XK"],
        "Jeep": ["Cherokee", "Commander", "Compass", "Grand Cherokee", "Liberty", "Patriot", "Renegade", "Wagoneer", "Wrangler"],
        "Kia": ["Cadenza", "Carnival", "Ceed", "Cerato", "Forte", "K5", "K900", "Niro", "Optima", "Picanto", "Rio", "Sedona", "Sorento", "Soul", "Sportage", "Stinger", "Telluride"],
        "Lamborghini": ["Aventador", "Gallardo", "Huracan", "Murcielago", "Reventon", "Urus"],
        "Land Rover": ["Defender", "Discovery", "Discovery Sport", "Evoque", "Freelander", "Range Rover", "Range Rover Sport", "Range Rover Velar"],
        "Lexus": ["CT", "ES", "GS", "GX", "HS", "IS", "LC", "LS", "LX", "NX", "RC", "RX", "SC", "UX"],
        "Lincoln": ["Aviator", "Continental", "Corsair", "LS", "MKC", "MKS", "MKT", "MKX", "MKZ", "Navigator", "Town Car"],
        "Mazda": ["2", "3", "5", "6", "626", "929", "Atenza", "Axela", "B-Series", "BT-50", "CX-3", "CX-5", "CX-7", "CX-9", "CX-30", "MPV", "MX-5", "Premacy", "Protege", "RX-7", "RX-8", "Tribute"],
        "Mercedes-Benz": ["A-Class", "B-Class", "C-Class", "CL-Class", "CLA-Class", "CLK-Class", "CLS-Class", "E-Class", "G-Class", "GL-Class", "GLA-Class", "GLB-Class", "GLC-Class", "GLE-Class", "GLK-Class", "GLS-Class", "M-Class", "ML-Class", "R-Class", "S-Class", "SL-Class", "SLK-Class", "SLR McLaren", "SLS AMG", "V-Class", "Viano", "Vito"],
        "Mini": ["Clubman", "Countryman", "Coupe", "Hatch", "Paceman", "Roadster"],
        "Mitsubishi": ["3000GT", "ASX", "Challenger", "Colt", "Eclipse", "Eclipse Cross", "Endeavor", "Evolution", "Galant", "Grandis", "i-MiEV", "Lancer", "Mirage", "Montero", "Outlander", "Pajero", "Space Star"],
        "Nissan": ["350Z", "370Z", "Altima", "Armada", "Cube", "Frontier", "GT-R", "Juke", "Leaf", "Maxima", "Murano", "Navara", "Note", "NV200", "Pathfinder", "Patrol", "Qashqai", "Quest", "Rogue", "Sentra", "Sunny", "Titan", "Versa", "X-Trail", "Xterra"],
        "Porsche": ["911", "918 Spyder", "Boxster", "Cayenne", "Cayman", "Macan", "Panamera", "Taycan"],
        "Subaru": ["Ascent", "BRZ", "Crosstrek", "Forester", "Impreza", "Legacy", "Outback", "SVX", "Tribeca", "WRX"],
        "Tesla": ["Model 3", "Model S", "Model X", "Model Y", "Roadster"],
        "Toyota": ["4Runner", "86", "Avalon", "Avensis", "C-HR", "Camry", "Celica", "Corolla", "Crown", "FJ Cruiser", "Highlander", "Land Cruiser", "Matrix", "Prius", "RAV4", "Sequoia", "Sienna", "Supra", "Tacoma", "Tundra", "Venza", "Vios", "Yaris"],
        "Volkswagen": ["Arteon", "Atlas", "Beetle", "CC", "Eos", "Golf", "Jetta", "Passat", "Polo", "Scirocco", "Tiguan", "Touareg", "Touran"],
        "Volvo": ["C30", "C70", "S40", "S60", "S80", "S90", "V40", "V50", "V60", "V70", "V90", "XC40", "XC60", "XC70", "XC90"]
    ]
}
// MARK: - Sheet Views
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
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
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
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("No models available")
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(.plain)
    }
}

struct LicensePlateInputView: View {
    @Binding var licensePlate: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("Enter license plate", text: $licensePlate)
                    .font(.body)
                    .textCase(.uppercase)
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle("License Plate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlateNumberTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.body)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .autocapitalization(.allCharacters)
    }
}

struct LoyaltyView: View {
    var body: some View {
        Text("Loyalty")
            .navigationTitle("Loyalty")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListsView: View {
    var body: some View {
        Text("Lists")
            .navigationTitle("Lists")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SuggestShopView: View {
    var body: some View {
        Text("Suggest a Shop")
            .navigationTitle("Suggest Shop")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SupportView: View {
    var body: some View {
        Text("Support")
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
    }
}
