//
//  HomeView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct HomeView: View {
    @State private var showDriverActivateSheet: Bool = false
    @State private var showSideMenu: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var homeVM = HomeViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top){
                MapViewRepresentable()
                    .ignoresSafeArea()
                mainHomeButton
            }
            activateOrderButton
            sideMenuView
            driverActivateView
            viewForState
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                .onReceive(LocationManager.shared.$userLocation) { location in
                    homeVM.userLocation = location?.coordinate
                }
        }
        .environmentObject(homeVM)
        .sheet(isPresented: $homeVM.isShowCompleteTrip, onDismiss: homeVM.deleteTrip) {
            TripCompletedView()
                .environmentObject(homeVM)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthenticationViewModel())
    }
}


//MARK: - Side Menu

extension HomeView{
    private var sideMenuView: some View{
        Group{
            if showSideMenu {
                Color.gray.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()){
                            showSideMenu.toggle()
                        }
                    }
            }
            SideMenuView(isShowing: $showSideMenu)
                .frame(width: getRect().width - 50, alignment: .leading)
                .hLeading()
                .offset(x: showSideMenu ? 0 : -getRect().width)
        }
    }
}

extension HomeView{
    
    private var mainHomeButton: some View{
        VStack {
            HStack(alignment: .top){
                if homeVM.mapState == .noInput{
                    DriverStatusButtonView(showDriverActivateSheet: $showDriverActivateSheet)
                    Spacer()
                    DriverAvatarActionButtonView(showSideMenu: $showSideMenu)
                        .animation(nil, value: UUID().uuidString)
                }
            }
            .padding(.horizontal)
            focusCurrentLocationButton
        }
    }
    private var driverActivateView: some View{
        Group{
            if showDriverActivateSheet{
                DriverActiveSheetView(showDriverActivateSheet: $showDriverActivateSheet)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
            }
        }
    }
    
    private var activateOrderButton: some View{
        Group {
            if let driver = homeVM.user, !(driver.isActive){
                DriverActivateButtonView()
                    .padding(.bottom, 20)
            }
        }
    }
    
    private var focusCurrentLocationButton: some View{
        Button {
            LocationManager.shared.setUserLocationInMap()
        } label: {
            Image(systemName: "location.fill")
                .imageScale(.medium)
                .foregroundColor(.primaryBlue)
                .padding(10)
                .background{
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
                }
        }
        .padding()
        .hTrailing()
    }
    
    @ViewBuilder var viewForState: some View {
        switch homeVM.mapState {
        case .tripRequested:
            AnyView(AcceptTripView())
        case .tripAccepted:
            AnyView(EnRouteToPickupLocationView())
        case .tripCancelled:
            AnyView(CancelledView())
        case .driverArrived:
            AnyView(PickupPassengerView())
        case .tripInProgress:
            AnyView(TripInProgressView())
        default:
            AnyView(EmptyView())
        }
    }
}
