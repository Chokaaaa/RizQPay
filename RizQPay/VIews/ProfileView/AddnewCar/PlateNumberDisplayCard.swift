//
//  PlateNumberDisplayCard.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 09/11/2025.
//

import SwiftUI

struct PlateNumberDisplayCard: View {
    let plateNumber: String
    let isSelected: Bool
    let onTap: () -> Void
    
    private var parsedPlate: (numbers: String, letters: String, region: String) {
        let components = plateNumber.components(separatedBy: " ")
        if components.count >= 4 && components[0] == "KZ" {
            return (
                numbers: components[1],
                letters: components[2], 
                region: components[3]
            )
        }
        return (numbers: "", letters: "", region: "")
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Kazakhstan License Plate Display
                licensePlateView
                
                Spacer()
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var licensePlateView: some View {
        HStack(spacing: 12) {
            // Left section with flag and KZ
            flagAndCountryCode
            
            // Numbers (100)
            plateSection(text: parsedPlate.numbers, width: 45)
            
            // Letters (ABC)
            plateSection(text: parsedPlate.letters, width: 45)
            
            // Vertical divider
            divider
            
            // Region (02)
            plateSection(text: parsedPlate.region, width: 25)
        }
        .background(plateBackground)
        .frame(height: 50)
    }
    
    private var flagAndCountryCode: some View {
        VStack(spacing: 1) {
            Text("🇰🇿")
                .font(.system(size: 12, weight: .bold))
            Text("KZ")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.black)
        }
        .frame(width: 28)
        .padding(.leading, 4)
    }
    
    private func plateSection(text: String, width: CGFloat) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .foregroundColor(.black)
            .frame(width: width)
            .multilineTextAlignment(.center)
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.black)
            .frame(width: 1, height: 35)
            .padding(.horizontal, 2)
    }
    
    private var plateBackground: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        PlateNumberDisplayCard(
            plateNumber: "KZ 100 ZLO 02",
            isSelected: false
        ) {
            print("Card tapped")
        }
        
        PlateNumberDisplayCard(
            plateNumber: "KZ 101 ABC 03",
            isSelected: true
        ) {
            print("Card tapped")
        }
    }
    .background(Color(.systemGroupedBackground))
    .padding()
}