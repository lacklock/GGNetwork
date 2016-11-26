//
//  Hotel.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/25.
//
//

import UIKit
import ObjectMapper

public class Hotel: NSObject,Mappable {
    
    var ID: Int = 0
    var street = ""
    var title = ""
    public var tags = [String]()
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        ID <- map["id"]
        title <- map["title"]
        street <- map["street"]
        tags <- map["tags"]
    }
}
