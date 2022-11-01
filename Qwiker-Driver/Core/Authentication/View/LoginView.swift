//
//  LoginView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @AppStorage("isShowOnboarding") var isShowOnboarding: Bool = true
    var body: some View {
        NavigationView {
            ZStack{

                switch authVM.viewState {
                case .login:
                    signInView
                        .transition(.move(edge: .leading))
                case .signup:
                    EmptyView()
                    createAccoutView
                        .transition(.move(edge: .leading))
                }

                NavigationLink(isActive: $authVM.isShowVerifView) {
                    VerificationView()
                        .environmentObject(authVM)
                        .navigationBarHidden(true)
                } label: {}
                    .labelsHidden()

            }
            .handle(error: $authVM.error)
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $isShowOnboarding) {
            OnboardingView()
                .preferredColorScheme(.light)
        }
        .alert("Authentication Error", isPresented: $authVM.showErrorMessage, actions: {}, message: {Text(authVM.errorMessage)})
    }
}

struct LoginView2_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}

extension LoginView{


    private var createAccoutView: some View{
        VStack(spacing: 20){
            title
            inputSection
            Spacer()
            alredyAccountSection
        }
        .allFrame()
        .background(Color.primaryBg)
    }

    private var signInView: some View{
        VStack(spacing: 20){
            title
            inputSection
            Spacer()
            alredyAccountSection
        }
        .allFrame()
        .background(Color.primaryBg)
    }

    private var inputSection: some View{
        VStack(spacing: 20) {
            if authVM.viewState == .login{
                subtitle
            }else{
                userNameTf
            }
            phoneTf
            validSection
            submitButton
        }
        .padding()
    }

    private var validSection: some View{
        Group{
            if authVM.viewState == .login{
                validText(authVM.validTextPhone)
            }else{
                validText(authVM.validTextPhone)
                validText(authVM.validTextEmail)
            }
        }
    }

    private var title: some View{
        Text(authVM.viewState.title)
            .font(.medelRegular(size: 30))
            .padding(.top, 50)
    }

    private var phoneTf: some View{
        PrimaryTextFieldView(label: "Phone Number", text:  Binding(
            get: { authVM.phoneNumber },
            set: { authVM.phoneNumber = $0.filter { "0123456789".contains($0)}}))
        .keyboardType(.numberPad)
        .textContentType(.telephoneNumber)
        .onChange(of: authVM.phoneNumber) { _ in
            authVM.validTextPhone = ""
        }
    }

    private var userNameTf: some View{
        PrimaryTextFieldView(label: "Your email", text: $authVM.email)
            .onChange(of: authVM.email) { _ in
                authVM.validTextEmail = ""
            }
    }

    private var subtitle: some View{
        Text("Login with your phone number")
            .font(.poppinsRegular(size: 18))
    }

    private func validText(_ text: String) -> some View{
        Text(text)
            .font(.poppinsRegular(size: 16))
            .foregroundColor(.red)
    }

    private var alredyAccountSection: some View{
        HStack {
            Text(authVM.viewState.alredyTitle)
            Button {
                withAnimation {
                    authVM.viewState = (authVM.viewState == .login) ? .signup : .login
                }
            } label: {
                Text(authVM.viewState == .login ? "Sign up" : "Log in")
                    .font(.poppinsMedium(size: 18))
                    .foregroundColor(.primaryBlue)
            }
        }
    }
    private var submitButton: some View{
        PrimaryButtonView(showLoader: authVM.isShowLoader, title: authVM.viewState == .login ? "Send code" : "Sign Up") {
            if authVM.checkIsValidInput(){
                authVM.sendOTP()
            }
        }
    }
}
