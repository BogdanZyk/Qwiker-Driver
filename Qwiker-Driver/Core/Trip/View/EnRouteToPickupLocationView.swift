//
//  EnRouteToPickupLocationView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct EnRouteToPickupLocationView: View {
    @State private var expectedTravelTime: Date = Date()
    @State private var isActiveBtn: Bool = false
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ExpandedView(minHeight: getRect().height / 5.5, maxHeight: getRect().height / 1.3) { minHeight, rect, offset in
                
                BottomSheetView(spacing: 15, maxHeightForBounds: 1, isDragIcon: true) {
                    timerSection
                    Group{
                        Divider().padding(.horizontal, -16)
                        locationSection
                        CustomDivider(verticalPadding: 0, lineHeight: 10).padding(.horizontal, -16)
                        paymentMethod
                        Divider().padding(.horizontal, -16)
                        actionButtons
                    }
                    .opacity(offset.wrappedValue > -10 ? 0 : 1)
                    Spacer()
                }
            }
            arrivedSlider
        }
        .onReceive(LocationManager.shared.$didEnterPickupRegion, perform: { didEnterPickupRegion in
            isActiveBtn = didEnterPickupRegion
        })
        .onAppear{
            expectedTravelTime = Date() + (homeVM.currentRoute?.expectedTravelTime ?? 600)
        }
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
    
    @ViewBuilder
    private var locationSection: some View{
        if let pickupLocationAddress = homeVM.trip?.pickupLocationAddress, let dropoffLocationName = homeVM.trip?.dropoffLocationName{
            LocationRowsViewComponent(pickupLocationAddress: pickupLocationAddress, dropoffLocationName: dropoffLocationName)
                .padding(.bottom, 10)
        }
    }
    
    private var arrivedSlider: some View{
        TripStatusSliderView(title: "Arrived") {
            homeVM.updateTripStateToArrived()
        }.padding(.horizontal)
        //            .opacity(isActiveBtn ? 1 : 0.5)
        //            .disabled(!isActiveBtn)
    }
    
    private var timerSection: some View{
        HStack(spacing: 15) {
            Image(systemName: "location.square.fill")
                .imageScale(.large)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 0){
                CountDownTimerView(timerType: .enRouteToPicup, referenceDate: $expectedTravelTime)
                Text("Time before pick-up")
                    .font(.poppinsMedium(size: 14))
                    .foregroundColor(.gray)
                
            }
            Spacer()
        }
    }


    private var paymentMethod: some View{
        Text("Non-cash payment")
            .font(.poppinsMedium(size: 18))
            .hLeading()
    }
    
    private var actionButtons: some View{
        HStack{
            Spacer()
            CircleButtonWithTitle(title: "Call", imageName: "phone.fill", action: {})
            Spacer()
            CircleButtonWithTitle(title: "Cancel order", imageName: "xmark", action: {
                //cancel trip
            })
            Spacer()
            CircleButtonWithTitle(title: "Conflict", imageName: "bolt.shield", action: {})
            Spacer()
        }
        .padding(.top)
    }

}

struct CustomDivider: View{
    var verticalPadding: CGFloat = -10
    var lineHeight: CGFloat = 6
    var body: some View{
        Rectangle()
            .fill(Color.gray.opacity(0.1))
            .frame(height: lineHeight)
            .padding(.vertical, verticalPadding)
    }
}
