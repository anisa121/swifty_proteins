//
//  LoginView.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 03.04.2025.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
     let authService: BiometricAuth
    @Environment(\.scenePhase) private var scenePhase

      init() {
          let service = BiometricAuth()
          authService = service
          _viewModel = StateObject(wrappedValue: LoginViewModel(biometricAuth: service))
      }

      var body: some View {
        NavigationStack {
          VStack(spacing: 16) {
            Text("Please login to continue")
                  .font(.headline)

            if viewModel.showPasswordSetup {
                FirstLoginView(viewModel: viewModel)
            }
            else {
                CredentialsLoginView(viewModel: viewModel)
            }
          }
          .padding()
          .alert("Error", isPresented: $viewModel.showAlert) {
              Button("OK", role: .cancel) { viewModel.password = "" }
          } message: {
            Text("Wrong password")
          }
          .navigationDestination(isPresented: $viewModel.navigateToMain) {
              MainView().environmentObject(viewModel.biometricAuth as! BiometricAuth)
          }
        }
        .onChange(of: scenePhase) { viewModel.handleScenePhase($0) }
        .sheet(isPresented: $viewModel.showPasswordSetup) {
            PasswordSetupView(biometricAuth: authService)
        }
      }
}

struct FirstLoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        VStack(spacing: 16) {
            Button("Set Password") {
                viewModel.showPasswordSetup = true
            }
              .buttonStyle(.borderedProminent)
              Button("Use Biometrics") { viewModel.useBiometricsTapped() }
          }
        }
}

struct CredentialsLoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        VStack(spacing: 16) {
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 200)
            Button("Login") { viewModel.loginTapped() }
                .buttonStyle(.borderedProminent)
            Button("Use Biometrics") { viewModel.useBiometricsTapped() }
        }
    }
}

#Preview {
    LoginView()
}
