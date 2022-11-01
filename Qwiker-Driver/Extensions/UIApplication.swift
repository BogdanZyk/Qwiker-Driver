//
//  UIApplication.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//


import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
