//
//  AcceptTripViewModel.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import Foundation
import Combine
import MapKit

final class AcceptTripViewModel: ObservableObject{
    
   
    var trip: Trip?
    
    @Published var dropOffTime: String = ""


        
    
    
    
    func getDestinationInKm() -> String{
        guard let trip = trip else {return ""}
        let meters = MapHelpers.getDistanceInMeters(from: .init(latitude: trip.pickupLocation.latitude, longitude: trip.pickupLocation.longitude), to: .init(latitude: trip.dropoffLocation.latitude, longitude: trip.dropoffLocation.longitude))
        let distanceInKm = (meters / 1000).rounded(.up)
        
        return "\(distanceInKm)km"
    }
    
    
    func setDropOffTime(){
        guard let trip = trip else {return}
        MapHelpers.getDestinationRoute(from: .init(latitude: trip.pickupLocation.latitude, longitude: trip.pickupLocation.longitude), to: .init(latitude: trip.dropoffLocation.latitude, longitude: trip.dropoffLocation.longitude)) {[weak self] route in
            guard let self = self else {return}
            self.dropOffTime = route.expectedTravelTime.stringTimeInMinutes
        }
    }
    
}




