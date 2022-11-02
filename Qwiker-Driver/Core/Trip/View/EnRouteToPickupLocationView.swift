//
//  EnRouteToPickupLocationView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct EnRouteToPickupLocationView: View {
    @State private var isActiveBtn: Bool = false
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        BottomSheetView(spacing: 15, maxHeightForBounds: 8) {
            locationSection
            pickUpButton
        }
        .onReceive(LocationManager.shared.$didEnterPickupRegion, perform: { didEnterPickupRegion in
            isActiveBtn = didEnterPickupRegion
        })
    }
}

struct EnRouteToPickupLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.gray.ignoresSafeArea()
            EnRouteToPickupLocationView()
        }
        .environmentObject(dev.homeViewModel)
    }
}


extension EnRouteToPickupLocationView{
    private var locationSection: some View{
        LocationCellView(isDestination: false, title: homeVM.trip?.pickupLocationAddress ?? "")
            .hLeading()
    }
    private var pickUpButton: some View{
        HStack(spacing: 15) {
            Button {
                
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red.opacity(0.5))
            }
            PrimaryButtonView(showLoader: false, title: "Arrived", font: .title3.bold()) {
                homeVM.updateTripStateToArrived()
            }
//            .opacity(isActiveBtn ? 1 : 0.5)
//            .disabled(!isActiveBtn)
        }
    }
}
