//
//  PasswordSetupView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.04.2025.
//

import SwiftUI

struct PasswordSetupView: View {
    @ObservedObject var biometricAuth: BiometricAuth
    @State private var password: String = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Setup your new password")
                .padding(.top)
                .font(.title)

            SecureField("Enter the password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("Confirm the password", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

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
}

