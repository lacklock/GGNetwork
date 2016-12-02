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
    
    /// 请求时如果正在刷新token，挂起api
    static var suspendRequests = [RequestInvokable]()
    
    public static func start() {
        let _ = refreshTokenIfNeeded()
        
        let mb = 1024 * 1024
        let cache = URLCache(memoryCapacity: 5 * mb, diskCapacity: 200 * mb, diskPath: nil)
        URLCache.shared = cache
        
    }
    
    private static var isRequestingToken = false
    
    @discardableResult
    static func refreshTokenIfNeeded() -> Bool {
        if isRequestingToken {
            return true
        }
        guard let token = accessToken, token.characters.count > 0, accessTokenExpire > 0 else {
            requestToken()
            return true
        }
        let now = Date().timeIntervalSince1970
        let warningInterval: Double = 15 * 60 //如果过期时间很接近提前更新token
        if now > accessTokenExpire {
            requestToken()
            return true
        } else if (accessTokenExpire - now ) < warningInterval { //过期时间距离现在小于警戒时间 
            // TODO: 提前刷新token时可能出现连续请求token
            requestToken(inBackground: true)
        }
        return false
    }
    
    static func requestToken(inBackground: Bool = false) {
        let now = Date().timeIntervalSince1970
        if let _ = refreshToken{
            if refreshTokenExpire > now {
                startRefreshToken()
            }else {
                requestNewToken()
                notifyNeedLogin()
            }
        }else {
            requestNewToken()
        }
    }
    
    /// 根据刷新原有token
    static func startRefreshToken(inBackground: Bool = false) {
        isRequestingToken = !inBackground
        let api = TokenApi(type: .refreshToken)
        api.handler.succeed { (oauth) in
            self.isRequestingToken = false
            self.excuteSuspendRequests(isSucced: true)
        }.failed { (error) in
            if inBackground {
                return
            }
            self.isRequestingToken = false
            self.excuteSuspendRequests(isSucced: false)
            self.notifyNeedLogin()
        }.start()
    }
    
    private static func notifyNeedLogin() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserNeedLoginAgain"), object: nil)
    }
    
    static func udpate(oauth: OAuthResult) {
        accessToken = oauth.token
        accessTokenExpire = oauth.tokenExpire
        refreshToken = oauth.refreshToken
        refreshTokenExpire = oauth.refreshTokenExpire
    }
    
    /// 请求一个全新的token
    static func requestNewToken(inBackground: Bool = false) {
        isRequestingToken = !inBackground
        let api = TokenApi(type: .credentials)
        api.handler.succeed { (oauth) in
            self.isRequestingToken = false
            self.accessToken = oauth.token
            self.accessTokenExpire = oauth.tokenExpire
            self.excuteSuspendRequests(isSucced: true)
        }.failed { (error) in
            if inBackground {
                return
            }
            self.isRequestingToken = false
            self.excuteSuspendRequests(isSucced: false)
        }.start()
    }
    
    
    private static func excuteSuspendRequests(isSucced: Bool) {
        if isSucced {
            suspendRequests.forEach {
                $0.start()
            }
            suspendRequests.removeAll()
        }else {
            suspendRequests.forEach {
                $0.excuteFailedAction(error: NetworkError.getTokenFailed as NSError)
            }
            suspendRequests.removeAll()
        }
    }
    
    // MARK: - cached token
    static var accessToken: String? = UserDefaults.standard.string(forKey: OAuthResult.Key.access_token.rawValue) {
        didSet{
            UserDefaults.standard.set(accessToken, forKey: OAuthResult.Key.access_token.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var accessTokenExpire = UserDefaults.standard.double(forKey: OAuthResult.Key.access_expires_in.rawValue) {
        didSet{
            UserDefaults.standard.set(accessTokenExpire, forKey: OAuthResult.Key.access_expires_in.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var refreshToken: String? = UserDefaults.standard.string(forKey: OAuthResult.Key.refresh_token.rawValue) {
        didSet{
            UserDefaults.standard.set(refreshToken, forKey: OAuthResult.Key.refresh_token.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var refreshTokenExpire: Double = UserDefaults.standard.double(forKey: OAuthResult.Key.refresh_expires_in.rawValue) {
        didSet{
            UserDefaults.standard.set(refreshTokenExpire, forKey: OAuthResult.Key.refresh_expires_in.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
