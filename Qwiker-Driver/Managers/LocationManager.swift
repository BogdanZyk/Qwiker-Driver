//
//  LocationManager.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import CoreLocation
import MapKit
import SwiftUI


enum RegionType: String {
    case pickup
    case dropoff
}

let SPAN = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)

class LocationManager: NSObject, ObservableObject{
    
    static let shared = LocationManager()
    
    var mapView: MKMapView?
    var currentRect: MKMapRect?
    private let locationManager = CLLocationManager()
    @Published var showAlert: Bool = false
    @Published var isAuthorization: Bool = false
    @Published var userLocation: CLLocation?
    @Published var didEnterPickupRegion = false
    @Published var didEnterDropoffRegion = false
    

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = CLLocationDistance(100)
        locationManager.activityType = .automotiveNavigation
        requestStatus()
    }
    
    //MARK: - Request
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        requestStatus()
    }
    
    func requestStatus(){
       switch locationManager.authorizationStatus{
       case .authorizedAlways, .authorizedWhenInUse:
           locationManager.startUpdatingLocation()
           isAuthorization = true
       case .denied, .restricted:
           print("denied", "restricted")
           showAlert = true
       case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
       default:
           break
       }
    }
    
    //MARK: - Map helpers
    
    private func createCustomRegion(withType type: RegionType, coordinates: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: type.rawValue)
        locationManager.startMonitoring(for: region)
    }
    
    func createPickupRegionForTrip(_ trip: RequestedTrip) {
        print("DEBUG: Did create pickup region..")
        createCustomRegion(withType: .pickup, coordinates: trip.pickupLocationCoordiantes)
    }
    
    func createDropoffRegionForTrip(_ trip: RequestedTrip) {
        print("DEBUG: Did create dropoff region..")
        createCustomRegion(withType: .dropoff, coordinates: trip.dropoffLocationCoordinates)
    }
    
    func setUserLocationInMap(){
        mapView?.setUserTrackingMode(.followWithHeading, animated: true)
    }
    
    func setCurrentRectInMap(){
        guard let currentRect = currentRect else {return}
        mapView?.setRegion(MKCoordinateRegion(currentRect), animated: true)
    }
    
    func updateRegion(_ updatedRegion: MKCoordinateRegion?){
        if let region = updatedRegion{
            mapView?.setRegion(region, animated: true)
            print("UPDATE", region)
        }
    }
}


extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        userLocation = location
        print("DEBUG ->", location)
        UserService.updateUserLocation(location: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
    }
    
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert = true
            userLocation = nil
        default:
            showAlert = true
            userLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == RegionType.pickup.rawValue {
            print("DEBUG: Did enter region..")
            didEnterPickupRegion = true
        }
        
        if region.identifier == RegionType.dropoff.rawValue {
            print("DEBUG: Did start montioring destination region \(region)")
            didEnterDropoffRegion = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == RegionType.pickup.rawValue {
            print("DEBUG: Did exit pickup region")
            didEnterPickupRegion = false
        }
        
        if region.identifier == RegionType.dropoff.rawValue {
            didEnterDropoffRegion = false
        }
    }
}




