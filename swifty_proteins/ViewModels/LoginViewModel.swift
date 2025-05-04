//
//  LoginViewModel.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 26.04.2025.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var showPasswordSetup = false
    @Published var showAlert = false
    @Published var navigateToMain = false

    var biometricAuth: BiometricAuthProtocol

    init(biometricAuth: BiometricAuthProtocol) {
        self.biometricAuth = biometricAuth
        viewFlow()
    }

    func viewFlow() {
        if !biometricAuth.hasPassword() && !biometricAuth.isBiometricsSelected {
            showPasswordSetup = true
            return
        }
        if biometricAuth.isUnlocked {
          navigateToMain = true
          return
        }
        if biometricAuth.isBiometricsSelected {
            Task {
                let success = await biometricAuth.authentication()
                if success {
                    DispatchQueue.main.async {
                        self.navigateToMain = true
                    }
                }
            }
        }
    }

    func loginTapped() {
        if biometricAuth.checkPassword(password) {
            DispatchQueue.main.async {
                self.navigateToMain = true
                self.password = ""
            }
        } else {
            showAlert = true
        }
    }

    func useBiometricsTapped() {
        biometricAuth.isBiometricsSelected = true
        Task {
            let success = await biometricAuth.authentication()
            await MainActor.run {
                if success {
                    self.navigateToMain = true
                }
            }
        }
    }

    func handleScenePhase(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active where navigateToMain == false:
            viewFlow()
        case .background:
            DispatchQueue.main.async {
                self.biometricAuth.lock()
                self.navigateToMain = false
            }
        default:
            break
        }
    }
}
