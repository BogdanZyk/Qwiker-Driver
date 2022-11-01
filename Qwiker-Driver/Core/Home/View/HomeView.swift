//
//  HomeView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var homeVM = HomeViewModel()
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom){
                MapViewRepresentable()
                    .ignoresSafeArea()
            }
        }
        .environmentObject(homeVM)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthenticationViewModel())
    }
}
