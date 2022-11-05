//
//  User.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import Firebase
import GeoFire

struct Rider: Codable {
    @DocumentID var id: String?
    let fullname: String
    let email: String
    var phoneNumber: String
    var profileImageUrl: String?
    var coordinates: GeoPoint
    var course: Double
    var geohash: String?
    var vehicle: Vehicle?
    var isActive: Bool

    var uid: String { return id ?? "" }
}

