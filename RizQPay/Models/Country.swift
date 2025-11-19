//
//  Country.swift
//  Stories
//
//  Created by Gwinyai Nyatsoka on 31/10/2025.
//

import SwiftUI

struct Country: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let code: String
    let dialCode: String
    let flag: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
