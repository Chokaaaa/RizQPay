//
//  LoyaltyView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 03/11/2025.
//

import SwiftUI

struct LoyaltyView: View {
    @State private var freeItems: Int = 0
    @State private var currentStamps: Int = 8
    @State private var totalStamps: Int = 9
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Orange header section
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("Free Items")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text("\(freeItems)")
                                .font(.system(size: 80, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .background(
                    Color.mint
                        .ignoresSafeArea(edges: .horizontal)
                )
                
                // White content section
                VStack(spacing: 24) {
                    // Restaurant info
                    HStack {
                        HStack(spacing: 12) {
                            Image("honney-coffe")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 55, alignment: .leading)
                                .clipShape(RoundedRectangle(cornerRadius: 7))
//                                .font(.system(size: 28, weight: .bold))
//                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Honney Coffee")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "location.fill")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("Улица Кажымукана, 49")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 5)
                            }
                        }
                        
                        Spacer()
                        
                        Button("See menu") {
                            // Menu action
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.bottom, 35)
                    }
                    .padding(.horizontal, 20)
                    
                    // Stamps progress section
                    VStack(spacing: 16) {
                        // Stamps grid
                        HStack(spacing: 12) {
                            ForEach(0..<totalStamps, id: \.self) { index in
                                Image("honney-coffe")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .opacity(index < currentStamps ? 1.0 : 0.3)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Progress text
                        Text("\(totalStamps - currentStamps) more stamps to get a freeby")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationView {
        LoyaltyView()
    }
}
