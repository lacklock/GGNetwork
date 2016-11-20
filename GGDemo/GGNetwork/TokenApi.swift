//
//  TokenApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit
import Alamofire

public class TokenApi: Api {
    
    public override init() {
        super.init()
        parameters["client_id"] = NetworkConfig.environment.clintID
        parameters["client_secret"] = NetworkConfig.environment.secret
        parameters["grant_type"] = "client_credentials"
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "/oauth/token"
    }

}
