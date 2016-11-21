//
//  TokenApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit
import Alamofire
import ObjectMapper

@objc public enum OAuthGrantType: Int {
    case credentials
    case password
    case refreshToken
}

extension OAuthGrantType {
    var value: String {
        switch self {
        case .credentials:
            return "client_credentials"
        case .password:
            return "password"
        case .refreshToken:
            return "refreshToken"
        }
    }
}

public class TokenApi: Api {
    
    public var type = OAuthGrantType.credentials
    
    public init(type: OAuthGrantType) {
        super.init()
        setIdentiferParameters()
        self.type = type
        parameters["grant_type"] = type.value
    }
    
    public init(password: String) {
        super.init()
        type = OAuthGrantType.password
        parameters["username"] = NetworkConfig.userName
        parameters["password"] = password
        parameters["grant_type"] = type.value
        setIdentiferParameters()
    }
    
    private func setIdentiferParameters() {
        parameters["client_id"] = NetworkConfig.environment.clintID
        parameters["client_secret"] = NetworkConfig.environment.secret
    }
    
    override var method: HTTPMethod {
        return .post
    }
    
    override var path: String {
        return "/oauth/token"
    }
    
    lazy var handler: GGRequest<OAuthResult> = self.request()
    
    public func start() {
        handler.start()
    }
    
}
