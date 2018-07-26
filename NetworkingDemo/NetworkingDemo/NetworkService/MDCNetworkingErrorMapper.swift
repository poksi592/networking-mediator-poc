//
//  MDCNetworkingErrorMapper.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 12.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation
import MDCNetworking

class MDCNetworkingErrorMapper: ErrorMapper {
    
    class func error(from error: Error) -> NetworkServiceError {
        
        guard let error = error as? NetworkError else {
            return NetworkServiceError.other
        }
        
        switch error {
            
        case .serializationFailed:
            return NetworkServiceError.serializationFailed
            
        case .taskCancelled:
            return NetworkServiceError.taskCancelled
            
        case .badRequest400(let error, let response,_),
             .unauthorized401(let error, let response,_),
             .forbidden403(let error, let response,_),
             .notFound404(let error, let response,_),
             .other400(let error, let response,_),
             .serverError500(let error, let response,_):
            
            if let networkError = NetworkServiceError(error: error, response: response) {
                return networkError
            }
            else {
                return NetworkServiceError.other
            }
            
        default:
            return NetworkServiceError.other
        }
    }
    
    class func nsError(from error: Error) -> NSError {
        
        return error as NSError
    }
}
