//
//  ResponseHandler.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit
import ObjectMapper

public class GGRequest<Value>: NSObject {
    
    typealias SendNext = (Value) -> Void
    typealias SendFail = (Error) -> Void
    
    private var success: SendNext = { _ in }
    private var fail: (Error) -> Void = { _ in }
    private var startAction: (@escaping SendNext,@escaping SendFail) -> Void
    
    init(start: @escaping (@escaping SendNext, @escaping SendFail) -> Void) {
        startAction = start
        super.init()
    }
    
    public func start() {
        startAction(success,fail)
    }
    
    @discardableResult
    public func succeed(handler: @escaping (Value) -> Void) -> GGRequest<Value> {
        success = {[unowned self] response in
            handler(response)
            self.observeSuccesQueue.forEach {
                $0(response)
            }
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
