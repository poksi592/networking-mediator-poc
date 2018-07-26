//
//  TimezonesInteractor.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 13.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation

class TimezonesInteractor  {

    func getTimezones(completion: @escaping ([Timezone]?, Error?) -> Void) {
        
        let parameters = ["key": "1S2RMN6YBMYA",
                          "format": "json"]
        let client = ApplicationConfigurator.shared.networkingClient()
        client?.get(urlPathString: "/v2/list-time-zone",
                    parameters: parameters,
                    success: { (responseDict, _) in
                        
                        guard let zonesDictionary = responseDict["zones"] as? [Any] else {
                                
                            completion(nil, NetworkServiceError.serializationFailed)
                            return
                        }
                        
                        let zones: [Timezone?] = zonesDictionary.map { (zoneObject) in
                            
                            guard let dataObject = try? JSONSerialization.data(withJSONObject: zoneObject,
                                                                               options: .prettyPrinted),
                                let zone = try? JSONDecoder().decode(Timezone.self, from: dataObject) else {
                                return nil
                            }
                            return zone
                        }
                        
                        completion(zones.compactMap { $0 }, nil)
                        
        }, failure: { error in
            
            // not handled right now
        })
    }
}
