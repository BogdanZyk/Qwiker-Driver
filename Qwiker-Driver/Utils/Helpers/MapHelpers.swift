//
//  MapHelpers.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//
import Foundation
import MapKit

final class MapHelpers{
    
    
    static func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                    to destinationCoordinate: CLLocationCoordinate2D,
                                    completion: @escaping(MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to generate polyline with error \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else { return }
            completion(route)
        }
    }
    
    static func getDistanceInMeters(from currentLocation: CLLocation, to destanationLocation: CLLocation) -> Double{
        return currentLocation.distance(from: destanationLocation)
    }
    
}
