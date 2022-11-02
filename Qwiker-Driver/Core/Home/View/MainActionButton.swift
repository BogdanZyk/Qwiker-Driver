//
//  MainActionButton.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

struct MainHomeActionButton: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Binding var showSideMenu: Bool
    var body: some View {
        Button {
            withAnimation(.easeInOut){
                actionForState()
            }
        } label: {
            Image(systemName: "line.3.horizontal")
                .font(.title3.weight(.medium))
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.2), radius: 6)
        }
        .hLeading()
    }
}

struct MainHomeActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainHomeActionButton(showSideMenu: .constant(true))
        }
        .padding()
        .environmentObject(dev.homeViewModel)
    }
}

extension MainHomeActionButton{
    private func actionForState(){
        switch homeVM.mapState {
        case .noInput:
            showSideMenu.toggle()
        default: break
        }
    }
    
//    private var iconName: String{
//        switch homeVM.mapState{
//        case .searchingForLocation,
//                .locationSelected,
//                .tripAccepted,
//                .tripRequested,
//                .tripCompleted,
//                .polylineAdded:
//            return "chevron.left"
//        case .noInput, .tripCancelled:
//            return "line.3.horizontal"
//        default:
//            return "line.3.horizontal"
//        }
//    }
}
