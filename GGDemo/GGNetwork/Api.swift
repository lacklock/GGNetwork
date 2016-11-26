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

enum NetworkError: Error {
    case jsonMapperError
    case responseDataFormatError
}

public class Api: NSObject {
    
    public override init() {
        super.init()
        setupHeaders()
    }
    
    var needCache = false 
    
    private func setupHeaders() {
        headers["Accept"] = "application/vnd.hotelgg.v1+json"
    }
    
    /// 默认为Get
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
    
    var url: String {
        return NetworkConfig.environment.host + path
    }
    
    var needOAuth: Bool {
        return true
    }
    
    var parameters = [String : Any]()
    var headers = [String : String]()
    
    func prepareForRequest() {
        if needOAuth,let accessToken = NetworkManager.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
    }
    
    //为兼容OC用
    public var success: (Any) -> Void  = { _ in }
    public var fail: (Error) -> Void = { _ in }

    func request<T: Mappable>() -> GGRequest<T> {
        let handler = GGRequest<T>() { (sendNext,sendFail) in
            self.setupRequest(sendFail: sendFail, finished: { (data: [String : Any]) in
                if let model = Mapper<T>().map(JSON: data) {
                    sendNext(model)
                    self.success(model)
                }else {
                    sendFail(NetworkError.jsonMapperError)
                    self.fail(NetworkError.jsonMapperError)
                }
            })
        }
        return handler
    }
    
    public func request<T: Mappable>() -> GGRequest<[T]> {
        let handler = GGRequest<[T]>() {(sendNext,sendFail) in
            self.setupRequest(sendFail: sendFail, finished: { (data: [[String : Any]]) in
                let models = data.flatMap {
                    Mapper<T>().map(JSON: $0)
                }
                sendNext(models)
                self.success(models)
            })
        }
        return handler
    }
    
    private func setupRequest<ResponseType>(sendFail: @escaping (Error) -> Void, finished: @escaping (ResponseType) -> Void) {
        prepareForRequest()
        Alamofire.request(url, method: method, parameters: parameters,headers: headers)
            .validate(statusCode: 200...299)
            .responseJSON { response in
                switch response.result {
                case .failure(let error):
                    self.fail(error)
                    sendFail(error)
                case .success(let json):
                    guard let data = json as? ResponseType else {
                        sendFail(NetworkError.responseDataFormatError)
                        self.fail(NetworkError.responseDataFormatError)
                        return
                    }
                    finished(data)
                }
        }
    }
    
}
