//
//  ResponseHandler.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit
import ObjectMapper

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
    public func succeed(handler: @escaping (Value) -> Void) -> GGRequest<Value> {
        success = {[unowned self] response in
            self.observeSuccesQueue.forEach {
                $0(response)
            }
            handler(response)
        }
        return self
    }
    
    public func cachedValue(){
        
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
