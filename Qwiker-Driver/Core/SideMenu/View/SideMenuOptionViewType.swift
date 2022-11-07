//
//  SideMenuOptionViewType.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 02.11.2022.
//

import Foundation

enum SideMenuOptionViewType: Int, CaseIterable {
    case trips
    case wallet
    case photocontrol
    case promocodes
    case message
    case share
    case support
    
    
    var title: String {
        switch self {
        case .trips: return "Orders"
        case .wallet: return "Ballance"
        case .support: return "Support"
        case .promocodes: return "Promocodes"
        case .share: return "Invite friends"
        case .photocontrol: return "Photocontrol"
        case .message: return "Message"
        }
    }
    
    var imageName: String {
        switch self {
        case .trips: return "list.bullet.rectangle"
        case .wallet: return "creditcard"
        case .support: return "bubble.left"
        case .promocodes: return ""
        case .share: return ""
        case .photocontrol: return ""
        case .message: return ""
        }
    }
}
