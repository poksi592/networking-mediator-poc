//
//  MDCNetworkingServiceClientTests.swift
//  NetworkingDemoTests
//
//  Created by Mladen Despotovic on 12.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import XCTest
import MDCNetworking
@testable import NetworkingDemo

class MDCNetworkingServiceClientTests: XCTestCase {
    
    var bundle: Bundle?
    
    override func setUp() {
        
        super.setUp()
        bundle = Bundle(for: type(of: self))
    }
    
    override func tearDown() {
        
        bundle = nil
        super.tearDown()
    }
    
    func test_init() {
        
        // Prepare and Execute
        let client = MDCNetworkingServiceClient()
        // Test
        XCTAssertNotNil(client)
        XCTAssertNotNil(client?.client)
    }
    
    func test_initWithConfiguration() {
        
        // Prepare
        let configuration = NetworkServiceConfiguration(scheme: "http",
                                                        host: "api.timezonedb.com",
                                                        additionalHeaders: [:],
                                                        timeout: 59,
                                                        sessionConfiguration: URLSessionConfiguration.default,
                                                        pinnedCertificates: nil)
        // Test
        let client = MDCNetworkingServiceClient(configuration: configuration)
        // Execute
        XCTAssertEqual(client?.client?.configuration.timeout, 59)
    }
    
    //MARK Testing with `StubbedURLSession` of NetworkClient from MDCNetworking
    
    func test_getMatchingUrlSessionProvider() {
        
        // Prepare
        let filePath = bundle?.path(forResource: "Test1", ofType: "json")
        let responseString = try! String(contentsOfFile: filePath!, encoding: .utf8)
        let configuration = NetworkServiceConfiguration(scheme: "http",
                                                        host: "some1",
                                                        additionalHeaders: [:],
                                                        timeout: 59,
                                                        sessionConfiguration: URLSessionConfiguration.default,
                                                        pinnedCertificates: nil)
        let client = MDCNetworkingServiceClient(configuration: configuration)!
        client.stubbedSession!.addStub(schema: "http",
                                        host: "some1",
                                        path: "/path1",
                                        parameters: nil,
                                        headerFields: nil,
                                        response: responseString,
                                        responseStatusCode: 200)
        
        // Test
        let testExpectation = expectation(description: "Test Expectation")
        
        client.get(urlPathString: "/path1", parameters: nil, success: { (response) in
            
            let responseDict = response as? [String: Any]
            let lastValue = responseDict?["metricTimeInterval"] as! Int
            XCTAssertEqual(lastValue, 180)
            testExpectation.fulfill()
            
        }) { (error) in
            
            XCTAssert(false)
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getNonMatchingUrlSessionProvider() {
        
        // Prepare
        let filePath = bundle?.path(forResource: "Test1", ofType: "json")
        let responseString = try! String(contentsOfFile: filePath!, encoding: .utf8)
        let configuration = NetworkServiceConfiguration(scheme: "http",
                                                        host: "some1",
                                                        additionalHeaders: [:],
                                                        timeout: 59,
                                                        sessionConfiguration: URLSessionConfiguration.default,
                                                        pinnedCertificates: nil)
        let client = MDCNetworkingServiceClient(configuration: configuration)!
        
         // Different Host: "some2"
        client.stubbedSession!.addStub(schema: "http",
                                       host: "some2",
                                       path: "/path1",
                                       parameters: nil,
                                       headerFields: nil,
                                       response: responseString,
                                       responseStatusCode: 200)
        
        // Test
        let testExpectation = expectation(description: "Test Expectation")
        
        client.get(urlPathString: "/path1", parameters: nil, success: { (response) in
            
            XCTAssert(false)
            testExpectation.fulfill()
            
        }) { (error) in
            
            XCTAssert(true)
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
