//
//  DriverActivateButtonView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct DriverActivateButtonView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        Button {
            homeVM.updateDriverActiveState(true) {}
        } label: {
            VStack{
                Text("Receive orders")
                    .font(.poppinsMedium(size: 20))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .frame(height: 60)
            }
            .background{
                Capsule()
                    .fill(Color.primaryBlue)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                Capsule().stroke(lineWidth: 2)
                    .fill(Color.white)
            }
        }
    }
}

struct DriverActivateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            DriverActivateButtonView()
        }
        .environmentObject(dev.homeViewModel)
    }
}
