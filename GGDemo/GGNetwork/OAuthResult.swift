//
//  OAuthResult.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit
import ObjectMapper

public class OAuthResult: NSObject, Mappable {
    
    public var token = ""
    public var expire = 0
    public var tokenType = ""
    public var refreshToken: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        token <- map["access_token"]
        expire <- map["expires_in"]
        tokenType <- map["token_type"]
        refreshToken <- map["refresh_token"]
    }
}
