//
//  FirebaseService.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseRemoteConfig
import FHKUtils
import FHKCore

var remoteConfig = RemoteConfig.remoteConfig()

final class FirebaseRemoteService: NSObject, ApplicationService {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            fetchRemoteConfig()
        }

        return true
    }
    
    private func fetchRemoteConfig() {
        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            guard error == nil else { return }
            Logger.info("Got the value from remote config Firebase status \(status)")
            remoteConfig.activate()
        }
    }
}
