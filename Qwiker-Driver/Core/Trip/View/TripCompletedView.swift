//
//  TripCompletedView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 04.11.2022.
//

import SwiftUI

struct TripCompletedView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack(spacing: 30){
            title
            total
            paymentMethod
            detailsButton
            closeButton
            Spacer()
        }
        .padding()
        .background(Color.primaryBg)
        .preferredColorScheme(.light)
    }
}

struct TripCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        TripCompletedView()
            .environmentObject(dev.homeViewModel)
    }
}


extension TripCompletedView{
    
    private var title: some View{
        Text("The trip is complete!")
            .font(.title2.weight(.bold))
    }
    private var total: some View{
        Text(homeVM.trip?.tripCost.toCurrency() ?? "")
            .font(.title.bold())
    }
    
    private var paymentMethod: some View{
        Text("Non-cash payment")
            .font(.poppinsMedium(size: 18))
            .hLeading()
    }
    
    private var detailsButton: some View{
        Button {
            
        } label: {
            HStack{
                Image(systemName: "exclamationmark.circle")
                Text("Details")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.poppinsRegular(size: 20))
            .foregroundColor(.black)
        }
    }
    private var closeButton: some View{
        PrimaryButtonView(title: "Close") {
            homeVM.deleteTrip()
            homeVM.isShowCompleteTrip.toggle()
        }
        .padding(.top, 30)
    }
}
