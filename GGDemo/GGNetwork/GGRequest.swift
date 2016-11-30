//
//  ResponseHandler.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit
import ObjectMapper
import YYCache

protocol RequestInvokable {
    func start()
    func excuteFailedAction(error: Error)
}

public class GGRequest<Value>: NSObject,RequestInvokable {
    
    typealias SendNext = (Value) -> Void
    typealias SendFail = (Error) -> Void
    
    private var success: SendNext = { _ in }
    private var fail: (Error) -> Void = { _ in }
    private var startAction: (@escaping SendNext,@escaping SendFail) -> Void
    
    var cacheKey: String?
    var parsingJson: (Any) -> Value? = { _ in return nil }
    
    var needOAuth = true
    
    init(start: @escaping (@escaping SendNext, @escaping SendFail) -> Void) {
        startAction = start
        super.init()
    }
    
    public func start() {
        if NetworkManager.refreshTokenIfNeeded() && self.needOAuth {
            NetworkManager.suspendRequests.append(self)
            return
        }
        startAction(success,fail)
    }
    
    func excuteFailedAction(error: Error) {
        fail(error)
    }
    
    @discardableResult
    public func loadCached(handler: @escaping (Value?) -> Void) -> GGRequest<Value> {
        guard let key = cacheKey, let json = YYCache.networkCache?.object(forKey: key) else {
            handler(nil)
            return self
        }
        handler(parsingJson(json))
        return self
    }
    
    @discardableResult
    public func succeed(handler: @escaping (Value) -> Void) -> GGRequest<Value> {
        success = {[unowned self] response in
            self.observeSuccesQueue.forEach {
                $0(response)
            }
            handler(response)
        }
        return self
    }
    
    @discardableResult
    public func failed(handler: @escaping (Error) -> Void) -> GGRequest<Value> {
        fail = handler
        return self
    }
    
    private var observeSuccesQueue = [SendNext]()
    public func observeSucces(handler: @escaping (Value) -> Void) {
        observeSuccesQueue.append(handler)
    }

}

extension YYCache {
    static var networkCache: YYCache? {
      return  YYCache(name: "NetWorkCache")
    }
}
