//
//  ContentView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager.shared
    @StateObject var authViewModel = AuthenticationViewModel()
    var body: some View {
        Group{
            if authViewModel.userSession == nil{
                LoginView()
                    .environmentObject(authViewModel)
            }else{
                VStack{
                    Text("home")
                    Button("Log out", action: authViewModel.signOut)
                }
                
            }
        }
        .alert("Allow your location in the settings", isPresented: $locationManager.showAlert) {
            Button("Open settings", action: Helpers.openSettings)
        }
        .fullScreenCover(isPresented: $authViewModel.isShowDriverRegistrationView) {
            DriverRegistrationView()
                .environmentObject(authViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
