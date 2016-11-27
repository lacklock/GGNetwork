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
    
    func testGetCountries() {
        let expection = expectation(description: "testGetCountries")
        
        let api = CountriesApi()
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
    
    func testGetCountriesRegions() {
        let expection = expectation(description: "testGetCountries")
        let api = CountryiesRegionsApi(codes: ["1","3572"])
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
    
    func testGetHotels() {
        let expection = expectation(description: #function)
        let api = HotelApi()
        api.page = 2
        api.perPage = 5
        api.include = ["stat","tags"]
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
