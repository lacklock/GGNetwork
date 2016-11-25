//
//  Conuntry.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/25.
//
//

import UIKit
import ObjectMapper

public class Country: NSObject,Mappable {
    
    var ID = 0
    var name = ""
    var code = ""
    var nameEn = ""
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        ID <- map["id"]
        name <- map["name"]
        code <- map["code"]
        nameEn <- map["name_en"]
    }
}
