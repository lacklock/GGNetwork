//
//  GGNetworkTests.swift
//  GGNetworkTests
//
//  Created by 卓同学 on 2016/11/20.
//
//

import XCTest
@testable import GGNetwork
import Alamofire

class GGNetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
         NetworkConfig.environment = NetworkEnvironment.debug
    }
    
    func testGetToken() {
        let expection = expectation(description: "get token")
        
        let api = TokenApi(type: .credentials)
        api.handler.succeed { (data) in
            print(data)
            XCTAssert(true)
            expection.fulfill()
        }.failed { (error) in
            print(error)
            XCTAssert(false)
            expection.fulfill()
        }.start()
        
        waitForExpectations(timeout: 15) { error in
            print(error)
        }
    }

    
}
