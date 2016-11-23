//
//  OAuthManager.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/23.
//
//

import Foundation
import UIKit

let RefreshTokenExpireInterval: Double = 14 * 24 * 60 * 60 //refresh token 过期时间为两周

public class NetworkManager: NSObject {
    
    private static var accessToken: String? {
        didSet{
            UserDefaults.standard.set(accessToken, forKey: OAuthResult.Key.access_token.rawValue)
        }
    }
    private static var accessTokenExpire: Double = 0 {
        didSet{
            UserDefaults.standard.set(accessTokenExpire, forKey: OAuthResult.Key.access_expires_in.rawValue)
        }
    }
    
    private static var refreshToken: String?
    private static var refreshTokenExpire: Double = 0
    
    /// 请求时如果正在刷新token，挂起api
    private static var suspendRequests = [Api]()
    
    public static func start() {
        accessToken = UserDefaults.standard.string(forKey: OAuthResult.Key.access_token.rawValue)
        accessTokenExpire = UserDefaults.standard.double(forKey: OAuthResult.Key.access_expires_in.rawValue)
        refreshToken = UserDefaults.standard.string(forKey: OAuthResult.Key.refresh_token.rawValue)
        refreshTokenExpire = UserDefaults.standard.double(forKey: OAuthResult.Key.refresh_expires_in.rawValue)
        let _ = refreshTokenIfNeeded()
    }
    
    private static var isRequestingToken = false
    
    static func refreshTokenIfNeeded() -> Bool {
        if isRequestingToken {
            return true
        }
        guard accessTokenExpire > 0 else {
            requestToken()
            return true
        }
        let now = NSDate().timeIntervalSince1970
        let wariningInterval: Double = 15 * 60 //如果过期时间很接近提前更新token
        if now > accessTokenExpire {
            requestToken()
            return true
        } else if (accessTokenExpire - now ) < wariningInterval { //过期时间距离现在小于警戒时间
            requestToken()
        }
        return false
    }
    
    static func requestToken() {
        let now = NSDate().timeIntervalSince1970
        if let _ = refreshToken,
            refreshTokenExpire > 0,
            refreshTokenExpire > now {
            startRefreshToken()
        }else {
            requestNewToken()
        }
    }
    
    
    /// 根据刷新原有token
    static func startRefreshToken() {
        
    }
    
    
    /// 请求一个全新的token
    static func requestNewToken() {
        isRequestingToken = true
        let api = TokenApi(type: .credentials)
        api.handler.succeed { (oauth) in
            self.isRequestingToken = false
            self.accessToken = oauth.token
            self.accessTokenExpire = oauth.expire + Date().timeIntervalSince1970
        }.failed { (error) in
            self.isRequestingToken = false
            // failed waiting queue
        }.start()
    }
}
