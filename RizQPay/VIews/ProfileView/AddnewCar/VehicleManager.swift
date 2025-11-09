//
//  VehicleManager.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 09/11/2025.
//

import SwiftUI

struct Vehicle: Identifiable, Equatable {
    let id = UUID()
    let brand: String
    let model: String
    let plateNumber: String
    let logoName: String // Brand logo image name
    
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        lhs.id == rhs.id
    }
}

@MainActor
class VehicleManager: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var selectedVehicle: Vehicle? = nil
    
    init() {
        loadVehicles()
        selectedVehicle = vehicles.first
    }
    
    private func loadVehicles() {
        // Mock data - this will be replaced with API calls
        vehicles = [
            Vehicle(brand: "Toyota", model: "Camry", plateNumber: "KZ 100 ZLO 02", logoName: "toyota-logo"),
            Vehicle(brand: "Mercedes-Benz", model: "GL 500", plateNumber: "KZ 101 ABC 03", logoName: "mercedes-logo")
        ]
    }
    
    func selectVehicle(_ vehicle: Vehicle) {
        selectedVehicle = vehicle
    }
    
    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
        // Auto-select the newly added vehicle
        selectedVehicle = vehicle
    }
    
    func addVehicle(brand: String, model: String, plateNumber: String) {
        let logoName = getLogoForBrand(brand)
        let vehicle = Vehicle(brand: brand, model: model, plateNumber: plateNumber, logoName: logoName)
        addVehicle(vehicle)
    }
    
    private func getLogoForBrand(_ brand: String) -> String {
        let brandLower = brand.lowercased()
        switch brandLower {
        case let x where x.contains("toyota"):
            return "toyota-logo"
        case let x where x.contains("mercedes") || x.contains("benz"):
            return "mercedes-logo"
        case let x where x.contains("bmw"):
            return "bmw-logo"
        case let x where x.contains("audi"):
            return "audi-logo"
        case let x where x.contains("lexus"):
            return "lexus-logo"
        case let x where x.contains("honda"):
            return "honda-logo"
        case let x where x.contains("nissan"):
            return "nissan-logo"
        case let x where x.contains("hyundai"):
            return "hyundai-logo"
        case let x where x.contains("kia"):
            return "kia-logo"
        case let x where x.contains("volkswagen") || x.contains("vw"):
            return "volkswagen-logo"
        case let x where x.contains("ford"):
            return "ford-logo"
        case let x where x.contains("chevrolet") || x.contains("chevy"):
            return "chevrolet-logo"
        case let x where x.contains("mazda"):
            return "mazda-logo"
        case let x where x.contains("subaru"):
            return "subaru-logo"
        case let x where x.contains("mitsubishi"):
            return "mitsubishi-logo"
        case let x where x.contains("infiniti"):
            return "infiniti-logo"
        case let x where x.contains("acura"):
            return "acura-logo"
        case let x where x.contains("genesis"):
            return "genesis-logo"
        case let x where x.contains("porsche"):
            return "porsche-logo"
        case let x where x.contains("jaguar"):
            return "jaguar-logo"
        case let x where x.contains("land rover") || x.contains("landrover"):
            return "landrover-logo"
        case let x where x.contains("volvo"):
            return "volvo-logo"
        case let x where x.contains("cadillac"):
            return "cadillac-logo"
        case let x where x.contains("lincoln"):
            return "lincoln-logo"
        case let x where x.contains("tesla"):
            return "tesla-logo"
        default:
            return "generic-car-logo" // Fallback for unknown brands
        }
    }
    
    func removeVehicle(_ vehicle: Vehicle) {
        vehicles.removeAll { $0.id == vehicle.id }
        // If the removed vehicle was selected, select the first available vehicle
        if selectedVehicle?.id == vehicle.id {
            selectedVehicle = vehicles.first
        }
    }
    
    // API integration methods (to be implemented later)
    func fetchVehiclesFromAPI() async {
        // TODO: Implement API call to fetch vehicles
    }
    
    func saveVehicleToAPI(_ vehicle: Vehicle) async {
        // TODO: Implement API call to save vehicle
    }
    
    func deleteVehicleFromAPI(_ vehicle: Vehicle) async {
        // TODO: Implement API call to delete vehicle
    }
}
