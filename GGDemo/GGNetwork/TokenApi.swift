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
            return "refresh_token"
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
        if type == .refreshToken {
            parameters[OAuthResult.Key.refresh_token.rawValue] = NetworkManager.refreshToken
        }
        setupObserver()
    }
    
    public init(userName: String, password: String) {
        super.init()
        type = OAuthGrantType.password
        parameters["username"] = userName
        parameters["password"] = password
        parameters["grant_type"] = type.value
        setIdentiferParameters()
        setupObserver()
    }
    
    private func setupObserver() {
        handler.observeSucces { (oauth) in
            if self.type == .password || self.type == .refreshToken {
                NetworkManager.udpate(oauth: oauth)
            }
        }
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
    
    override var needOAuth: Bool {
        return false
    }
    
    public lazy var handler: GGRequest<OAuthResult> = self.request()
    
    public func start() {
        handler.start()
    }
    
}
