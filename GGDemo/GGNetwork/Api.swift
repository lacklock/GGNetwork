//
//  Api.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

import UIKit
import Alamofire
import ObjectMapper

public class Api: NSObject {
    
    var method: HTTPMethod{
        return .get
    }
    
    var path: String {
        return ""
    }
}
