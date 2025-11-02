//
//  BusinessDetailView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI

// MARK: - Business Detail Views
struct BusinessDetailView: View {
    let business: BusinessLocation
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BusinessImageSection(business: business)
                BusinessInfoSection(business: business)
                BusinessContactSection(business: business)
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle(business.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BusinessImageSection: View {
    let business: BusinessLocation
    
    var body: some View {
        Image(business.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct BusinessInfoSection: View {
    let business: BusinessLocation
    
    var body: some View {
        VStack(spacing: 12) {
            Text(business.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Business Details")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

struct BusinessContactSection: View {
    let business: BusinessLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ContactRow(
                icon: "location",
                text: String(format: "Location: %.4f, %.4f", business.coordinate.latitude, business.coordinate.longitude)
            )
            
            ContactRow(
                icon: "clock",
                text: "Open: 9:00 AM - 10:00 PM"
            )
            
            ContactRow(
                icon: "phone",
                text: "+971 50 123 4567"
            )
        }
    }
}

struct ContactRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .font(.body)
        .foregroundColor(.secondary)
    }
}