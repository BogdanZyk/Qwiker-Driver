//
//  SideMenuView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import SwiftUI

import SwiftUI

struct SideMenuView: View {
    @Environment(\.dismiss) var dismiss
    @State private var largeHeader: Bool = true
    @State private var showDriverRegistrationView = false
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var navigationTipe: SideMenuOptionViewType?
    var body: some View {
        VStack(spacing: 0) {
            headerView
            ScrollView(.vertical, showsIndicators: false) {
                driverRetingSectionView
                daylyTotalView
                CustomDivider(verticalPadding: 0, lineHeight: 10).padding(.horizontal, -16)
                listOptionsView
                .background(
                    GeometryReader { geometryProxy -> Color in
                        DispatchQueue.main.async{
                            withAnimation {
                                largeHeader = geometryProxy.frame(in: .named("HEADER")).minY >= -10
                            }
                        }
                        return Color.clear
                    })
            }
            .coordinateSpace(name: "HEADER")
        }
        
        .background(Color.primaryBg)
        .navigationBarHidden(true)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SideMenuView()
                .environmentObject(OrderViewModel())
                .environmentObject(dev.homeViewModel)
                .environmentObject(AuthenticationViewModel())
        }
    }
}


// MARK: Header section
extension SideMenuView{
    private var headerView: some View{
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.medium))
                }
                Spacer()
                VStack(spacing: 5) {
                    UserAvatarViewComponent(pathImage: homeVM.user?.profileImageUrl, size: .init(width: largeHeader ? 70 : 50, height: largeHeader ? 70 : 50))
                    if largeHeader{
                        Text(homeVM.user?.fullname ?? "")
                            .font(.poppinsMedium(size: 18))
                            .transition(.opacity)
                    }
                        
                }.padding(.top, -20)
                Spacer()
                NavigationLink {
                    Text("SETTINGS")
                } label: {
                    Image(systemName: "gear")
                        .font(.title3.weight(.medium))
                }
            }
            
        }
        .padding()
        .foregroundColor(.black)
        .background(Color.primaryBg.ignoresSafeArea().shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0))
    }

    
    private var driverRetingSectionView: some View{
        HStack{
            infoSectionViewCell(title: "Activity", value: "83")
            infoSectionViewCell(title: "Rating", value: "4.989")
        }
        .padding(.vertical)
    }
    
    private func infoSectionViewCell(title: String, value: String) -> some View{
        VStack(spacing: 5){
            Text(title)
                .font(.poppinsMedium(size: 18))
            Text(value)
                .font(.poppinsRegular(size: 16))
        }
        .padding()
        .frame(width: 150)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
        }
    }
    
}


//MARK: - Dayly total section
extension SideMenuView{
    private var daylyTotalView: some View{
        VStack(spacing: 10) {
            Text("Today \(Date().formatted(date: .abbreviated, time: .omitted))")
                .font(.poppinsMedium(size: 20))
            Text(orderVM.totalCoast.toCurrency())
                .font(.title.bold())
        }
    }
}


// MARK: List side menu section
extension SideMenuView{
    private var listOptionsView: some View{
        VStack(alignment: .leading, spacing: 5){
            ForEach(SideMenuOptionViewType.allCases, id: \.self) { option in
                Button {
                    navigationTipe = option
                } label: {
                    SideMenuOptionView(optionType: option)
                }
                Divider()
            }
            
            PrimaryButtonView(title: "Log out", bgColor: .secondaryGrey.opacity(0.3), fontColor: .secondaryGrey) {
                authViewModel.signOut()
            }
            .padding(.vertical, 20)
        }
        .padding(.horizontal)
        
    }
    private var navigationLinks: some View{
        NavigationLink(tag: navigationTipe ?? .support, selection: $navigationTipe) {
            switch navigationTipe{
            case .wallet:
                Text("Wallet")
            case .trips:
                Text("MyTripsView")
            case .support:
                Text("Support")
            default:
                EmptyView()
            }
        }label: {}
            .labelsHidden()
    }
}

