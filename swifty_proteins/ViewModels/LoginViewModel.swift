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
    @State private var task: Task<Void, Never>?

    var biometricAuth: BiometricAuthProtocol

    init(biometricAuth: BiometricAuthProtocol) {
        self.biometricAuth = biometricAuth
        viewFlow()
    }

    func viewFlow() {
        if biometricAuth.hasPassword() == false && biometricAuth.isBiometricsSelected == false {
            showPasswordSetup = true
            return
        }
        if biometricAuth.isUnlocked {
          navigateToMain = true
          return
        }
        if biometricAuth.isBiometricsSelected {
            self.task = Task {
                let result = await biometricAuth.authentication()
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.navigateToMain = true
                    }
                case .failure, .userCancelled:
                    task?.cancel()
                    return
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
                switch success {
                case .success:
                    self.navigateToMain = true
                case .failure, .userCancelled:
                    return
                }
            }
        }
    }

    func handleScenePhase(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            if navigateToMain == false,
               let value = UserDefaults().value(forKey: "appWasInBackground") as? Bool,
               value {
                UserDefaults().set(false, forKey: "appWasInBackground")
                viewFlow()
            }
        case .background:
            UserDefaults().set(true, forKey: "appWasInBackground")
            DispatchQueue.main.async {
                self.biometricAuth.lock()
                self.navigateToMain = false
            }
        default:
            break
        }
    }
}
