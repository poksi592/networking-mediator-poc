//
//  ServiceClient.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 10.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation
import MDCNetworking

class MDCNetworkingServiceClient: NetworkServiceClient {

    typealias T = HTTPJSONSession
    var activeSessions = [WeakContainer<HTTPJSONSession>]()
    private(set) var client: NetworkClient?
    
    var stubbedSession: StubbedURLSession? {
        get {
            return client?.sessionProvider as? StubbedURLSession
        }
    }
    
    private init() {}
    
    // Default values for initialization
    required init?(configuration: NetworkServiceConfiguration) {
        
        guard let netConfiguration = try? Configuration(scheme: configuration.scheme,
                                                          host: configuration.host,
                                                          additionalHeaders: configuration.additionalHeaders,
                                                          timeout: configuration.timeout,
                                                          sessionConfiguration: configuration.sessionConfiguration,
                                                          sslPinningMode: (configuration.pinnedCertificates != nil) ? SSLPinningMode.certificate : SSLPinningMode.none,
                                                          pinnedCertificates: configuration.pinnedCertificates) else { return nil }

        self.client = NetworkClient(configuration: netConfiguration,
                                    sessionProvider: StubbedURLSession())
    }
    
    func get(urlPathString: String,
             parameters: [String: String]?,
             success: @escaping (([AnyHashable: Any], Data) -> Void),
             failure: @escaping ((NetworkServiceError) -> Void)) {
        
        session(method: .get,
                urlString: urlPathString,
                parameters: parameters) { (urlResponse, response, error, cancelled) in
            
            if let error = error {
                failure(MDCNetworkingErrorMapper.error(from: error))
                return
            }
            if let responseDict = response as? [AnyHashable: Any],
                let dataObject = try? JSONSerialization.data(withJSONObject: responseDict,
                                                             options: .prettyPrinted) {
                
                    success(responseDict, dataObject)
            }
            else {
                failure(NetworkServiceError.serializationFailed)
            }
        }
    }
    
    func cancelAll() {
        
        activeSessions.forEach { $0.value?.cancel() }
    }
    
    private func session(method: HTTPMethod,
                         urlString: String,
                         parameters: [String: String]?,
                         callback: @escaping ResponseCallback) {

        guard let client = self.client else { return }
        let mdcNetworkingSession = client.session(urlPath: urlString,
                                                  method: method,
                                                  parameters: parameters,
                                                  completion: callback)
        activeSessions.append(WeakContainer(value: mdcNetworkingSession))
        try? mdcNetworkingSession.start()
    }
}


