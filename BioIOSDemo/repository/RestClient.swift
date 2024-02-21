//
//  Client.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import Alamofire

let GeneralErrorCode = -1

public struct ApiErrorDto : Codable {
    var status: Int
    var message: String?
    var error: String?
    
    static let connectionTimeout = ApiErrorDto(status: 1000, message: "ConnectionTimeout", error: nil)
    static let unhandledError = ApiErrorDto(status: -9999, message: "UnhandledError", error: nil)
    static let responseParseError = ApiErrorDto(status: 2000, message: "ResponseParseError", error: nil)
    static let errorUnAuthorized = ApiErrorDto(status: 401, message: "Not Authorized.", error: nil)
}

public enum ApiResult<Value> {
    case success(Value)
    case error(ApiErrorDto)
}

class RestClient {
    
    public static let shared = RestClient()
    
    private func responseDecodeableProcessor<T: Decodable>(data: DataResponse<T, AFError>) -> ApiResult<T>? {
        if data.response?.statusCode == 401 {
            return .error(.errorUnAuthorized)
        }
        
        switch data.result {
            case .success(let result): return .success(result)
            case .failure(let afError): do {
                if afError.isSessionTaskError {
                    return .error(.connectionTimeout)
                }
                return .error(ApiErrorDto(status: data.response?.statusCode ?? GeneralErrorCode,
                                          message: data.error?.localizedDescription ?? ""))
            }
        }
    }
    
    private func objectToDict<T: Encodable>(data: T) -> [String:Any]? {
        do {
            let json = try JSONEncoder().encode(data)
            let dictResult = try JSONSerialization.jsonObject(with: json, options: []) as? [String:Any]
            return dictResult
        } catch {
            return nil
        }
    }
    
    private func getAuthHeader() -> HTTPHeaders {
        return [
           "Content-Type": "application/json",
           "Authorization": "Bearer \(Cache.shared.getToken())"
       ]
    }
    
    func request<T: Decodable>(url: String, method: HTTPMethod, param: [String:Any]?, responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60, encoding: ParameterEncoding = JSONEncoding.default) -> DataRequest {
        AF.sessionConfiguration.timeoutIntervalForRequest = timeout
        AF.sessionConfiguration.timeoutIntervalForResource = timeout
        let request = AF.request(url, method: method, parameters: param, encoding: encoding, headers: getAuthHeader())
            .validate(statusCode: 200...300)
            .responseDecodable(of: responseType) { dataResponse in
                debugPrint(dataResponse)
                if let result = self.responseDecodeableProcessor(data: dataResponse) {
                    onComplete(result)
                }
            }
        return request
    }
    
  
    public func get<T: Decodable>(url: String, responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60, encoding: ParameterEncoding = URLEncoding.queryString) -> DataRequest {
        return request(url: url, method: .get, param: nil, responseType: responseType, onComplete: onComplete, timeout: timeout, encoding: encoding)
    }
    
    public func get<T: Decodable, U: Encodable>(url: String, param: U?, responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60, encoding: ParameterEncoding = URLEncoding.queryString) -> DataRequest {
        
        let param = objectToDict(data: param)
        return request(url: url, method: .get, param: param, responseType: responseType, onComplete: onComplete, timeout: timeout, encoding: encoding)
    }
    
    public func get<T: Decodable>(url: String, param: [String:Any], responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60, encoding: ParameterEncoding = URLEncoding.queryString) -> DataRequest {
        return request(url: url, method: .get, param: param, responseType: responseType, onComplete: onComplete, encoding: encoding)
    }
    
    public func post<T: Decodable, U: Encodable>(url: String, param: U?, responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60) -> DataRequest {
        let param = objectToDict(data: param)
        return request(url: url, method: .post, param: param, responseType: responseType, onComplete: onComplete, timeout: timeout)
    }
    
    public func put<T: Decodable, U: Encodable>(url: String, param: U?, responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60) -> DataRequest {
        let param = objectToDict(data: param)
        return request(url: url, method: .put, param: param, responseType: responseType, onComplete: onComplete, timeout: timeout)
    }
    
    public func patch<T: Decodable, U: Encodable>(url: String, param: U?, responseType: T.Type, onComplete: @escaping (ApiResult<T>) -> (), timeout: Double = 60) -> DataRequest {
        let param = objectToDict(data: param)
        return request(url: url, method: .patch, param: param, responseType: responseType, onComplete: onComplete, timeout: timeout)
    }
}
