//
//  RideType.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable, Codable{
    case economy
    case comfort
    case bisness
    case sport
    
    var id: Int {rawValue}
    
    var title: String{
        switch self{
        case .economy:
            return "Econom"
        case .comfort:
            return "Comfort"
        case .bisness:
            return "Bisness"
        case .sport:
            return "Sport"
        }
    }
    
//    var imageName: String{
//        switch self{
//        case .economy:
//            return "economy-car"
//        case .comfort:
//            return "comfort-car"
//        case .bisness:
//            return "bisness-car"
//        case .sport:
//            return "sport-car"
//        }
//    }

}
