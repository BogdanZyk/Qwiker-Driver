//
//  PickupPassengerView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct PickupPassengerView: View {
    @State private var waitTime: Date = Date.init(timeIntervalSinceNow: 180)
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        ZStack(alignment: .bottom) {
            ExpandedView(minHeight: getRect().height / 6, maxHeight: getRect().height / 1.3) { minHeight, rect, offset in
                BottomSheetView(spacing: 15, maxHeightForBounds: 1, isDragIcon: true) {
                    timerHeader
                    Group{
                        Divider().padding(.horizontal, -16)
                        destinationLocation
                        CustomDivider(verticalPadding: 0, lineHeight: 10).padding(.horizontal, -16)
                        paymentMethod
                        Divider()
                        tripTotal
                        Divider().padding(.horizontal, -16)
                        bottomActionButtons
                    }
                    .opacity(offset.wrappedValue > -10 ? 0 : 1)
                    Spacer()
                }
            }
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
    private var timerHeader: some View{
        HStack(spacing: 15) {
            Image(systemName: "location.square.fill")
                .imageScale(.large)
                .foregroundColor(.gray)
            CountDownTimerView(timerType: .arrivalTrip, referenceDate: $waitTime)
               Spacer()
        }
    }
    private var destinationLocation: some View{
        LocationCellView(isDestination: true, title: homeVM.trip?.dropoffLocationName ?? "")
            .hLeading()
    }
    
    private var pickupButton: some View{
        PrimaryButtonView(title: "PICK UP", font: .title3.bold()){
            homeVM.pickupPassenger()
        }
        .padding(.horizontal)
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
    
    private var bottomActionButtons: some View{
        HStack{
            Spacer()
            CircleButtonWithTitle(title: "Call", imageName: "phone.fill", action: {})
            Spacer()
            CircleButtonWithTitle(title: "Conflict", imageName: "bolt.shield", action: {})
            
            Spacer()
            CircleButtonWithTitle(title: "Support", imageName: "questionmark.circle", action: {
                //cancel trip
            })
            Spacer()
        }
        .padding(.top)
    }
}
