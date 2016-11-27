//
//  OCVCExtension.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/26.
//
//

import Foundation
import GGNetwork

extension OCViewController {
    
    func getCountries() {
        let api = CountriesApi()
        api.handler.succeed { (countries) in
            print(countries.count)
            self.demoLabel.text = countries.first!.name
            }.start()
    }
    
}

