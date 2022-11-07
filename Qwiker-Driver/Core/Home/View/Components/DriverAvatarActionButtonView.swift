//
//  DriverAvatarActionButtonView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct DriverAvatarActionButtonView: View {
    @Binding var showSideMenu: Bool
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        
        Button {
            withAnimation(.easeInOut){
                showSideMenu.toggle()
            }
        } label: {
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    Text("0.0$")
                        .font(.poppinsMedium(size: 16))
                    Text("0 orders")
                        .font(.poppinsRegular(size: 14))
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
}

struct DriverAvatarActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DriverAvatarActionButtonView(showSideMenu: .constant(true))
            .environmentObject(dev.homeViewModel)
    }
}
