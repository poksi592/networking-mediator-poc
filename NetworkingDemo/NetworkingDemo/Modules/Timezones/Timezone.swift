//
//  Timezone.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 25.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation

struct Timezone: Codable {
    
    let countryCode: String
    let countryName: String
    let zoneName: String
    let gmtOffset: Int
    let timestamp: Int
}
