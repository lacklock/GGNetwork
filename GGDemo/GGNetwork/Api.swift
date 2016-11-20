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
    
    public override init() {
        super.init()
        headers["Accept"] = "application/vnd.hotelgg.v1+json"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var url: String {
        return NetworkConfig.environment.host + path
    }
    
    var parameters = [String : Any]()
    var headers = [String : String]()
    
    public var response = ResponseHandler()
    
    @discardableResult
    public func startRequest() -> ResponseHandler {
        Alamofire.request(url, method: method, parameters: parameters,headers: headers).responseJSON { response in
            switch response.result {
            case .failure(let error):
                self.response.fail(error)
            case .success(let json):
                self.response.success(json)
            }
        }
        return response
    }
}
