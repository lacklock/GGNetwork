//
//  GGNetworkError.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/12/5.
//
//

import UIKit
import ObjectMapper

public class GGNetworkError: NSError,Mappable {

    public var error = "unkonwn"
    public var errorDescription: String?
    var responseCode = -1
    
    public override var code: Int {
        return responseCode
    }
    
    public override init(domain: String, code: Int, userInfo dict: [AnyHashable : Any]? = nil) {
        super.init(domain: domain, code: code, userInfo: dict)
    }
    
    public required convenience init?(map: Map) {
        self.init(code: -1)
    }
    
    convenience init(code: Int) {
        self.init(domain: "GGNetwork", code: -1)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func mapping(map: Map) {
        error <- map["error"]
        errorDescription <- map["error_description"]
    }
}
