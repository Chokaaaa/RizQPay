//
//  RizQPayApp.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 24/08/2025.
//

import SwiftUI

@main
struct RizQPayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var vehicleManager = VehicleManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vehicleManager)
        }
    }
}
