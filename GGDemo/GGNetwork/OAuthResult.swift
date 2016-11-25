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
    
    private let refreshTokenExpireInterval: Double = 14 * 24 * 60 * 60 //refresh token 过期时间为两周
    
    enum Key: String {
        case access_token
        case expires_in
        case access_expires_in
        case refresh_token
        case refresh_expires_in
    }
    
    public var token = ""
    
    var expire: Double = 0 {
        didSet{
            tokenExpire = Date().timeIntervalSince1970 + expire
        }
    }
    public var tokenExpire: Double = 0
    public var tokenType = ""
    
    public var refreshToken: String? {
        didSet{
            refreshTokenExpire = Date().timeIntervalSince1970 + refreshTokenExpireInterval
        }
    }
    public var refreshTokenExpire: Double = 0
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        token <- map[Key.access_token.rawValue]
        expire <- map[Key.expires_in.rawValue]
        tokenType <- map["token_type"]
        refreshToken <- map[Key.refresh_token.rawValue]
    }
    

}
