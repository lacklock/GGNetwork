//
//  HotelApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/26.
//
//

import UIKit

public class HotelApi: MultiPageApi {
    
    override var path: String {
        return "/api/hotels"
    }
    
    public lazy var handler: GGRequest<[Hotel]> = self.request()
    
}
