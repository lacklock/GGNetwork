//
//  Region.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/27.
//
//

import UIKit
import ObjectMapper

public class Region: NSObject,Mappable {
    
    var ID = 0
    public var name = ""
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        ID <- map["id"]
        name <- map["name"]
    }

}
