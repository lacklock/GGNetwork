//
//  MultiPageApi.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/26.
//
//

import UIKit

public class MultiPageApi: Api {
    
    public var page = 1
    public var perPage = 20
    public var sort: String?
    
    override func prepareForRequest() {
        super.prepareForRequest()
        parameters["page"] = page
        parameters["per_page"] = perPage
        if let sort = sort {
            parameters["sort"] = sort
        }
    }
    
}
