//
//  HotelsByIDApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/28.
//
//

import UIKit

public class HotelsByIDApi: HotelApi {
    
    var IDs: [Int]
    
    public init(hotelIDs: [Int]) {
        self.IDs = hotelIDs
        super.init()
    }
    
    override var path: String {
        return "/api/hotels/\(IDs.restJoined)"
    }
    
}
