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
    
    public static func refreshTokenIfNeeded() {
        let expire = UserDefaults.standard.double(forKey: "tokenExpireTime")
        if expire > NSDate().timeIntervalSince1970 {
            
        }
    }
    
    func refreshToken() {
        
    }
}
