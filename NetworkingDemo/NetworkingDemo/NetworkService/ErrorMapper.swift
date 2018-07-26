//
//  ErrorMapper.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 12.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation

protocol ErrorMapper {
    
    static func error(from error: Error) -> NetworkServiceError
    static func nsError(from error: Error) -> NSError
}
