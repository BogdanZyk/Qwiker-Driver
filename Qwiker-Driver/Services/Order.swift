//
//  Order.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import Firebase
import Foundation


struct OrderService{
    
    
    
    func addSavedTripObserverForDriver(uid: String?, listener: @escaping(FIRQuerySnapshotBlock)) {
        guard let uid = uid else { return }
        FbConstant.COLLECTIONS_USER_TRIPS.whereField("driverUid", isEqualTo: uid).addSnapshotListener(listener)
    }
    
    func getAllSavedTripsForDriver(uid: String?, completion: @escaping([SavedTrip]?, Error?) -> Void) {
        guard let uid = uid else { return }
        FbConstant.COLLECTIONS_USER_TRIPS.whereField("driverUid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error{
                completion(nil, error)
                
            }else{
                guard let documents = snapshot?.documents else { return }
                let orders = documents.compactMap ({
                    try? $0.data(as: SavedTrip.self)
                })
                completion(orders, nil)
            }
            
        }
    }
}
