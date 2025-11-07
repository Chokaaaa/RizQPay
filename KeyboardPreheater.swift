//
//  KeyboardPreheater.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 07/11/2025.
//

import Foundation
import SwiftUI
import UIKit

struct KeyboardPreheater: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let host = UIView(frame: .zero)
        let tf = UITextField(frame: .zero)
        tf.isHidden = true
        tf.autocorrectionType = .no
        tf.smartInsertDeleteType = .no
        host.addSubview(tf)

        // Preload on next runloop so it doesn’t clash with other presents
        DispatchQueue.main.async {
            tf.becomeFirstResponder()
            // Briefly show, then resign to hide the keyboard
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tf.resignFirstResponder()
            }
        }
        return host
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}
