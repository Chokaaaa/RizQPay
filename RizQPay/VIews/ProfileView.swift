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
                                }
                            }
                        },
                        onSearchTap: {
                            showingMakeSelection = true
                        }
                    )
                    
                    // Model
                    CarDetailRow(
                        title: "*Model",
                        value: carModel,
                        hasValue: !carModel.isEmpty
                    ) {
                        showingModelSheet = true
                    }
                    
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
                CarMakeSearchView(selectedMake: $carMake)
            }
            .sheet(isPresented: $showingModelSheet) {
                CarModelSelectionView(selectedModel: $carModel)
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
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Sheet Views
struct CarMakeSearchView: View {
    @Binding var selectedMake: String
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // Full list of car makes for search
    private let allCarMakes = [
        "Acura", "Audi", "BMW", "Buick", "Cadillac", "Chevrolet", "Chrysler",
        "Dodge", "Ford", "Genesis", "GMC", "Honda", "Hyundai", "Infiniti",
        "Jaguar", "Jeep", "Kia", "Land Rover", "Lexus", "Lincoln", "Mazda",
        "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Porsche", "Ram",
        "Subaru", "Tesla", "Toyota", "Volkswagen", "Volvo"
    ]
    
    private var filteredMakes: [String] {
        if searchText.isEmpty {
            return allCarMakes
        } else {
            return allCarMakes.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
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
                            selectedMake = make
                            dismiss()
                        }) {
                            HStack {
                                Text(make)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                
                                Spacer()
                                
                                if selectedMake == make {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.mint)
                                        .font(.body)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Select Make")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

struct CarMakeSelectionView: View {
    @Binding var selectedMake: String
    @Environment(\.dismiss) private var dismiss
    
    private let carMakes = ["Toyota", "Honda", "BMW", "Mercedes", "Audi", "Volkswagen", "Hyundai", "Kia", "Nissan", "Ford"]
    
    var body: some View {
        NavigationView {
            List(carMakes, id: \.self) { make in
                Button(action: {
                    selectedMake = make
                    dismiss()
                }) {
                    HStack {
                        Text(make)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedMake == make {
                            Image(systemName: "checkmark")
                                .foregroundColor(.mint)
                        }
                    }
                }
            }
            .navigationTitle("Select Make")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CarModelSelectionView: View {
    @Binding var selectedModel: String
    @Environment(\.dismiss) private var dismiss
    
    private let carModels = ["Sedan", "SUV", "Hatchback", "Coupe", "Convertible", "Wagon", "Truck", "Van"]
    
    var body: some View {
        NavigationView {
            List(carModels, id: \.self) { model in
                Button(action: {
                    selectedModel = model
                    dismiss()
                }) {
                    HStack {
                        Text(model)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedModel == model {
                            Image(systemName: "checkmark")
                                .foregroundColor(.mint)
                        }
                    }
                }
            }
            .navigationTitle("Select Model")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
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
