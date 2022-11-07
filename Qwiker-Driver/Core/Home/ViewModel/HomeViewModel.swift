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
    @Published var trip: RequestedTrip?
    @Published var mapState = MapViewState.noInput
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var isShowCompleteTrip: Bool = false
    private var tripService = TripService()
    private var destinationLocation: AppLocation?
    var currentRoute: MKRoute?
    
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
    
    func reset(){
        self.mapState = .noInput
        trip = nil
        destinationLocation = nil
        currentRoute = nil
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
            guard let trip = try? change.document.data(as: RequestedTrip.self) else { return }
            guard self.mapState != .tripRequested else { return }
            
            switch change.type {
            case .added, .modified:
                self.trip = trip
                self.tripService.trip = trip
                print("DEBUG", trip.tripState)
                withAnimation {
                    self.updateViewforState(trip.tripState)
                }
            case .removed:
                self.mapState = .noInput
            }
        }
    }
    
    private func updateViewforState(_ tripState: TripState){
        switch tripState{
        case .requested:
            self.mapState = .tripRequested
        case .cancelled:
            self.mapState = .tripCancelled
        case .complete:
            self.isShowCompleteTrip.toggle()
            self.saveCompletedTrip()
        case .inProgress:
            self.mapState = .tripInProgress
        case .accepted:
            self.mapState = .tripAccepted
        default:
            break
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
        tripService.didArriveAtDropffLocation{ _ in
            self.mapState = .arrivedAtDestination
        }
    }
    
    func pickupPassenger() {
        tripService.pickupPassenger { _ in
            self.mapState = .tripInProgress
        }
    }
    
    func dropOffPassenger() {
        tripService.dropoffPassenger { _ in}
    }
    
    func deleteTrip(){
        tripService.deleteTrip { _ in
            self.reset()
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
    
    func saveCompletedTrip() {
        guard let trip = trip else { return }
        guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
        FbConstant.COLLECTIONS_USER_TRIPS
            .document(trip.tripId)
            .setData(encodedTrip) { _ in}
    }
}
