//
//  GetCountriesApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/25.
//
//

import UIKit
import Alamofire
import ObjectMapper

public class CountriesApi: Api {
    
    public init() {
        super.init()
    }
    
    override var path: String {
        return "/api/countries"
    }
    
    public lazy var handler: GGRequest<[Country]> = self.request()
    
    public func start() {
        handler.start()
    }

}

