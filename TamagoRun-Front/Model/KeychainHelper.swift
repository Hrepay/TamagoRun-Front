//
//  KeychainHelper.swift
//  TamagoRun-Front
//
//  Created by 황상환 on 9/23/24.
//

import Foundation

class KeychainHelper {
    static let standard = KeychainHelper()
    
    private init() {}
    
    // Keychain에 데이터 저장
    func save(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ] as CFDictionary
            
            // 기존 데이터를 먼저 삭제
            SecItemDelete(query)
            
            // 새로운 데이터 저장
            let status = SecItemAdd(query, nil)
            
            if status != errSecSuccess {
                print("Failed to save data to Keychain with status: \(status)")
            }
        }
    }
    
    // Keychain에서 데이터 불러오기
    func read(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        
        return nil
    }
    
    // Keychain에서 데이터 삭제
    func delete(forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        if status != errSecSuccess {
            print("Failed to delete data from Keychain with status: \(status)")
        }
    }
}
