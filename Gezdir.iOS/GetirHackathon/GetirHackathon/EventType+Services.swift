//
//  EventType+Services.swift
//  GetirHackathon
//
//  Created by Aleks Mutlu on 25/03/2017.
//  Copyright © 2017 Mutlu. All rights reserved.
//

import Foundation

extension EventType {
    
    typealias EventTypeResult = ([EventType]?, API.RequestError?) -> Void
    
    static func eventTypes(completion: @escaping EventTypeResult) {
        API.shared.request(endpoint: .eventTypes) { (jsonObject, error) in
            var eventTypeList = [EventType]()
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let rootJson = jsonObject as? [Any] else {
                completion(nil, .parse)
                return
            }
            
           /* guard let eventArray = rootJson as? [Any] else {
                return completion(nil, .parse)
            }*/
            
            rootJson.forEach { data in
                if  let eventData = data as? [String: Any],
                    let eventType = EventType(with: eventData) {
                    eventTypeList.append(eventType)
                }
            }
            
            completion(eventTypeList, nil)
        }
    }
}
