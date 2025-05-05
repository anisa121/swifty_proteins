//
//  BiometricAuth.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 03.04.2025.
//

import Foundation
import Security
import LocalAuthentication

enum AuthenticationResult {
    case success
    case failure
    case userCancelled
}

protocol BiometricAuthProtocol {
    var isBiometricsSelected: Bool {get set}
    func hasPassword() -> Bool
    func checkPassword(_ password: String?) -> Bool
    func authentication() async -> AuthenticationResult
    func lock()
    var isUnlocked: Bool {get}
}

class BiometricAuth: ObservableObject, BiometricAuthProtocol {
    @Published var isUnlocked = false
    private let keychainPasswordKey = "com.swiftyproteins.userpassword"

    var isBiometricsSelected: Bool {
      get { UserDefaults.standard.bool(forKey: "isBiometricsSelected") }
      set { UserDefaults.standard.set(newValue, forKey: "isBiometricsSelected") }
    }


    func lock() {
        self.isUnlocked = false
    }

    func authentication() async -> AuthenticationResult {
        if isBiometricsSelected == false {
            isBiometricsSelected = true
        }

        let context = LAContext()
        var error: NSError?
        let reason = "Allow to access"

        // Check if biometric authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .failure
        }

        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                ) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            self.isUnlocked = true
                            continuation.resume(returning: .success)
                        } else if let error = authenticationError as? LAError, error.code == .userCancel {
                            // User tapped "Cancel"
                            continuation.resume(returning: .userCancelled)
                        } else {
                            // Other authentication failure (e.g., wrong face, too many attempts)
                            continuation.resume(returning: .failure)
                        }
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
        let appLaunchedBefore = UserDefaults.standard.bool(forKey: "appLaunchedBefore")
        guard appLaunchedBefore else {
            if appLaunchedBefore == false {
                UserDefaults.standard.set(true, forKey: "appLaunchedBefore")
            }
            deletePassword()
            return false
        }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: keychainPasswordKey,
                                    kSecMatchLimit as String: kSecMatchLimitOne]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        return status == errSecSuccess
    }

    @discardableResult
    func deletePassword() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainPasswordKey
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
