//
//  BioDemoDto.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import Foundation

struct TokenRequest: Codable {
    let phoneNumber: String
    let pin: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case pin
    }
}

struct TokenBioRequest: Codable {
    let phoneNumber: String
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case data
    }
}

struct BiometricData: Codable {
    let expiredTime: Double
    let phoneNumber: String
    enum CodingKeys: String, CodingKey {
        case expiredTime = "expired_time"
        case phoneNumber = "phone_number"
    }
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct SharedKeyRequest: Codable {
    let pin: String
    enum CodingKeys: String, CodingKey {
        case pin
    }
}

struct SharedKeyResponse: Codable {
    let sharedKey: String
    
    enum CodingKeys: String, CodingKey {
        case sharedKey = "shared_key"
    }
}
