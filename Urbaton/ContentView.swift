//
//  ContentView.swift
//  Urbaton
//
//  Created by Yaroslav Zagumennikov on 19.11.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject
    var mainVm = MainViewModel()
    
    var body: some View {
        NavigationView {
            if mainVm.showAuthContainer {
                LoginScreen()
            } else {
                Home()
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(mainVm)
        .navigationBarTitle("", displayMode: .inline)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
