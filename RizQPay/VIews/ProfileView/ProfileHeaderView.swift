//
//  ProfileHeaderView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        
            
            VStack(alignment: .center, spacing: 10) {
                
                // Profile Image
                Circle()
                    .fill(.orange)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )

                
                Text("NursultanYelemessov")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 5) {
                    HStack(spacing: 5) {
                        Image(systemName: "phone")
                            .font(.caption)
                        Text("+971554258496")
                            .font(.subheadline)
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "car")
                            .font(.caption)
                        Text("KZ 100 ZLO 02")
                            .font(.subheadline)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            
        
    }
}
#Preview {
    ProfileView()
}
