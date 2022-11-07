//
//  TripInProgressView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 04.11.2022.
//

import SwiftUI

struct TripInProgressView: View {
    @State private var tripTime: Date = Date()
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        
        ZStack(alignment: .bottom) {
            ExpandedView(minHeight: getRect().height / 5.5, maxHeight: getRect().height / 1.3) { minHeight, rect, offset in
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
            arrivedSlider
        }
    }
}

struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.gray.ignoresSafeArea()
            TripInProgressView()
                .environmentObject(dev.homeViewModel)
        }
    }
}


extension TripInProgressView{
    private var timerHeader: some View{
        HStack(spacing: 15) {
            Image(systemName: "location.square.fill")
                .imageScale(.large)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 0) {
                CountDownTimerView(timerType: .inProgressTrip, referenceDate: $tripTime)
                Text("Trip in progress")
                    .foregroundColor(.gray)
                    .font(.poppinsMedium(size: 14))
            }
               Spacer()
        }
    }
    
    private var destinationLocation: some View{
        Group{
            if let trip = homeVM.trip{
                LocationCellView(isDestination: true, title: trip.dropoffLocationName)
                    .hLeading()
            }
        }
    }
    
   
    
    private var arrivedSlider: some View{
        TripStatusSliderView(title: "Arrived") {
            homeVM.dropOffPassenger()
        }.padding(.horizontal)
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
