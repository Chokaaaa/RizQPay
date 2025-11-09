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
        case let x where x.contains("acura"):
            return "acura-logo"
        case let x where x.contains("alfa romeo") || x.contains("alfaromeo"):
            return "alfaromeo-logo"
        case let x where x.contains("aston martin") || x.contains("astonmartin"):
            return "astonmartin-logo"
        case let x where x.contains("audi"):
            return "audi-logo"
        case let x where x.contains("avatr"):
            return "avatr-logo"
        case let x where x.contains("baic"):
            return "baic-logo"
        case let x where x.contains("bmw"):
            return "bmw-logo"
        case let x where x.contains("buick"):
            return "buick-logo"
        case let x where x.contains("byd"):
            return "byd-logo"
        case let x where x.contains("cadillac"):
            return "cadillac-logo"
        case let x where x.contains("changan"):
            return "changan-logo"
        case let x where x.contains("chery"):
            return "chery-logo"
        case let x where x.contains("chevrolet") || x.contains("chevy"):
            return "chevrolet-logo"
        case let x where x.contains("chrysler"):
            return "chrysler-logo"
        case let x where x.contains("citroen"):
            return "citroen-logo"
        case let x where x.contains("dodge"):
            return "dodge-logo"
        case let x where x.contains("exeed"):
            return "exeed-logo"
        case let x where x.contains("ferrari"):
            return "ferrari-logo"
        case let x where x.contains("fiat"):
            return "fiat-logo"
        case let x where x.contains("ford"):
            return "ford-logo"
        case let x where x.contains("forthing"):
            return "forthing-logo"
        case let x where x.contains("gac"):
            return "gac-logo"
        case let x where x.contains("geely"):
            return "geely-logo"
        case let x where x.contains("genesis"):
            return "genesis-logo"
        case let x where x.contains("gmc"):
            return "gmc-logo"
        case let x where x.contains("gwm"):
            return "gwm-logo"
        case let x where x.contains("haval"):
            return "haval-logo"
        case let x where x.contains("honda"):
            return "honda-logo"
        case let x where x.contains("hongqi"):
            return "hongqi-logo"
        case let x where x.contains("hummer"):
            return "hummer-logo"
        case let x where x.contains("hyundai"):
            return "hyundai-logo"
        case let x where x.contains("infiniti"):
            return "infiniti-logo"
        case let x where x.contains("jac"):
            return "jac-logo"
        case let x where x.contains("jaecoo"):
            return "jaecoo-logo"
        case let x where x.contains("jaguar"):
            return "jaguar-logo"
        case let x where x.contains("jeep"):
            return "jeep-logo"
        case let x where x.contains("jetour"):
            return "jetour-logo"
        case let x where x.contains("kaiyi"):
            return "kaiyi-logo"
        case let x where x.contains("kia"):
            return "kia-logo"
        case let x where x.contains("koenigsegg"):
            return "koenigsegg-logo"
        case let x where x.contains("lada"):
            return "lada-logo"
        case let x where x.contains("lamborghini"):
            return "lamborghini-logo"
        case let x where x.contains("land rover") || x.contains("landrover"):
            return "landrover-logo"
        case let x where x.contains("leapmotor"):
            return "leapmotor-logo"
        case let x where x.contains("lexus"):
            return "lexus-logo"
        case let x where x.contains("li auto") || x.contains("liauto"):
            return "liauto-logo"
        case let x where x.contains("lincoln"):
            return "lincoln-logo"
        case let x where x.contains("lotus"):
            return "lotus-logo"
        case let x where x.contains("lucid"):
            return "lucid-logo"
        case let x where x.contains("lynk") || x.contains("lynk & co"):
            return "lynkco-logo"
        case let x where x.contains("mahindra"):
            return "mahindra-logo"
        case let x where x.contains("maserati"):
            return "maserati-logo"
        case let x where x.contains("maybach"):
            return "maybach-logo"
        case let x where x.contains("mazda"):
            return "mazda-logo"
        case let x where x.contains("mclaren"):
            return "mclaren-logo"
        case let x where x.contains("mercedes") || x.contains("benz"):
            return "mercedes-logo"
        case let x where x.contains("mg"):
            return "mg-logo"
        case let x where x.contains("mini"):
            return "mini-logo"
        case let x where x.contains("mitsubishi"):
            return "mitsubishi-logo"
        case let x where x.contains("nio"):
            return "nio-logo"
        case let x where x.contains("nissan"):
            return "nissan-logo"
        case let x where x.contains("omoda"):
            return "omoda-logo"
        case let x where x.contains("opel"):
            return "opel-logo"
        case let x where x.contains("pagani"):
            return "pagani-logo"
        case let x where x.contains("peugeot"):
            return "peugeot-logo"
        case let x where x.contains("polaris"):
            return "polaris-logo"
        case let x where x.contains("pontiac"):
            return "pontiac-logo"
        case let x where x.contains("porsche"):
            return "porsche-logo"
        case let x where x.contains("ram"):
            return "ram-logo"
        case let x where x.contains("renault"):
            return "renault-logo"
        case let x where x.contains("rivian"):
            return "rivian-logo"
        case let x where x.contains("rolls") || x.contains("royce") || x.contains("Rolls-Royce"):
            return "rolls-royce-logo"
        case let x where x.contains("rox"):
            return "rox-logo"
        case let x where x.contains("skoda"):
            return "skoda-logo"
        case let x where x.contains("smart"):
            return "smart-logo"
        case let x where x.contains("soueast"):
            return "soueast-logo"
        case let x where x.contains("ssangyong"):
            return "ssangyong-logo"
        case let x where x.contains("subaru"):
            return "subaru-logo"
        case let x where x.contains("suzuki"):
            return "suzuki-logo"
        case let x where x.contains("tata"):
            return "tata-logo"
        case let x where x.contains("tesla"):
            return "tesla-logo"
        case let x where x.contains("toyota"):
            return "toyota-logo"
        case let x where x.contains("uaz"):
            return "uaz-logo"
        case let x where x.contains("volkswagen") || x.contains("vw"):
            return "volkswagen-logo"
        case let x where x.contains("volvo"):
            return "volvo-logo"
        case let x where x.contains("voyah"):
            return "voyah-logo"
        case let x where x.contains("xpeng"):
            return "xpeng-logo"
        case let x where x.contains("zeekr"):
            return "zeekr-logo"
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
