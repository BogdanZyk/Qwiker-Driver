//
//  OnboardingView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isShowOnboarding") var isShowOnboarding: Bool = true
    @State private var currentStep: OnBoardType = .step1
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentStep) {
                ForEach(OnBoardType.allCases, id: \.self) { type in
                    boardCellView(type)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            pageControlView
            nextButton
        }
        .background(Color.primaryBg)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

extension OnboardingView{
    private func boardCellView(_ type: OnBoardType) -> some View{
        VStack(alignment: .center, spacing: 25){
            Text(type.title)
                .font(.medelRegular(size: 35))
            Text(type.subtitle)
                .font(.poppinsRegular(size: 18))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Image(type.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 20)
                .frame(maxHeight: 400)
        }
    }
    
    private var nextButton: some View{
        
        PrimaryButtonView(title: "Next") {
            withAnimation {
                nextAction()
            }
        }
        .animation(nil, value: UUID().uuidString)
        .padding(.horizontal)
        .padding(.top, 40)
    }
    
    private var pageControlView: some View{
        HStack(spacing: 5) {
            ForEach(OnBoardType.allCases, id: \.self){ type in
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.secondaryGrey)
                    .frame(width: type == currentStep ? 40 : 15, height: 8)
                    .opacity(type == currentStep ? 1 : 0.5)
            }
        }
    }
    
    private func nextAction(){
        switch currentStep{
        case .step1:
            currentStep = .step2
        case .step2:
            currentStep = .step3
        case .step3:
            isShowOnboarding = false
        }
    }
}


extension OnboardingView{
    enum OnBoardType: Int, CaseIterable{
        case step1, step2, step3
        
        var image: String{
            switch self {
            case .step1:
                return "board-1"
            case .step2:
                return "board-2"
            case .step3:
                return "board-3"
            }
        }
        
        var title: String{
            switch self {
            case .step1:
                return "Register Vehicle"
            case .step2:
                return "Upload Documents"
            case .step3:
                return "Earn Money"
            }
        }
        
        var subtitle: String{
            switch self {
            case .step1, .step2, .step3:
              return "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
            }
        }
    }
}
