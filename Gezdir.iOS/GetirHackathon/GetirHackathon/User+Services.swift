//
//  User+Services.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

extension User {
    typealias LoginResult = (_ success: Bool, _ error: API.RequestError?) -> Void
    
    func login(completion: LoginResult) {
        API.shared.request(endpoint: .login(mail: self.mail, password: self.password)) { (data, error) in
            print(data)
        }
    }
}
