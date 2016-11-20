//
//  NetworkEnviroment.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

import Foundation

public enum NetworkEnviroment {
    case debug
    case release
    
    var host: String {
        switch self {
        case .debug:
            return "https://msa.hotelgg.net"
        case .release:
            return "https://msa.hotelgg.com"
        }
    }
    
    var clintID: String {
        switch self {
        case .debug:
            return "88786bdb4cd8349c8a8373c5aec9f283"
        case .release:
            return "https://msa.hotelgg.com"
        }
    }
    
    var secret: String {
        switch self {
        case .debug:
            return "bc2f696bda686459c096088510dc4eba"
        case .release:
            return "https://msa.hotelgg.com"
        }
    }
    
}
