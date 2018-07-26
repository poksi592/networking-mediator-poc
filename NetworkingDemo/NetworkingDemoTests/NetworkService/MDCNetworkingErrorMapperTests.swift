//
//  MDCNetworkingErrorMapperTests.swift
//  NetworkingDemoTests
//
//  Created by Mladen Despotovic on 12.07.18.
//  Copyright © 2018 Mladen Despotovic. All rights reserved.
//

import XCTest
import MDCNetworking
@testable import NetworkingDemo

class MDCNetworkingErrorMapperTests: XCTestCase {
    
    func urlResponse(statusCode: Int) -> HTTPURLResponse {
        
        return HTTPURLResponse(url: URL(string: "com.me.www")!,
                                        statusCode: statusCode,
                                        httpVersion: nil,
                                        headerFields: nil)!
    }
    
    // MARK: func error(from error: Error) -> Error
    
    func test_other() {
        
        // Prepare
        let oldError = NetworkError.other
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError) as! NetworkServiceError
        // Test
        guard case .other = newError else {
            XCTAssert(false, "Mapping of case NetworkError.other failed")
            return
        }
    }
    
    func test_serializationFailed() {
        
        // Prepare
        let oldError = NetworkError.serializationFailed
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError) as! NetworkServiceError
        // Test
        guard case .serializationFailed = newError else {
            XCTAssert(false, "Mapping of case NetworkError.serializationFailed failed")
            return
        }
    }
    
    func test_taskCancelled() {
        
        // Prepare
        let oldError = NetworkError.taskCancelled
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError) as! NetworkServiceError
        // Test
        guard case .taskCancelled = newError else {
            XCTAssert(false, "Mapping of case NetworkError.taskCancelled failed")
            return
        }
    }
    
    func test_noErrorNoResponsePassed() {
        
        // Prepare
        let oldError = NetworkError(error: nil, response: nil, payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .other = newError else {
            XCTAssert(false, "Mapping of case NetworkError.other failed")
            return
        }
    }
    
    func test_noErrorPassed() {
        
        // Prepare
        let oldError = NetworkError(error: nil, response: urlResponse(statusCode: 400), payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .badRequest400(_,_) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.badRequest with no error failed")
            return
        }
    }
    
    func test_noResponsePassed() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 400, userInfo: nil),
                                    response: nil, payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .other = newError else {
            XCTAssert(false, "Mapping of case NetworkError.badRequest with no response failed")
            return
        }
    }
    
    func test_errorOtherThanNetworkError() {
        
        // Prepare
        let oldError =  NSError(domain: "com.errors", code: 400, userInfo: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError) as! NetworkServiceError
        // Test
        guard case .other = newError else {
            XCTAssert(false, "Mapping of case NSError with no response failed")
            return
        }
    }
    
    func test_badRequest400() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 400, userInfo: nil),
                                    response: urlResponse(statusCode: 400),
                                    payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .badRequest400(let error,let response) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.badRequest failed")
            return
        }
        let nsError = error! as NSError
        XCTAssertEqual(nsError.code, 400)
        XCTAssertEqual(response!.statusCode, 400)
    }
    
    func test_unauthorized401() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 401, userInfo: nil),
                                    response: urlResponse(statusCode: 401),
                                    payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .unauthorized401(let error,let response) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.unauthorized401 failed")
            return
        }
        let nsError = error! as NSError
        XCTAssertEqual(nsError.code, 401)
        XCTAssertEqual(response!.statusCode, 401)
    }
    
    func test_forbidden403() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 403, userInfo: nil),
                                    response: urlResponse(statusCode: 403),
                                    payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .forbidden403(let error,let response) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.forbidden403 failed")
            return
        }
        let nsError = error! as NSError
        XCTAssertEqual(nsError.code, 403)
        XCTAssertEqual(response!.statusCode, 403)
    }
    
    func test_notFound404() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 404, userInfo: nil),
                                    response: urlResponse(statusCode: 404),
                                    payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .notFound404(let error,let response) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.notFound404 failed")
            return
        }
        let nsError = error! as NSError
        XCTAssertEqual(nsError.code, 404)
        XCTAssertEqual(response!.statusCode, 404)
    }
    
    func test_other400() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 407, userInfo: nil),
                                    response: urlResponse(statusCode: 407),
                                    payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .other400(let error,let response) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.other400 failed")
            return
        }
        let nsError = error! as NSError
        XCTAssertEqual(nsError.code, 407)
        XCTAssertEqual(response!.statusCode, 407)
    }
    
    func test_serverError500() {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 500, userInfo: nil),
                                    response: urlResponse(statusCode: 500),
                                    payload: nil)
        // Execute
        let newError: NetworkServiceError = MDCNetworkingErrorMapper.error(from: oldError!) as! NetworkServiceError
        // Test
        guard case .serverError500(let error,let response) = newError else {
            XCTAssert(false, "Mapping of case NetworkError.serverError500 failed")
            return
        }
        let nsError = error! as NSError
        XCTAssertEqual(nsError.code, 500)
        XCTAssertEqual(response!.statusCode, 500)
    }
    
    // MARK: func nsError(from error: Error) -> NSError
    
    func test_NSError() {
        
        // Prepare
        let oldError = NSError(domain: "com.errors", code: 500, userInfo: nil)
        // Execute
        let newError = MDCNetworkingErrorMapper.nsError(from: oldError)
        // Test
        XCTAssertEqual(oldError, newError as NSError)
    }
    
    func test_NSErrorPassingNetworkError () {
        
        // Prepare
        let oldError = NetworkError(error: NSError(domain: "com.errors", code: 500, userInfo: nil),
                                    response: urlResponse(statusCode: 500),
                                    payload: nil)
        // Execute
        let newError: NSError = MDCNetworkingErrorMapper.nsError(from: oldError!)
        // Test
        XCTAssertNotEqual(newError.code, 500)
    }
}
