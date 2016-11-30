//
//  SwiftViewController.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

import UIKit
import GGNetwork

class SwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let api = CountriesApi()
        api.host = self
        api.needCache = true
        api.handler.loadCached { (cached) in
            if let data = cached {
                print(data.count)
            }
        }.succeed { (countries) in
            print(countries.count)
        }.failed { (error) in
            print(error)
        }.start()

    }
    
    deinit {
        RequestingQueueManager.hostDestroyed(host: self)
    }


}



