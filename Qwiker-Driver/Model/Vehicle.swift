//
//  Vehicle.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import Foundation

struct Vehicle: Codable {
    var make: String
    var model: String
    var year: String
    var color: VehicleColors
    var licensePlateNumber: String
    var type: RideType
    var number: String
}

enum VehicleColors: Int, CaseIterable, Identifiable, Codable {
    case black
    case white
    case red
    case yellow
    case gray
    case silver
    case blue
    case tan
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .black: return "Black"
        case .white: return "White"
        case .red: return "Red"
        case .yellow: return "Yellow"
        case .gray: return "Gray"
        case .silver: return "Silver"
        case .blue: return "Blue"
        case .tan: return "Tan"
        }
    }
}
