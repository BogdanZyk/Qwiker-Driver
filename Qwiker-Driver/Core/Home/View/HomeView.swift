//
//  HomeView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var homeVM = HomeViewModel()
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom){
                MapViewRepresentable()
                    .ignoresSafeArea()
                viewForState
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
            }
        }
        .environmentObject(homeVM)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthenticationViewModel())
    }
}

extension HomeView{
    @ViewBuilder var viewForState: some View {
        switch homeVM.mapState {
        case .tripRequested:
            AnyView(AcceptTripView())
        case .tripAccepted:
            AnyView(EmptyView())
        case .tripCancelled:
            AnyView(CancelledView())
        case .driverArrived:
            AnyView(EmptyView())
        case .tripInProgress:
            AnyView(EmptyView())
            //return AnyView(TripInProgressView())
        case .arrivedAtDestination:
            AnyView(EmptyView())
            //return AnyView(TripArrivalView(user: user))
        case .locationSelected:
            AnyView(EmptyView())
        default:
            AnyView(EmptyView())
        }
    }
}
