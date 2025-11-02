//
//  MapView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 02/11/2025.
//

import SwiftUI

struct MapView: View {
    @State private var showingCamera = false
    
    var body: some View {
                
                    NavigationStack {
                        VStack {
                            HStack {
                                
                                
                                
                                Button(action: {
                                    // Profile action
                                }) {
                                    Text("NY")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(Color.gray)
                                        .clipShape(Circle())
//
                                        .frame(width: 44, height: 44)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.leading, 10)
                                .padding(.top, 10)
                                
                                Spacer()
                                
                                Button(action: {
//                                    Color.clear
//                                        .onAppear {
                                            showingCamera = true
//                                        }
                                }) {
                                    Image(systemName: "camera.fill")
                                        .foregroundStyle(Color.white)
                                        .frame(width: 36, height: 36)
                                        .background(Color.gray)
                                        .clipShape(Circle())
//
                                        .frame(width: 44, height: 44)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                                
                                
                            }
                            
                            Spacer()
                        }
                    }
               
                
            .fullScreenCover(isPresented: $showingCamera) {
                QRScannerView()
        }
    }
}

#Preview {
    MapView()
}
