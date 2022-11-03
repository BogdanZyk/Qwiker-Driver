//
//  Preview.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//


import SwiftUI
import MapKit
import Firebase

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}
/*
 let driverName: String
 let passengerName: String
 let driverImageUrl: String
 let passengerImageUrl: String?*/

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let mockSelectedLocation = AppLocation(title: "Starbucks", coordinate: CLLocationCoordinate2D(latitude: 37.6, longitude: -122.43))
    
    let mockTrip = RequestedTrip(driverUid: NSUUID().uuidString,
                        passengerUid: NSUUID().uuidString,
                        pickupLocation: GeoPoint(latitude: 37.6, longitude: -122.43),
                        dropoffLocation: GeoPoint(latitude: 37.55, longitude: -122.4),
                        driverLocation: GeoPoint(latitude: 37.4, longitude: -122.1),
                        dropoffLocationName: "Starbucks",
                        pickupLocationName: "Apple Campus",
                        pickupLocationAddress: "123 Main st",
                        tripCost: 40.00,
                        tripState: .inProgress,
                        driverName: "John Smith",
                        passengerName: "Stephan Dowless",
                        driverImageUrl: "https://firebasestorage.googleapis.com/v0/b/weego-f90c2.appspot.com/o/istockphoto-1138008134-170667a.jpeg?alt=media&token=a14a83e2-ae0c-43a0-8682-9ae866136111",
                        passengerImageUrl: "",
                        carModel: "Volkswagen",
                        carNumber: "HG5045",
                        carColor: "White")
    

    
//    let rideDetails = RideDetails(startLocation: "Current Location",
//                                  endLocation: "123 Main St",
//                                  userLocation: CLLocation(latitude: 37.75, longitude: -122.432))
    


    
    var homeViewModel: HomeViewModel {
        let vm = HomeViewModel()
        vm.trip = mockTrip
        //vm.selectedLocation = mockSelectedLocation
        return vm
    }
}
