//
//  StringExtension.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/27.
//
//

import Foundation

extension Sequence where Iterator.Element == String {
    
    /// 服务端规定的字符串拼接
    var restJoined: String {
        return joined(separator: ",")
    }
}

extension Sequence where Iterator.Element == Int {
    
    /// 服务端规定的字符串拼接
    var restJoined: String {
        return reduce("") { result, num in
            let speator = result.characters.count > 0 ? "," : ""
            return result + speator + String(num)
        }
    }
    
}

