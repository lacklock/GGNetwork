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

public enum NetworkError: Error,LocalizedError,CustomNSError {
    case jsonMapperError
    case responseDataFormatError
    case getTokenFailed
    
    public var errorDescription: String? {
        switch self {
        case .getTokenFailed:
            return "获取token失败"
        case .responseDataFormatError:
            return "返回的数据格式与期望的不同"
        case .jsonMapperError:
            return "映射model时发生错误"
        }
    }
    
    public var errorCode: Int {
        switch self {
        case .getTokenFailed:
            return 2000
        case .jsonMapperError:
            return 2001
        case .responseDataFormatError:
            return 2002
        }
    }
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
    public var host: RequestHost? {
        didSet{
            if let host = host {
                hostIdentifier = host.requestHostIdentifier
            }
        }
    }
    
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
    public var fail: (NSError) -> Void = { _ in }

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
                    sendFail(NetworkError.jsonMapperError as NSError)
                    strognSelf.fail(NetworkError.jsonMapperError as NSError)
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
    
    private func setupRequest<ResponseType>(sendFail: @escaping (NSError) -> Void, finished: @escaping (ResponseType) -> Void) {
        prepareForRequest()
        let request = Alamofire.request(url, method: method, parameters: parameters,headers: headers)
        request.hostIdentifier = hostIdentifier
        RequestingQueueManager.addRequest(request: request)
        request.responseJSON { response in
            RequestingQueueManager.removeRequest(request: request)
            guard let stausCode = response.response?.statusCode else {
                let error = NSError(domain: "GGNetwork", code: -1, userInfo: ["description":"没有状态码返回"])
                self.fail(error)
                sendFail(error)
                return
            }
            if let error = response.result.error {
                self.fail(error as NSError)
                sendFail(error as NSError)
                return
            }
            switch stausCode {
            case 200...299:
                guard let json = response.result.value,
                    let data = json as? ResponseType else {
                    sendFail(NetworkError.responseDataFormatError as NSError)
                    self.fail(NetworkError.responseDataFormatError as NSError)
                    return
                }
                if self.needCache {
                    if let data = data as? NSCoding {
                        YYCache.networkCache?.setObject(data, forKey: self.url)
                    }
                }
                finished(data)
            default:
                if let json = response.result.value as? [String: Any] {
                    let error = GGNetworkError(JSON: json)!
                    error.responseCode = stausCode
                    self.fail(error)
                    sendFail(error)
                    NetworkManager.process(responseError: error)
                }else {
                    let error = NSError(domain: "GGNetwork", code: stausCode, userInfo: ["description":"没有数据返回"])
                    self.fail(error as NSError)
                    sendFail(error as NSError)
                    return
                }
            }
        }
    }
    
}
