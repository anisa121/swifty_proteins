//
//  swifty_proteinsApp.swift
//  swifty_proteins
//
//  Created by Anisa Kapateva on 04.11.2024.
//

import SwiftUI

@main
struct swifty_proteinsApp: App {
    @StateObject private var biometricAuth = BiometricAuth()
        @Environment(\.scenePhase) private var scenePhase
        
    var body: some Scene {
            WindowGroup {
                if biometricAuth.isUnlocked {
                    MainView()
                        .environmentObject(biometricAuth)
                } else {
                    LoginView()
                        .environmentObject(biometricAuth)
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .background || newPhase == .inactive {
                    biometricAuth.isUnlocked = false
                }
            }
        }
}
