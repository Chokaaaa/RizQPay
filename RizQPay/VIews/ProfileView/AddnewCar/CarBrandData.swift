//
//  CarBrandData.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import Foundation

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