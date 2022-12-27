//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by LIN SHI ZHENG on 15/12/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation

struct Constants {
    
    enum Segue: String {
        case register = "RegisterToChat"
        case login = "LoginToChat"
    }
    
    static let appName = "⚡️FlashChat"
    
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
}
