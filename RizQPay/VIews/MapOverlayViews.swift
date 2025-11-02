//
//  MapOverlayViews.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI

// MARK: - Map Overlay Views
struct MapOverlayButton: View {
    let systemImage: String
    let text: String?
    let action: () -> Void
    
    init(systemImage: String, action: @escaping () -> Void) {
        self.systemImage = systemImage
        self.text = nil
        self.action = action
    }
    
    init(text: String, action: @escaping () -> Void) {
        self.systemImage = ""
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Group {
                if let text = text {
                    Text(text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: systemImage)
                        .foregroundStyle(Color.white)
                }
            }
            .frame(width: 36, height: 36)
            .background(Color.gray)
            .clipShape(Circle())
            .frame(width: 44, height: 44)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 2)
        }
    }
}

struct TopOverlayBar: View {
    let onProfileTap: () -> Void
    let onCameraTap: () -> Void
    
    var body: some View {
        HStack {
            MapOverlayButton(text: "NY", action: onProfileTap)
                .padding(.leading, 16)
                .padding(.top, 10)
            
            Spacer()
            
            MapOverlayButton(systemImage: "camera.fill", action: onCameraTap)
                .padding(.trailing, 16)
                .padding(.top, 10)
        }
    }
}

struct BottomOverlayBar: View {
    let onLocationTap: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            MapOverlayButton(systemImage: "location.fill", action: onLocationTap)
                .padding(.trailing, 16)
                .padding(.bottom, 20)
        }
    }
}

struct MapOverlayView: View {
    let onProfileTap: () -> Void
    let onCameraTap: () -> Void
    let onLocationTap: () -> Void
    
    var body: some View {
        VStack {
            TopOverlayBar(
                onProfileTap: onProfileTap,
                onCameraTap: onCameraTap
            )
            
            Spacer()
            
            BottomOverlayBar(onLocationTap: onLocationTap)
        }
    }
}