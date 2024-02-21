//
//  Cache.swift
//  BioIOSDemo
//
//  Created by yohanes saputra on 20/02/24.
//

import Foundation

class Cache {
    
    public static let shared = Cache()
    
    func saveToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    func getToken() -> String {
        return UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    func saveKey(_ key: String) {
        UserDefaults.standard.setValue(key, forKey: "shared_key")
    }
    
    func getKey() -> String {
        return UserDefaults.standard.value(forKey: "shared_key") as? String ?? ""
    }
}
