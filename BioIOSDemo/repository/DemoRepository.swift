//
//  DemoRepository.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import Foundation

class DemoRepository {
    
    //let baseUrl = "http://10.0.2.2:8181/"
    let baseUrl = "http://192.168.18.162:8181/"
    
    func requestToken(_ request: TokenRequest, completion: @escaping(ApiResult<TokenResponse>) -> Void) {
        let stringUrl = "\(baseUrl)auth/token"
        let _ = RestClient.shared.post(url: stringUrl,
                                     param: request,
                                     responseType: TokenResponse.self,
                                     onComplete: completion)
    }
    
    func requestBioToken(_ request: TokenBioRequest, completion: @escaping(ApiResult<TokenResponse>) -> Void) {
        let stringUrl = "\(baseUrl)auth/biometric"
        let _ = RestClient.shared.post(url: stringUrl,
                                     param: request,
                                     responseType: TokenResponse.self,
                                     onComplete: completion)
    }
    
    func requestGenerateKey(_ request: SharedKeyRequest, completion: @escaping(ApiResult<SharedKeyResponse>) -> Void) {
        let stringUrl = "\(baseUrl)auth/biometric/sharedkey"
        let _ = RestClient.shared.patch(url: stringUrl, param: request,
                                        responseType: SharedKeyResponse.self,
                                        onComplete: completion)
    }
}
