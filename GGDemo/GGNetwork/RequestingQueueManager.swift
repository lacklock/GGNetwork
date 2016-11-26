//
//  RequestingQueue.swift
//  medtime
//
//  Created by 卓同学 on 2016/10/14.
//  Copyright © 2016年 DXY.CN. All rights reserved.
//

import Foundation
import Alamofire

public protocol RequestHost {
    var hostIdentifier: String { get }
}

public final class RequestingQueueManager: NSObject {
    
    public static private(set) var requests = Set<Request>()
    
    /// 请求相关联的宿主销毁
    public static func hostDestroyed(hostIdentifier: String) {
        requests.filter {
            return $0.hostIdentifier == hostIdentifier
            }.forEach {
                $0.cancel()
                print("\($0.request?.url?.absoluteString) canceled by \(hostIdentifier)")
                requests.remove($0)
        }
    }
    
    public static func hostDestroyed(host: RequestHost) {
        hostDestroyed(hostIdentifier: host.hostIdentifier)
    }
    
    static func addRequest(request: Request) {
        if request.hostIdentifier == nil {
            request.hostIdentifier = "NoneSpecifyHost"
        }
        requests.insert(request)
    }
    
    static func removeRequest(request: Request) {
        requests.remove(request)
    }
    
}

private var requestUUIDAsssociatedKey: UInt8 = 0
private var requestHostIdentifierKey: UInt8 = 0

extension Request: Hashable {
    
    /// 用于保存请求队列时作为request的ID
    var UUID: String {
        get {
            if let uuidString = objc_getAssociatedObject(self, &requestUUIDAsssociatedKey) as? String {
                return uuidString
            }else {
                assertionFailure("请求未配置UUID")
                return NSUUID().uuidString
            }
        }
        set {
            objc_setAssociatedObject(self, &requestUUIDAsssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var hashValue: Int {
        return UUID.hashValue
    }
    
    var hostIdentifier: String? {
        get {
            return objc_getAssociatedObject(self, &requestHostIdentifierKey) as? String
        }
        set {
            if let host = newValue {
                objc_setAssociatedObject(self, &requestHostIdentifierKey, host, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                UUID = NSUUID().uuidString
            }
        }
    }
    
}

public func ==(lhs: Request, rhs: Request) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
