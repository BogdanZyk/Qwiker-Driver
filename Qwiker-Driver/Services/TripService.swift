//
//  TripService.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//


import Firebase
import Foundation

typealias FirestoreCompletion = (((Error?) -> Void)?)

struct TripService {
    
    // MARK: - Properties
    
    var trip: Trip?
    var user: Rider?
    
    // MARK: - Helpers
    
   func updateTripState(_ trip: Trip, state: TripState, completion: FirestoreCompletion) {
       FbConstant.COLLECTION_RIDES.document(trip.tripId).updateData(["tripState": state.rawValue], completion: completion)
    }
    
    func deleteTrip(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        FbConstant.COLLECTION_RIDES.document(trip.tripId).delete(completion: completion)
    }
}


// MARK: - Driver API
extension TripService {

    func addTripObserverForDriver(listener: @escaping(FIRQuerySnapshotBlock)) {
        guard let user = user, let uid = user.id else { return }
        FbConstant.COLLECTION_RIDES.whereField("driverUid", isEqualTo: uid).addSnapshotListener(listener)
    }

    func acceptTrip(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .accepted, completion: completion)
    }
    
    func rejectTrip(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .rejectedByDriver, completion: completion)
    }
    
    func didArriveAtPickupLocation(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .driverArrived, completion: completion)
    }
    
    func didArriveAtDropffLocation(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .arrivedAtDestination, completion: completion)
    }
    
    func pickupPassenger(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .inProgress, completion: completion)
    }
    
    func dropoffPassenger(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .complete, completion: completion)
    }
}
