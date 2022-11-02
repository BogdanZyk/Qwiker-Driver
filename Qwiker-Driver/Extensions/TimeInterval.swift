//
//  TimeInterval.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import Foundation


extension TimeInterval {
    
  
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }


    var stringTimeInMinutes: String {
         "\(minutes)m"
    }
}
