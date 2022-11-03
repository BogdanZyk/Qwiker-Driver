//
//  Helpers.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import SwiftUI
import MapKit
import GeoFireUtils

final class Helpers{
    
    static func openSettings(){
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {return}
        if UIApplication.shared.canOpenURL(settingURL){
            UIApplication.shared.open(settingURL)
        }
    }
    
    
    static func getGeoHash(forLocation location: CLLocationCoordinate2D) -> String{
        return GFUtils.geoHash(forLocation: location)
    }
}
