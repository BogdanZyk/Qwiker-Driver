//
//  DriverAvatarActionButtonView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct DriverAvatarActionButtonView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    var body: some View {
        
        HStack{
            VStack(alignment: .leading, spacing: 0){
                Text(orderVM.totalCoast.toCurrency())
                    .font(.poppinsMedium(size: 16))
                Text("\(orderVM.orders.count) orders")
                    .font(.poppinsRegular(size: 14))
            }
            .opacity(orderVM.showLoader ? 0 : 1)
            .overlay{
                if orderVM.showLoader{
                    ProgressView()
                }
            }
            UserAvatarViewComponent(pathImage: homeVM.user?.profileImageUrl, size: .init(width: 55, height: 55))
                .padding(2)
        }
        .padding(.leading)
        .foregroundColor(.black)
        .background{
            Capsule()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
    }
}

struct DriverAvatarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DriverAvatarActionButtonView()
            .environmentObject(dev.homeViewModel)
            .environmentObject(OrderViewModel())
    }
}
