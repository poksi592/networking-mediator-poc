//
//  ApplicationConfigurator.swift
//  NetworkingDemo
//
//  Created by Mladen Despotovic on 25.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import Foundation

class ApplicationConfigurator  {
    
    static let shared = ApplicationConfigurator()
    
    init() {}
    
    lazy var networkConfiguration = NetworkServiceConfiguration(scheme: "http",
                                                                host: "api.timezonedb.com",
                                                                additionalHeaders: [:],
                                                                timeout: 60,
                                                                sessionConfiguration: URLSessionConfiguration.default,
                                                                pinnedCertificates: nil)
    
    func networkingClient() -> MDCNetworkingServiceClient? {
        
        return MDCNetworkingServiceClient(configuration: networkConfiguration)
    }
}

