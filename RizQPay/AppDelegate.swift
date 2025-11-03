//
//  AppDelegate.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import Foundation
import UIKit
import SwiftUI
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyDzutXe4rbv6nycRRJaSSSVQz_egFL0oEc")
        return true
    }
}
