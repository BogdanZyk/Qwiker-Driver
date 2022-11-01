//
//  MapViewState.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//


import Foundation

enum MapViewState: Int {
    case noInput
    case searchingForLocation
    case locationSelected
    case tripRequested
    case tripAccepted
    case driverArrived
    case tripInProgress
    case arrivedAtDestination
    case tripCompleted
    case tripCancelled
    case polylineAdded
}
