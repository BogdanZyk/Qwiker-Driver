//
//  CancelledView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct CancelledView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack {
            Text("Passenger cancels a trip!")
                .font(.title.weight(.medium))
            PrimaryButtonView(title: "OK") {
                homeVM.mapState = .noInput
            }
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
        .padding()
        .padding(.bottom, getRect().height / 3)
    }
}

struct CancelledView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.gray.ignoresSafeArea()
            CancelledView()
        }
        .environmentObject(dev.homeViewModel)
    }
}
