//
//  EventType.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

struct EventType {
    var key: String
    var value: String
    
    init?(with json: [String: Any]) {
        guard let type = json["type"] as? String,
              let name = json["name"] as? String
        else {
            return nil
        }
        self.key = type
        self.value = name
    }
}
