//
//  BioViewModel.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import Foundation
import RxSwift
import CryptoSwift

class BioViewModel {
    
    private let repository = DemoRepository()
    
    lazy var liveError: PublishSubject<String> = {
       return PublishSubject()
    }()
    
    lazy var liveLogin: PublishSubject<TokenResponse> = {
       return PublishSubject()
    }()
    
    lazy var liveHandleSharedKey: PublishSubject<SharedKeyResponse> = {
        return PublishSubject()
    }()
    
    func doLogin(_ phoneNumber: String, pin: String) {
        let encryptedPin = pin.md5
        repository.requestToken(TokenRequest(phoneNumber: phoneNumber, pin: encryptedPin), completion: { result in
            switch result {
            case .success(let data):
                Cache.shared.saveToken(data.accessToken)
                self.liveLogin.onNext(data)
            case .error(_):
                self.liveError.onNext("Error")
            }
        })
    }
    
    func doBioLogin(_ phoneNumber: String) {
        // data
        let expiredTime = (NSDate().timeIntervalSince1970 * 1000) + 360000
        let data = BiometricData(expiredTime: expiredTime, phoneNumber: phoneNumber)
        let jsonData = try? JSONEncoder().encode(data).base64EncodedString()
        
        // secret key
        let dataSecretKey = Data.init(base64Encoded: Cache.shared.getKey(), options: .ignoreUnknownCharacters)!
        
        // IV - MjAyNC0wMi0wOCAw
        let IV = "MjAyNC0wMi0wOCAw"
        if let aes = try? AES(key: dataSecretKey.bytes, blockMode: CBC(iv: Array(IV.utf8)), padding: .pkcs5) {
            let aesE = try? aes.encrypt(Array(jsonData!.utf8))
            let encryptedData = Array(aesE!).toBase64()
            
            repository.requestBioToken(TokenBioRequest(phoneNumber: phoneNumber, data: encryptedData), completion: { result in
                switch result {
                case .success(let data):
                    Cache.shared.saveToken(data.accessToken)
                    self.liveLogin.onNext(data)
                case .error(_):
                    self.liveError.onNext("Error")
                }
            })
        }
    }
    
    func doGetSharedKey(_ pin: String) {
        let data = SharedKeyRequest(pin: pin.md5)
        repository.requestGenerateKey(data, completion: { result in
            switch result {
            case .success(let data):
                Cache.shared.saveKey(data.sharedKey)
                self.liveHandleSharedKey.onNext(data)
            case .error(_):
                self.liveError.onNext("Error")
            }
        })
    }
}
