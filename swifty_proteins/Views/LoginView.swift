//
//  LoginView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 03.04.2025.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var biometricAuth: BiometricAuth
    @Environment(\.scenePhase) private var scenePhase
    @State private var showPasswordSetupView = false
    @State private var password = ""
    @State var navigateToMainView = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Please login to continue")
                    .font(.headline)
                    .padding()
                if biometricAuth.isBiometricsSelected {
                    Text("Welcome!")
                } else {
                    if biometricAuth.hasPassword() {
                        SecureField("Enter the password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(maxWidth: 200)
                        Button("Login") {
                            if biometricAuth.checkPassword(password) {
                                biometricAuth.isUnlocked = true
                                password = ""
                            } else {
                                showAlert = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Button("Use Biometrics") {
                            biometricAuth.authentication()
                        }
                        .padding()
                    } else {
                        Button("Set Password") {
                            showPasswordSetupView = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Button("Use Biometrics") {
                            biometricAuth.authentication()
                        }
                        .padding()
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    showAlert.toggle()
                    password = ""
                }
            } message: {
                Text("Wrong password")
            }
            .navigationDestination(isPresented: $navigateToMainView) {
                MainView()
                    .environmentObject(biometricAuth)
            }
            .sheet(isPresented: $showPasswordSetupView) {
                PasswordSetupView(biometricAuth: biometricAuth)
            }
            .onAppear() {
                password = ""
                navigateToMainView = false
            }
            .onChange(of: scenePhase) { _, scenePhase in
                if scenePhase == .active,
                   biometricAuth.isBiometricsSelected {
                    biometricAuth.authentication()
                }
            }
            .onChange(of: biometricAuth.isUnlocked) { _, isUnlocked in
                if isUnlocked {
                    navigateToMainView = true
                    password = ""
                }
            }
        }

    }
}

#Preview {
    LoginView()
}
