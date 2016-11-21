//
//  Api.swift
//  GGDemo
//
//  Created by 卓同学 on 2016/11/20.
//
//

import UIKit
import Alamofire
import ObjectMapper

public class Api: NSObject {
    
    public override init() {
        super.init()
        headers["Accept"] = "application/vnd.hotelgg.v1+json"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var url: String {
        return NetworkConfig.environment.host + path
    }
    
    var parameters = [String : Any]()
    public var headers = [String : String]()
    
    public var success: (Any) -> Void  = { _ in }
    public var fail: (Error) -> Void = { _ in }
    
    enum NetworkError: Error {
        case jsonMapperError
    }

    func request<T: Mappable>() -> GGRequest<T> {
        let handler = GGRequest<T>() {(sendNext,sendFail) in
            Alamofire.request(self.url, method: self.method, parameters: self.parameters,headers: self.headers).responseJSON {[weak self] response in
                guard let strongSelf = self else {
                    return
                }
                switch response.result {
                case .failure(let error):
                    strongSelf.fail(error)
                case .success(let json):
                    if let data = json as? [String:Any] {
                        if let model = Mapper<T>().map(JSON: data) {
                            sendNext(model)
                            strongSelf.success(model)
                        }else {
                            sendFail(NetworkError.jsonMapperError)
                            strongSelf.fail(NetworkError.jsonMapperError)
                        }
                    }
                }
            }
        }
        return handler
    }
    
    
}
