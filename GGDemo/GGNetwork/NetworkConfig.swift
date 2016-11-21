//
//  NetworkConfig.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

import Foundation

public class NetworkConfig: NSObject {
    
    public static var environment = NetworkEnvironment.debug
    
    public static var userName: String?
    
    static var accessToken: String?
    
    
}
