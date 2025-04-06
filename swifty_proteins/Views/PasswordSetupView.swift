//
//  PasswordSetupView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.04.2025.
//

import SwiftUI

struct PasswordSetupView: View {
    @State private var password: String = ""
    @State private var confirmPassword = ""
    @StateObject private var biometricAuth: BiometricAuth
    @State private var showError = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Setup your new password")
                .padding(.top)
                .font(.title)
                .padding()
            SecureField("Enter the password", text: $password)
                .padding()
            SecureField("Confirm the password", text: $confirmPassword)
                .padding()
            Button("Submit") {
                if password == confirmPassword {
                    if biometricAuth.setPassword(password) {
                        biometricAuth.isUnlocked = true
                        dismiss()
                    } else {
                        showError = true
                    }
                } else {
                    showError = true
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {
                password = ""
                confirmPassword = ""
            }
        } message: {
            Text("Please make sure passwords match and fields are not empty")
        }
    }
    
    init(biometricAuth: BiometricAuth) {
        self._biometricAuth = StateObject(wrappedValue: biometricAuth)
    }
}

