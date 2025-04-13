//
//  BiometricAuth.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 03.04.2025.
//

import Foundation
import Security
import LocalAuthentication

class BiometricAuth: ObservableObject {
    @Published var isUnlocked = false
    private let keychainPasswordKey = "com.swiftyproteins.userpassword"
    
    func authentication() {
        let context = LAContext()
        var error: NSError?
        let reason = "Allow to access"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    }
                }
            }
        }
    }
    
    func setPassword(_ password: String) -> Bool {
        let passwordData = password.data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecValueData as String: passwordData,
                                       kSecAttrAccount as String: keychainPasswordKey]
        let status = SecItemAdd(addquery as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func checkPassword(_ password: String? = nil) -> Bool {
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: keychainPasswordKey,
                                       kSecReturnData as String: true]
        var item: AnyObject?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let savedPassword = String(data: data, encoding: .utf8),
              let password = password else {
            return false
        }
        return savedPassword == password
    }
    
    func hasPassword() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: keychainPasswordKey,
                                    kSecMatchLimit as String: kSecMatchLimitOne]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        return status == errSecSuccess
    }
    
    func deletePassword() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainPasswordKey
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
