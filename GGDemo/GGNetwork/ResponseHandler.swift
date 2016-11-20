//
//  ResponseHandler.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/21.
//
//

import UIKit

public class ResponseHandler: NSObject {
    
    var success: (Any) -> Void = { _ in }
    var fail: (Error) -> Void = { _ in }
    
    @discardableResult
    public func succeed(handler: @escaping (Any) -> Void) -> ResponseHandler {
        success = handler
        return self
    }
    
    @discardableResult
    public func failed(handler: @escaping (Error) -> Void) -> ResponseHandler {
        return self
    }

}
