//
//  fintechKidsApp.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKCore
import FHKInjections

@main
struct fintechKidsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Inject(\.languageManager) private var langManager
    
    init() {
        Dependencies.registerAll()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationContainer<Routes, SplashScreen> {
                SplashScreen()
            }
            .onAppear {
                Task { await langManager.readLanguage() }
            }
        }
    }
}
