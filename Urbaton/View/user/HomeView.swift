//
//  HomeView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 25.11.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var locManager: LocationManager = .init()
    
    @State private var selection = 1
    
    @EnvironmentObject var vmLogi: MainViewModel
    var body: some View {
        
        TabView (selection: $selection) {
            
            Color.white
            .tabItem {
                Image(systemName: "doc.plaintext")
            }
            .tag(0)


            NavigationStack {
                VStack{
                    if !locManager.planet {
                        ListParkView()
                            .environmentObject(locManager)
                    } else {
                        ParkingView()
                            .environmentObject(locManager)
                    }
                }
                .overlay(alignment: .topTrailing) {
                    Image(systemName: locManager.planet ? "globe.americas.fill" : "globe.americas" )
                        .padding()
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                        .background(.thickMaterial)
                        .cornerRadius(15)
                        .padding()
                        .onTapGesture {
                            withAnimation {
                                locManager.planet.toggle()
                                print(locManager.userLocation)
                            }
                        }
                        .shadow(color: locManager.planet ? Color.black.opacity(0.3) : Color.clear, radius: 15, x: 10, y: 15)
                }
            }
            .tabItem {
                Image(systemName: "parkingsign")
                
            }
            .tag(1)

            
            ProfileView()
            .tabItem {
                Image(systemName: "person")
            }
            .tag(2)

            
        }
        .onAppear(){
//            UITabBar.appearance().isTranslucent = false
            UITabBar.appearance().backgroundColor = UIColor.white
            locManager.checkIFLocationServicesIsEnabled()

        }
        
    }
}



#Preview {
    HomeView()
        .environmentObject(MainViewModel())
}
