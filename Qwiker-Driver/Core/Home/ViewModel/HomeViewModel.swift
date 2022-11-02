//
//  HomeViewModel.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import Foundation
import CoreLocation
import GeoFireUtils
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import SwiftUI
import MapKit



final class HomeViewModel: ObservableObject{
    
    @Published var user: Rider?
    @Published var trip: Trip?
    @Published var mapState = MapViewState.noInput
    private var tripService = TripService()
    private var destinationLocation: AppLocation?
    var routeToPassegers: MKRoute?
    var roteToPicaupLocation: MKRoute?
    
    init(){
        fetchUser()
    }
    
    
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.fetchRiderForId(withUid: uid) {[weak self] user, error in
            guard let self = self else {return}
            if let user = user{
                self.user = user
                self.tripService.user = user
                self.addTripObserverForDriver()
            }
        }
    }
    
}
    

//MARK: - Map helpers

extension HomeViewModel{
    func createPickupAndDropoffRegionsForTrip() {
        guard let trip = trip else { return }
        LocationManager.shared.createPickupRegionForTrip(trip)
        LocationManager.shared.createDropoffRegionForTrip(trip)
    }
}

//MARK: - API
extension HomeViewModel {
    
    
    
    func addTripObserverForDriver() {
        tripService.addTripObserverForDriver { snapshot, error in
            guard let change = snapshot?.documentChanges.first else { return }
            guard let trip = try? change.document.data(as: Trip.self) else { return }
           
            switch change.type {
            case .added, .modified:
                
                guard self.mapState != .tripRequested else {return }
                self.trip = trip
                self.tripService.trip = trip
                print("DEBUG", trip.tripState)
                
                switch trip.tripState{
            
                case .requested:
                    self.mapState = .tripRequested
                case .cancelled:
                    self.mapState = .tripCancelled
                case .complete:
                    break
                case .inProgress:
                    self.mapState = .tripInProgress
                case .accepted:
                    self.mapState = .tripAccepted
                default:
                    break
                }
            
            case .removed:
                self.mapState = .noInput
            }
        }
    }
    
    func acceptTrip() {
        guard let trip = trip else { return }
        self.destinationLocation = AppLocation(title: trip.dropoffLocationName, coordinate: trip.dropoffLocationCoordinates)
        
        tripService.acceptTrip { _ in
            self.createPickupAndDropoffRegionsForTrip()
            self.mapState = .tripAccepted
        }
    }
    
    func rejectTrip() {
        tripService.rejectTrip { _ in
            self.mapState = .noInput
        }
    }
    
    func updateTripStateToArrived() {
        tripService.didArriveAtPickupLocation { _ in
            self.mapState = .driverArrived
        }
    }
    
    func updateTripStateToDropoff() {
        tripService.didArriveAtPickupLocation { _ in
            self.mapState = .arrivedAtDestination
        }
    }
    
    func pickupPassenger() {
        tripService.pickupPassenger { _ in
            self.mapState = .tripInProgress
        }
    }
    
    func dropOffPassenger() {
        tripService.dropoffPassenger { _ in
            self.mapState = .tripCompleted
        }
    }
    
    func updateDriverActiveState(_ isActive: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FbConstant.COLLECTION_DRIVERS.document(uid).updateData(["isActive": isActive]) { _ in
            self.user?.isActive = isActive
        }
    }
    
    func updateDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let geoPoint = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        FbConstant.COLLECTION_DRIVERS.document(uid).updateData(["coordinates": geoPoint])
    }
}
