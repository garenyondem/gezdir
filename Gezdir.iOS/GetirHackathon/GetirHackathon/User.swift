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
let kToken = "kToken"

struct User {
    
    var nameSurname: String?
    var mail: String
    var password: String?
    var token: String = ""
    
    static var current: User? {
        didSet {
            UserDefaults.standard.setValue(self.current!.mail, forKey: kMail)
            UserDefaults.standard.setValue(self.current!.nameSurname, forKey: kNameSurname)
            UserDefaults.standard.setValue(self.current!.token, forKey: kToken)
        }
    }

    init(mail: String, password: String) {
        self.mail = mail
        self.password = password
        self.token = ""
    }
    
    init(nameSurname: String = "", mail: String, token: String) {
        self.nameSurname = nil
        self.mail = mail
        self.token = token
    }
    
    init?(with json: [String: Any]) {
        guard
            let nameSurname = json["nameSurname"] as? String,
            let mail = json["email"] as? String,
            let token = json["token"] as? String
        else { return nil }
        
        self.nameSurname = nameSurname
        self.mail = mail
        self.token = token
    }
}


