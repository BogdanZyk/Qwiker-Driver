//
//  DriverRegistrationView.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI

struct DriverRegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authVM: AuthenticationViewModel
    @StateObject var registrationVM = DriverRegistarionViewModel()
    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                title
                progressViewStep
                ScrollView(.vertical, showsIndicators: false) {
                    switch registrationVM.currentStep{
                    case 1:
                        step1
                            .transition(transition)
                    case 2:
                        step2
                            .transition(transition)
                    default:
                        step1
                            .transition(transition)
                    }
                }
            }
            .onAppear{
                registrationVM.phone = authVM.phoneNumber
                registrationVM.email = authVM.email
            }
        }
        .imagePicker(pickerType: registrationVM.sourseType, show: $registrationVM.showPhotoPicker, imagesData: $registrationVM.imagesData, selectionLimit: 1) {registrationVM.setImageDataForType()}
    }
}

struct DriverRegistarionView_Previews: PreviewProvider {
    static var previews: some View {
        DriverRegistrationView()
            .environmentObject(AuthenticationViewModel())
    }
}

//MARK: - Components
extension DriverRegistrationView{
    
    private var title: some View{
        Text("Driver registration")
            .font(.poppinsMedium(size: 25))
            .padding(.leading)
    }
    
    private var progressViewStep: some View{
        VStack(alignment: .leading, spacing: 5) {
            Text("Step \(registrationVM.currentStep)/\(registrationVM.maxStep)")
                .font(.poppinsRegular(size: 14))
            CustomProgressView(height: 5, progress: Double(registrationVM.currentStep), total: Double(registrationVM.maxStep))
                .padding(.bottom, 5)
        }
        .padding(.horizontal)
    }
    
    private var nextButton: some View{
        PrimaryButtonView(showLoader: registrationVM.showLoader, title: registrationVM.currentStep != 2 ? "Next" : "Complete registration") {
            withAnimation(.easeIn(duration: 0.3)) {
                nextAction()
            }
        }
        .padding(.top, 40)
    }
    
    private func nextAction(){
        UIApplication.shared.endEditing()
        if registrationVM.currentStep != 2{
            registrationVM.currentStep += 1
        }else{
            registrationVM.completeRegistration { user in
                authVM.userSession = user
                dismiss()
            }
        }
    }
    
    private var transition: AnyTransition{
        AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity)
    }
}


//MARK: - Steps
extension DriverRegistrationView{
    
    
    private var step1: some View{
        ZStack{
            VStack(alignment: .leading, spacing: 20) {
                Text("Personal information")
                    .font(.poppinsMedium(size: 20))
                    .padding(.top, -16)
                
                TextFieldWhithTitle(title: "Your full name", lebel: "Full name", text: $registrationVM.fullName)
                TextFieldWhithTitle(title: "Your City", lebel: "Full name", text: $registrationVM.fullName)
                photoPickerSection
                nextButton
            }
            .padding()
        }
        .background(Color.primaryBg)
    }
    
    
    private var photoPickerSection: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Upload")
                .font(.poppinsMedium(size: 18))
            Button {
                registrationVM.selectedImageType = .license
                registrationVM.showPhotoPicker = true
            } label: {
                photoPickerLabel("Driving license", subtitle: "A Driving license is an official document", isComplete: registrationVM.licenseImageData != nil)
            }
            Button {
                registrationVM.selectedImageType = .profile
                registrationVM.showPhotoPicker = true
            } label: {
                photoPickerLabel("Profile photo", subtitle: "The profile photo will be visible to passengers", isComplete: registrationVM.profileImageData != nil)
            }
        }
    }
    
    
    private var step2: some View{
        ZStack{
            VStack(alignment: .leading, spacing: 15) {
                Text("Car information")
                    .font(.poppinsMedium(size: 20))
                    .padding(.top, -16)
                TextFieldWhithTitle(title: "Make", lebel: "Enter make..", text: $registrationVM.vehicle.make)
                TextFieldWhithTitle(title: "Model", lebel: "Enter model..", text: $registrationVM.vehicle.model)
                TextFieldWhithTitle(title: "Year", lebel: "Enter year..", text: Binding(
                    get: { registrationVM.vehicle.year },
                    set: { registrationVM.vehicle.year = $0.filter { "0123456789".contains($0)}}))
                .keyboardType(.numberPad)
                TextFieldWhithTitle(title: "Number", lebel: "Enter number..", text: $registrationVM.vehicle.number)
                colorPicker
                Spacer()
                nextButton
            }
            .padding()
        }
        .background(Color.primaryBg)
    }
    
    private var colorPicker: some View{
        VStack(alignment: .leading, spacing: 12) {
            Text("Select color")
                .font(.poppinsMedium(size: 18))
            Picker("", selection: $registrationVM.vehicle.color) {
                ForEach(VehicleColors.allCases) { color in
                    Text(color.description)
                }
            }
            .frame(width: 100, height: 50)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0))
            .labelStyle(.titleOnly)
            .accentColor(.black)
        }
    }
    
}


extension DriverRegistrationView{
    
  
    
    private func photoPickerLabel(_ title: String, subtitle: String, isComplete: Bool) -> some View{
        
        HStack{
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .foregroundColor(.black)
                    .font(.poppinsMedium(size: 18))
                Text(subtitle)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundColor(isComplete ? .green : .gray.opacity(0.5))
        }
        
        .padding()
        .hLeading()
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
    }
}

struct TextFieldWhithTitle: View {
    let title: String
    let lebel: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.poppinsMedium(size: 18))
            PrimaryTextFieldView(label: lebel, text: $text)
        }
    }
}
