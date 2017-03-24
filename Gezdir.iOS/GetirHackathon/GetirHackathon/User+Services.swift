//
//  User+Services.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 24/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

extension User {
    typealias LoginResult = (_ error: API.RequestError?) -> Void
    
    func login(completion: @escaping LoginResult) {
        API.shared.request(endpoint: .login(mail: self.mail, password: self.password!)) { (jsonObject, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let rootJson = jsonObject as? [String: Any] else {
                completion(.parse)
                return
            }
            
            User.current = User(with: rootJson)
            NotificationCenter.default.post(name: NSNotification.Name.loggedIn, object: nil)
            completion(nil) // No error
        }
    }
}
