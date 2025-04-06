//
//  LoginView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 03.04.2025.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject private var biometricAuth = BiometricAuth()
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
                if biometricAuth.hasPassword() {
                    SecureField("Enter the password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: 200)
                    Button("Login") {
                        if biometricAuth.checkPassword(password) {
                            biometricAuth.isUnlocked = true
                        } else {
                            showAlert = true
                        }
                    }
                    Button("Use Biometrics") {
                        biometricAuth.authentication()
                    }
                } else {
                    Button("Set Password") {
                        showPasswordSetupView = true
                    }
                    .padding()
                    Button("Use Biometrics") {
                        biometricAuth.authentication()
                    }
                    .padding()
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
                MainView(biometricAuth: biometricAuth)
                    .onDisappear() {
                        biometricAuth.isUnlocked = false
                    }
            }
            .sheet(isPresented: $showPasswordSetupView) {
                PasswordSetupView(biometricAuth: biometricAuth)
                
            }
            .onAppear() {
                navigateToMainView = false
            }
            .onChange(of: biometricAuth.isUnlocked) { oldValue, newValue in
                if newValue {
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
