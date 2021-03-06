//
//  OauthTests.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/24.
//
//

import XCTest
@testable import GGNetwork
import Alamofire

class OauthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        NetworkConfig.environment = .debug
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
    
    func testLogin() {
        let expection = expectation(description: "测试登录")
        let api = TokenApi(userName: "hgg:13917031501", password: "123456")
        api.handler.succeed { (oauth) in
            print("token: \(oauth.token)")
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
    
    func testRefreshToken() {
        let expection = expectation(description: "刷新token")
        let api = TokenApi(type: .refreshToken)
        api.handler.succeed { (oauth) in
            print("token: \(oauth.token)")
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
