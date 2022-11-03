//
//  UserService.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import FirebaseAuth
import Firebase
import FirebaseFirestore
import GeoFireUtils

struct UserService {
    
    
    
    static func updateUserLocation(location: CLLocationCoordinate2D){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let hash = Helpers.getGeoHash(forLocation: location)
        let geoPoint = GeoPoint(latitude: location.latitude,
                                longitude: location.longitude)
        
        FbConstant.COLLECTION_DRIVERS.document(uid).updateData(
            ["geohash" : hash, "coordinates" : geoPoint])
        { error in
            if let error = error{
                print("DEBUG UPDATE USER LOCATION", error.localizedDescription)
            }
        }
    }
    
 
    
    static func fetchRiderForId(withUid uid: String, completion: @escaping(Rider?, Error?) -> Void) {
        
        FbConstant.COLLECTION_DRIVERS.document(uid).getDocument { snapshot, error in
          
            if let error = error{
                completion(nil, error)
            }else{
                let user = try? snapshot?.data(as: Rider.self)
                completion(user, nil)
            }
        }
    }
    
    static func fetchRiderForNumber(withnumber number: String, completion: @escaping(Rider?, Error?) -> Void) {
        FbConstant.COLLECTION_DRIVERS.whereField("phoneNumber", isEqualTo: number)
            .getDocuments { snapshot, error in
            if let error = error{
                completion(nil, error)
            }else{
                let doc = snapshot?.documents.first
                let user = try? doc?.data(as: Rider.self)
                completion(user, nil)
            }
        }
    }
    
    static func createUserModel(withName name: String = "", email: String = "", phone: String) -> Rider? {
        guard let userLocation = LocationManager.shared.userLocation else { return nil }
        
        let user = Rider(
            fullname: name,
            email: email,
            phoneNumber: phone,
            coordinates: GeoPoint(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude), isActive: false)
        return user
    }
    
    static func uploadRiderData(withUid uid: String, user: Rider, completion: @escaping (Error?) -> Void) {
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        
        FbConstant.COLLECTION_DRIVERS.document(uid).setData(encodedUser) { error in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
