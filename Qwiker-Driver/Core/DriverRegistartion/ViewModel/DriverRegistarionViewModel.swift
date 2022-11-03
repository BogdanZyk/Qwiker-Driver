//
//  DriverRegistarionViewModel.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import FirebaseAuth
import Foundation
import GeoFireUtils
import FirebaseFirestore


final class DriverRegistarionViewModel: ObservableObject{
    
    
    let maxStep = 2
    var phone = ""
    var email = ""
    @Published var userSession: FirebaseAuth.User?
    @Published var currentStep: Int = 1
    @Published var fullName: String = ""
    @Published var city: String = ""
    @Published var showPhotoPicker: Bool = false
    @Published var vehicle: Vehicle = .init(make: "", model: "", year: "", color: VehicleColors.gray, licensePlateNumber: "", type: .bisness, number: "")
    @Published var selectedImageType: ImageType = .profile
    @Published var imagesData: [UIImageData]? = []
    @Published var sourseType: ImagePickerType = .photoLib
    @Published var showLoader: Bool = false
    @Published var profileImageData: UIImageData?
    @Published var licenseImageData: UIImageData?
    @Published var error: Error?

    
    init(){
        userSession = Auth.auth().currentUser
    }
    
    
    func setImageDataForType(){
        guard let image = imagesData?.first else {return}
        switch selectedImageType {
        case .profile:
            profileImageData = image
        case .license:
            licenseImageData = image
        }
        imagesData = []
    }
    
    
    func completeRegistration(completion: @escaping (User?) -> Void){
        guard let image = profileImageData?.image, let location = LocationManager.shared.userLocation, let userSession = userSession else { return }
        showLoader = true
        ImageUploader.uploadImage(withImage: image) { [weak self] url in
            guard let self = self else {return}
            let hash = Helpers.getGeoHash(forLocation: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            let user: Rider = .init(fullname: self.fullName, email: self.email, phoneNumber: self.phone, profileImageUrl: url, coordinates: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), geohash: hash, vehicle: self.vehicle, isActive: false)
            UserService.uploadRiderData(withUid: userSession.uid, user: user) { error in
                self.showLoader = false
                if let error = error {
                    self.error = error
                    return
                }
                completion(userSession)
            }
        }
    }
}


enum ImageType {
    case profile, license
}
