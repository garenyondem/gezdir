//
//  User.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

let kNameSurname = "kNameSurname"
let kMail = "kMail"
let kPassword = "kPassword"

struct User {
    
    var nameSurname: String?
    var mail: String
    var password: String
    
    static var current: User?
    
    init(nameSurname: String = "", mail: String, password: String) {
        self.nameSurname = nil
        self.mail = mail
        self.password = password
    }
}


