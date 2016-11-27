//
//  CountryiesRegionsApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/27.
//
//

import UIKit
import ObjectMapper

public class CountryiesRegionsApi: CountriesRelatedApi {
    
    override var subPath: String {
        return "regions"
    }

    public lazy var handler: GGRequest<[Region]> = self.request()
}
