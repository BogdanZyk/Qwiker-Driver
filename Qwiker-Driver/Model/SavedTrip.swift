//
//  SavedTrip.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import CoreLocation


struct SavedTrip: Codable, Identifiable{
    @DocumentID var id: String?
    let driverUid: String
    let passengerUid: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let tripCost: Double
    let tripState: TripState
    let driverName: String
    let passengerName: String
    let driverImageUrl: String
    let carModel: String?
    let carNumber: String?
    let carColor: String?
    var tripDate: Timestamp = Timestamp()
    
    var tripId: String { return id ?? "" }
    
    var dropoffLocationCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: dropoffLocation.latitude, longitude: dropoffLocation.longitude)
    }
    
    var pickupLocationCoordiantes: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
    }
    
    var tripDateStr: String{
        tripDate.dateValue().formatted(date: .long, time: .shortened)
    }
    
    
    init(requestedTrip: RequestedTrip){
        self.id = requestedTrip.id
        self.driverUid = requestedTrip.driverUid
        self.passengerUid = requestedTrip.passengerUid
        self.pickupLocation = requestedTrip.pickupLocation
        self.dropoffLocation = requestedTrip.dropoffLocation
        self.dropoffLocationName = requestedTrip.dropoffLocationName
        self.pickupLocationAddress = requestedTrip.pickupLocationAddress
        self.tripCost = requestedTrip.tripCost
        self.tripState = requestedTrip.tripState
        self.driverName = requestedTrip.driverName
        self.passengerName = requestedTrip.passengerName
        self.driverImageUrl = requestedTrip.driverImageUrl
        self.carModel = requestedTrip.carModel
        self.carNumber = requestedTrip.carNumber
        self.carColor = requestedTrip.carColor
    }
}
