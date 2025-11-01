//
//  ContentView.swift
//  RizQPay
//
//  Created by Nursultan Yelemessov on 24/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var showingCamera = false
    
    var body: some View {
        Group {
            TabView {
                
                Tab.init("Home", systemImage: "house.fill") {
                    NavigationStack {
                        List {
                            
                        }
                        .navigationTitle("Home")
                    }
                }
                Tab.init("Scan", systemImage: "camera.fill") {
                    // Empty view that triggers the sheet presentation
                    Color.clear
                        .onAppear {
                            showingCamera = true
                        }
                }
                
                Tab.init("Profile", systemImage: "person.fill") {
                    NavigationStack {
                        List {
                            
                        }
                        .navigationTitle("Profile")
                    }
                }
                
                Tab.init("Search", systemImage: "magnifyingglass", role: .search) {
                    NavigationStack {
                        List {
                            
                        }
                        .navigationTitle("Search")
                        .searchable(text: $searchText, placement: .toolbar, prompt: "Search...")
                    }
                    
                }
                
            }
            .fullScreenCover(isPresented: $showingCamera) {
                QRScannerView()
            }
        }
    }
}

#Preview {
    ContentView()
}
