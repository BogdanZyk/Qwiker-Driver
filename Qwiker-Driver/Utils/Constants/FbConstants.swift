//
//  FbConstants.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import Firebase

final class FbConstant{
    
    static let COLLECTION_DRIVERS = Firestore.firestore().collection("drivers")
    static let COLLECTION_USERS = Firestore.firestore().collection("users")
    static let COLLECTION_RIDES = Firestore.firestore().collection("requested_trips")
    static let COLLECTIONS_USER_TRIPS = Firestore.firestore().collection("user-trips")
}
