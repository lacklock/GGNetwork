//
//  RequestHost.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/26.
//
//

import UIKit

public protocol RequestHost {
    
    /// 网络请求宿主的标识符
    var requestHostIdentifier: String { get }
}

extension NSObject: RequestHost {
    
    public var requestHostIdentifier: String {
        return "\(type(of: self)) \(String(self.hashValue))"
    }
    
}
