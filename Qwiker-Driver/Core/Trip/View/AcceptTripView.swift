//
//  AcceptTripView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct AcceptTripView: View {
    let maxSecForAccept = 20.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var secForAccept: Double = 20.0
    @StateObject var acceptViewModel = AcceptTripViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack(spacing: 0) {
            rejectTripButton
            Spacer()
            BottomSheetView(spacing: 15, maxHeightForBounds: 3) {
                tripTimeAndDistanceInfo
                driverBonusSectionView
                locationSection
                Spacer()
                acceptButtonView
            }
        }
        .onAppear{
            acceptViewModel.trip = homeVM.trip
            acceptViewModel.setDropOffTime()
        }
        .onReceive(timer) { _ in
            if secForAccept != 0{
                withAnimation {
                    secForAccept -= 1.0
                }
            }else{
                homeVM.rejectTrip()
            }
        }
    }
}

struct AcceptTripView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.gray.ignoresSafeArea()
            AcceptTripView()
        }
        .environmentObject(dev.homeViewModel)
    }
}

extension AcceptTripView{
    private var tripTimeAndDistanceInfo: some View{
        VStack{
            HStack(spacing: 0){
                Text(acceptViewModel.getDestinationInKm())
                Text("・")
                Text(acceptViewModel.dropOffTime)
            }
            .font(.title3.bold())
            Divider().padding(.horizontal, -16)
        }
        .withoutAnimation()
    }
    
    private var driverBonusSectionView: some View{
        VStack(spacing: 15) {
            HStack(spacing: 30){
                driverBonusInfoView(isPriceMode: false, value: "1")
                Divider()
                    .frame(width: 5, height: 50)
                driverBonusInfoView(isPriceMode: true, value: "5$")
            }
            Divider().padding(.horizontal, -16)
        }
    }
    
    private var locationSection: some View{
        LocationRowsViewComponent(pickupLocationAddress: homeVM.trip?.pickupLocationAddress ?? "", dropoffLocationName: homeVM.trip?.dropoffLocationName ?? "")
    }
}


extension AcceptTripView{
    private func driverBonusInfoView(isPriceMode: Bool, value: String) -> some View{
        HStack(spacing: 15){
            Image(systemName: isPriceMode ? "bolt.fill" : "seal.fill")
                .imageScale(.large)
                .foregroundColor(isPriceMode ? .green : .primaryBlue)
            VStack(alignment: .leading){
                Text(isPriceMode ? "Price" : "Active")
                    .font(.poppinsMedium(size: 18))
                    .foregroundColor(.gray)
                Text("+\(value)")
                    .font(.headline.weight(.heavy))
                    .foregroundColor(isPriceMode ? .green : .primaryBlue)
            }
        }
    }

    private var acceptButtonView: some View{
        Button {
            homeVM.acceptTrip()
        } label: {
            Text("Accept")
                .foregroundColor(.white)
                .font(.title3.bold())
                .hCenter()
                .background{
                    CustomProgressView(bgColor: .gray, progressColor: .primaryBlue, height: 50, progress: secForAccept, total: maxSecForAccept)
                }
            
        }
    }
    
    private var rejectTripButton: some View{
        Button {
            homeVM.rejectTrip()
        } label: {
            VStack{
                Text("Reject")
                    .font(.poppinsMedium(size: 20))
                    .foregroundColor(.black)
                Text("Active -1")
                    .foregroundColor(.primaryBlue)
                    .font(.poppinsRegular(size: 12))
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background{
                Capsule()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
            }
        }
        .padding()
    }
}

