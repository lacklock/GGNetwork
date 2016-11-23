//
//  OAuthManager.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/23.
//
//

import Foundation
import UIKit


public class NetworkManager: NSObject {
    
    static var accessToken: String? {
        didSet{
            UserDefaults.standard.set(accessToken, forKey: OAuthResult.Key.access_token.rawValue)
        }
    }
    static var accessTokenExpire: Double = 0 {
        didSet{
            UserDefaults.standard.set(accessTokenExpire, forKey: OAuthResult.Key.access_expires_in.rawValue)
        }
    }
    
    static var refreshToken: String? {
        didSet{
            UserDefaults.standard.set(refreshToken, forKey: OAuthResult.Key.refresh_token.rawValue)
        }
    }
    static var refreshTokenExpire: Double = 0 {
        didSet{
            UserDefaults.standard.set(refreshTokenExpire, forKey: OAuthResult.Key.refresh_expires_in.rawValue)
        }
    }
    
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
        let now = Date().timeIntervalSince1970
        let warningInterval: Double = 15 * 60 //如果过期时间很接近提前更新token
        if now > accessTokenExpire {
            requestToken()
            return true
        } else if (accessTokenExpire - now ) < warningInterval { //过期时间距离现在小于警戒时间
            requestToken()
        }
        return false
    }
    
    static func requestToken() {
        let now = Date().timeIntervalSince1970
        if let _ = refreshToken,  // TODO: 刷新token过期是要提示用户登录？
            refreshTokenExpire > now {
            startRefreshToken()
        }else {
            requestNewToken()
        }
    }
    
    
    /// 根据刷新原有token
    static func startRefreshToken() {
        isRequestingToken = true
        let api = TokenApi(type: .refreshToken)
        api.handler.succeed { (oauth) in
            self.isRequestingToken = false
            NetworkManager.accessToken = oauth.token
            NetworkManager.accessTokenExpire = oauth.tokenExpire
            NetworkManager.refreshToken = oauth.refreshToken
            NetworkManager.accessTokenExpire = oauth.refreshTokenExpire
        }.failed { (error) in
            self.isRequestingToken = false
            // TODO: failed handle
        }.start()
    }
    
    
    /// 请求一个全新的token
    static func requestNewToken() {
        isRequestingToken = true
        let api = TokenApi(type: .credentials)
        api.handler.succeed { (oauth) in
            self.isRequestingToken = false
            self.accessToken = oauth.token
            self.accessTokenExpire = oauth.tokenExpire
        }.failed { (error) in
            self.isRequestingToken = false
            // failed waiting queue
        }.start()
    }
}
