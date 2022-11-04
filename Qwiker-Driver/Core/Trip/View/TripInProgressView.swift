//
//  TripInProgressView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 04.11.2022.
//

import SwiftUI

struct TripInProgressView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        BottomSheetView(spacing: 10, maxHeightForBounds: 6) {
            locationView
            Divider()
            detailsButon
            Spacer()
            arrivedButton
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
   private var title: some View{
        Text("On the way")
            .font(.poppinsMedium(size: 20))
    }
    
    private var locationView: some View{
        Group{
            if let trip = homeVM.trip{
                LocationCellView(isDestination: true, title: trip.dropoffLocationName)
                    .hLeading()
            }
        }
    }
    
    private var detailsButon: some View{
        HStack {
            Text("Details")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .font(.poppinsMedium(size: 16))
    }
    
    private var arrivedButton: some View{
        PrimaryButtonView(showLoader: false, title: "Arrived", font: .title3.bold()) {
            homeVM.dropOffPassenger()
        }
    }
}
