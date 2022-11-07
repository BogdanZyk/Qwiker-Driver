//
//  DriverActiveSheetView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import SwiftUI

struct DriverActiveSheetView: View {
    @Binding var showDriverActivateSheet: Bool
    @EnvironmentObject var homeVM: HomeViewModel
    var isActive: Bool {
        homeVM.user?.isActive ?? false
    }
    var body: some View {
        BottomSheetView(maxHeightForBounds: 3) {
            title
            priority
            activeUnActiveButton
        }
        .onTapGesture {
            showDriverActivateSheet.toggle()
        }
    }
}

struct DriverActiveSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            Color.gray.ignoresSafeArea()
            DriverActiveSheetView(showDriverActivateSheet: .constant(false))
        }
        .environmentObject(dev.homeViewModel)
    }
}


extension DriverActiveSheetView{
    private var title: some View{
        Text("You are now \(isActive ? "active" : "busy")")
            .font(.title.weight(.medium))
    }
    private var priority: some View{
        VStack(spacing: 15){
            Text("+5")
                .font(.title3)
                .padding()
                .background(Color.primaryGreen, in: Circle())
            Text("Higher priority")
                .font(.title3.weight(.medium))
            Text("The higher the priority, the less time it takes to find an order")
                .font(.poppinsRegular(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var activeUnActiveButton: some View{
        PrimaryButtonView(showLoader: false, title: isActive ? "Busy" : "Active", bgColor: isActive ? .gray.opacity(0.8) : .primaryBlue, fontColor: .white) {
            homeVM.updateDriverActiveState(!isActive){
                withAnimation(.easeInOut){
                    showDriverActivateSheet.toggle()
                }
            }
        }
        .padding(.top)
    }
}
