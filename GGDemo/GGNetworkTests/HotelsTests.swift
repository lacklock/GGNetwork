//
//  HotelsTests.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/28.
//
//

import XCTest
@testable import GGNetwork
import Alamofire

class HotelsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testGetHotelsByID() {
        let expection = expectation(description: #function)
        let api = HotelsByIDApi(hotelIDs: [301,303])
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
