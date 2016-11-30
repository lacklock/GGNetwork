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
import YYCache

enum NetworkError: Error {
    case jsonMapperError
    case responseDataFormatError
    case getTokenFailed
}

public class Api: NSObject {
    
    public init(httpMethod: HTTPMethod = .get) {
        super.init()
        method = httpMethod
        setupHeaders()
    }
    
    public var needCache = false
    
    private func setupHeaders() {
        headers["Accept"] = "application/vnd.hotelgg.v1+json"
    }
    
    /// 默认为Get
    var method = HTTPMethod.get 
    
    var path: String {
        return ""
    }
    
    var url: String {
        return NetworkConfig.environment.host + path
    }
    
    /// 用于表明发出请求前是否需要带有accessToken，只有获取token的接口不用带
    var needOAuth: Bool {
        return true
    }
    
    /// 请求关联对象的ID
    public var hostIdentifier: String?
    
    var parameters = [String : Any]()
    var headers = [String : String]()
    
    /// 选择需要额外加载的属性
    public var include = [String]()
        
    func prepareForRequest() {
        if needOAuth,let accessToken = NetworkManager.accessToken {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        if include.count > 0 {
            parameters["include"] = include.joined(separator: ",")
        }else {
            parameters.removeValue(forKey: "include")
        }
    }
    
    //为兼容OC用
    public var success: (Any) -> Void  = { _ in }
    public var fail: (Error) -> Void = { _ in }

    func request<T: Mappable>() -> GGRequest<T> {
        func parsingJson(json: Any) -> T? {
            guard let data = json as? [String : Any] else {
                return nil
            }
            return Mapper<T>().map(JSON: data)
        }
        
        let handler = GGRequest<T>() {[weak self]  (sendNext,sendFail) in
            guard let strognSelf = self else { return }
            strognSelf.setupRequest(sendFail: sendFail, finished: { (data: [String : Any]) in
                if let model = parsingJson(json: data) {
                    sendNext(model)
                    strognSelf.success(model)
                }else {
                    sendFail(NetworkError.jsonMapperError)
                    strognSelf.fail(NetworkError.jsonMapperError)
                }
            })
        }
        handler.needOAuth = needOAuth
        if needCache {
            prepareForRequest()
            handler.cacheKey = url
            handler.parsingJson = parsingJson
        }
        return handler
    }
    
    public func request<T: Mappable>() -> GGRequest<[T]> {
        func parsingJson(json: Any) -> [T]? {
            guard let data = json as? [[String : Any]] else {
                return nil
            }
            let models = data.flatMap {
                Mapper<T>().map(JSON: $0)
            }
            return models
        }
        
        let handler = GGRequest<[T]>() {[weak self]  (sendNext,sendFail) in
            guard let strognSelf = self else { return }
            strognSelf.setupRequest(sendFail: sendFail, finished: { (data: [[String : Any]]) in
                let models = parsingJson(json: data)!
                sendNext(models)
                strognSelf.success(models)
            })
        }
        handler.needOAuth = needOAuth
        if needCache {
            prepareForRequest()
            handler.cacheKey = url
            handler.parsingJson = parsingJson
        }
        return handler
    }
    
    private func setupRequest<ResponseType>(sendFail: @escaping (Error) -> Void, finished: @escaping (ResponseType) -> Void) {
        prepareForRequest()
        let request = Alamofire.request(url, method: method, parameters: parameters,headers: headers)
        request.hostIdentifier = hostIdentifier
        RequestingQueueManager.addRequest(request: request)
        request.validate(statusCode: 200...299)
            .responseJSON { response in
                RequestingQueueManager.removeRequest(request: request)
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
                    if self.needCache {
                        if let data = data as? NSCoding {
                            YYCache.networkCache?.setObject(data, forKey: self.url)
                        }
                    }
                    finished(data)
                }
        }
    }
    
}
