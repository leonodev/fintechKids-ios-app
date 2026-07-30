//
//  FHKAppDelegate.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/12/25.
//

import SwiftUI
import FirebaseCore
import FHKConfig
import FHKUtils
import FHKCore

class FHKAppDelegate: ServicesApplicationDelegate {
    
    // Register services from here!
    override var services: [ApplicationService] {
        [
            FHKFirebaseRemoteService(),
            FHKPushNotificationService(),
            FHKToastService()
        ]
    }
   
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        do {
            try FHKBasicDependencies.register()
            try FHKModulesDependencies.register()
            Logger.info("All dependencies registered successfully")
        } catch {
            fatalError("❌ Critical error during dependency registration: \(error)")
        }
        
        let servicesResult = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        Logger.info("All Services Registered => \(servicesResult)")
        return true
    }
}
