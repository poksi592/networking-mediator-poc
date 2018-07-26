//
//  NetworkServiceClient.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 12.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation

/**
 Structure which contains generic information needed to create any kind of call to URL Loading system
 */
struct NetworkServiceConfiguration {
    
    let scheme: String
    let host: String
    let additionalHeaders: [String: String]
    let timeout: TimeInterval
    let sessionConfiguration: URLSessionConfiguration
    let pinnedCertificates: [Data]?
}

/**
 Enum, which is similar to this in `MDCNetworking` but without a potential payload, let's say our app does not need it
 */
enum NetworkServiceError: Error {
    
    case serializationFailed
    case taskCancelled
    case badRequest400(error: Error?, response: HTTPURLResponse?)
    case unauthorized401(error: Error?, response: HTTPURLResponse?)
    case forbidden403(error: Error?, response: HTTPURLResponse?)
    case notFound404(error: Error?, response: HTTPURLResponse?)
    case other400(error: Error?, response: HTTPURLResponse?)
    case serverError500(error: Error?, response: HTTPURLResponse?)
    case other
    
    init?(error: Error?, response: HTTPURLResponse?) {
        
        let responseCode: Int
        if let response = response {
            responseCode = response.statusCode
        } else {
            responseCode = 0
            self = .other
        }
        
        switch responseCode {
        case 200..<300:
            return nil
        case 400:
            self = .badRequest400(error: error, response: response)
        case 401:
            self = .unauthorized401(error: error, response: response)
        case 403:
            self = .forbidden403(error: error, response: response)
        case 404:
            self = .notFound404(error: error, response: response)
        case 405..<500:
            self = .other400(error: error, response: response)
        case 500..<600:
            self = .serverError500(error: error, response: response)
        default:
            self = .other
        }
    }
}

/**
 Abstraction of potentially different types of implementations with for example dofferent frameworks or any kind of different
 wrappers in layers closer to NSURLSession
 */
protocol NetworkServiceClient {

    associatedtype T
    /**
     Array of weakly referenced sessions, whould will be automatically removed when finished their work and deallocate
     */
    var activeSessions: [WeakContainer<T>] { get set }
    
    init?(configuration: NetworkServiceConfiguration)
    
    /**
     Implementation of typical "GET" HTTP method accessor.
     
     - parameters:
        - urlString: Contains `String` value of path part of URL, scheme and host are taken from `NetworkServiceConfiguration`
        - parameters: Optional dictionary, for now we limit ourselves to a simple single level dictionary, no complex request types.
        - success: Returned object could be of any kind: JSON, XML, text,... we leave details to parsers
        - failure: Error object
     */
    func get(urlPathString: String,
             parameters: [String: String]?,
             success: @escaping (([AnyHashable: Any], Data) -> Void),
             failure: @escaping ((NetworkServiceError) -> Void))
    
    /**
     Cancels all open `NetworkingClientSession` objects. Very useful, when for example user navigates back and we don't
     want open sessions to run without need.
     */
    func cancelAll()
}
