//
//  String.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//

import Foundation

extension String{
    
    mutating func formattingPhone() -> String{
        if self.first == "8"{
            self.replaceSubrange(...self.startIndex, with: "7")
        }
        return "+\(self)"
     }
    
    var isValidPhone: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{10,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    var isEmail: Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
       let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: self)
    }
}
