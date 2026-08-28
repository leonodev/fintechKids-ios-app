//
//  FHKFirebaseRemoteService.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import Foundation
import UIKit
import FHKCore
import FirebaseCore
import FirebaseRemoteConfig
import FirebaseCrashlytics
import FHKInfrastructure
import FLibUtils

final class FHKFirebaseRemoteService: NSObject, ApplicationService {
    
    // Encapsulado como propiedad de instancia; se evalúa post-configure()
    private lazy var remoteConfig = RemoteConfig.remoteConfig()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            fetchRemoteConfig()
            Logger.info("FirebaseApp configured")
        } else {
            Logger.info("FirebaseApp already initialized")
        }

#if DEBUG
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
#else
    // Siempre activado para los usuarios reales
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
#endif
        return true
    }
    
    private func fetchRemoteConfig() {
        #if DEBUG
        let expirationDuration: TimeInterval = 0
        #else
        let expirationDuration: TimeInterval = 3600
        #endif

        Task { @MainActor in
            do {
                let status = try await remoteConfig.fetch(withExpirationDuration: expirationDuration)
                if status == .success {
                    try await remoteConfig.activate()
                    Logger.info("Got the value from remote config Firebase status \(status)")
                }
            } catch {
                Logger.error("Remote Config fetch failed: \(error.localizedDescription)")
            }
        }
    }
}
