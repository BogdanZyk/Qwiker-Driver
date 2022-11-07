//
//  OrderViewModel.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 07.11.2022.
//

import Foundation
import FirebaseAuth

final class OrderViewModel: ObservableObject{
    
    let orderService = OrderService()
    var userSession: FirebaseAuth.User?
    
    @Published var orders: [SavedTrip] = []
    @Published var showLoader: Bool = false
    
    var totalCoast: Double{
        orders.map({$0.tripCost}).reduce(0, +)
    }
    
    
    init(){
        userSession = Auth.auth().currentUser
        getAllSavedTrips()
        addSavedTripObserver()
    }
    
    
    private func addSavedTripObserver(){
        guard let uid = userSession?.uid else {return}
        orderService.addSavedTripObserverForDriver(uid: uid) { snapshot, error in
            guard let change = snapshot?.documentChanges.first else { return }
                guard let trip = try? change.document.data(as: SavedTrip.self) else { return }
            if change.type == .added{
                self.orders.append(trip)
            }
        }
    }
    
    private func getAllSavedTrips(){
        guard let uid = userSession?.uid else {return}
        showLoader = true
        orderService.getAllSavedTripsForDriver(uid: uid) { orders, error in
            self.showLoader = false
            if let error = error {
                print(error.localizedDescription)
            }else if let orders = orders {
                self.orders = orders
            }
        }
    }
}
