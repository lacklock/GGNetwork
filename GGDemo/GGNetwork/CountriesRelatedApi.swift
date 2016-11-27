//
//  CountriesRelatedApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/27.
//
//

import UIKit

public class CountriesRelatedApi: Api {
    
    public var codes: [String]
    
    public init(codes: [String]) {
        self.codes = codes
        super.init()
    }

    var subPath: String {
        return ""
    }
    
    override var path: String {
        return "/api/countries/\(codes.restJoined)/\(subPath)"
    }
}
