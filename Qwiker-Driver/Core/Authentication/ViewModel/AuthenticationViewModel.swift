//
//  AuthenticationViewModel.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import FirebaseAuth
import Foundation
import GeoFireUtils
import FirebaseFirestore

final class AuthenticationViewModel: ObservableObject {
    
    @Published var viewState: LoginViewState = .login
    @Published var userSession: FirebaseAuth.User?
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    @Published var validTextPhone: String = ""
    @Published var validTextEmail: String = ""
    @Published var error: Error?
    @Published var errorMessage: String = ""
    @Published var showErrorMessage: Bool = false
    @Published var verificationCode: String = ""
    
    @Published var isShowLoader: Bool = false
    
    @Published var isShowVerifView: Bool = false
    @Published var isShowDriverRegistrationView: Bool = false
    
    init(){
       userSession = Auth.auth().currentUser
    }
    
  
    
   // MARK: - Sing in with OTR
    
    func singInWithOTR() {
        if isShowLoader {return}
        isShowLoader = true
        let code = otpFields.joined(separator: "")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: code)
        Auth.auth().signIn(with: credential) {[weak self] result, error in
            guard let self = self else {return}
            self.isShowLoader = false
            if let error = error {
                self.error = error
                return
            }
            if self.viewState == .login{
                self.userSession = result?.user
            }else{
                self.isShowDriverRegistrationView = true
            }
        }
    }
    
    
    // MARK: - Send OTP for user phone number

    func sendOTP() {
        self.isShowLoader = true
        let number = phoneNumber.formattingPhone()
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        checkIsAlredyAuthUser(number: number) { isNotAlredyExist in
            self.isShowLoader = false
            if isNotAlredyExist{
                PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) {[weak self] result, error in
                    guard let self = self else {return}
                    if let error = error{
                        self.error = error
                        return
                    }
                    if let verificationCode = result{
                        DispatchQueue.main.async {
                            self.verificationCode = verificationCode
                            self.isShowVerifView = true
                        }
                    }
                }
            }
        }
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.email = ""
            self.phoneNumber = ""
            self.otpText = ""
        } catch let error {
            self.error = error
        }
    }
    
    func fetchUser(completion: @escaping (Rider?) -> Void) {
        guard let uid = userSession?.uid else { return }
        UserService.fetchRiderForId(withUid: uid) { user, error in
            if let error = error{
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            completion(user)
        }
    }

//    private func setUser(){
//        fetchUser {[weak self] user in
//            guard let self = self else {return}
//            self.user = user
//        }
//    }

    func requestCode(){
        sendOTP()
    }
    
    
    private func checkIsAlredyAuthUser(number: String, completion: @escaping (Bool) -> Void){
        UserService.fetchRiderForNumber(withnumber: number) {[weak self] user, error in
            guard let self = self else {return}
            switch self.viewState {
            case .login:
                if user == nil{
                    self.errorMessage = "The user with this phone number is not registered"
                    self.showErrorMessage.toggle()
                    completion(false)
                    return
                }
            case .signup:
                if let _ = user {
                    self.errorMessage = "A user with this number already exists"
                    self.showErrorMessage.toggle()
                    completion(false)
                    return
                }
            }
            completion(true)
        }
    }
    
    
    func checkIsValidInput() -> Bool{

        let isValidPhone = phoneNumber.isValidPhone
        let isValidEmail = email.isEmail
        validTextPhone = isValidPhone ? "" : "Incorrect telephone number"
        validTextEmail = email.isEmail ? "" : "Enter a valid email"
        return viewState == .login ? isValidPhone : (isValidEmail && isValidPhone)
    }
}


enum LoginViewState: Int{
    case login, signup
    
    var title: String{
        switch self {
        case .login:
            return "Log in"
        case .signup:
           return "Sign Up"
        }
    }
    var alredyTitle: String{
        switch self {
        case .login:
            return "Don’t have an account?"
        case .signup:
           return "Already have an account?"
        }
    }
}
