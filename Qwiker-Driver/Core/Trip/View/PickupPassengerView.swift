//
//  PickupPassengerView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct PickupPassengerView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        BottomSheetView(spacing: 15, maxHeightForBounds: 5) {
            destinationLocation
            Divider()
            paymentMethod
            Divider()
            tripTotal
            
            pickupButton
        }
    }
}

struct PickupPassengerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.gray.ignoresSafeArea()
            PickupPassengerView()
        }
        .environmentObject(dev.homeViewModel)
    }
}

extension PickupPassengerView{
    private var title: some View{
        Text("Pick up passenger")
            .font(.title3)
    }
    private var destinationLocation: some View{
        LocationCellView(isDestination: true, title: homeVM.trip?.dropoffLocationName ?? "")
            .hLeading()
    }
    
    private var pickupButton: some View{
        PrimaryButtonView(title: "PICK UP", font: .title3.bold()){
            homeVM.pickupPassenger()
        }
        .padding(.top)
    }
    private var tripTotal: some View{
        HStack{
            Text("Trip coast")
                .font(.poppinsRegular(size: 18))
            Spacer()
            Text(homeVM.trip?.tripCost.formatted(.currency(code: "USD")) ?? "")
                .font(.title3.bold())
        }
    }
    private var paymentMethod: some View{
        Text("Non-cash payment")
            .font(.poppinsMedium(size: 18))
            .hLeading()
    }
}
