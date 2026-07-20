//
//  AppDelegate.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/12/25.
//

import SwiftUI
import FirebaseCore
import FHKConfig
import FHKUtils
import FHKCore

class AppDelegate: ServicesApplicationDelegate {
    
    // Register services from here!
    override var services: [ApplicationService] {
        [
            FirebaseRemoteService(),
            PushNotificationService(),
            CameraPermissionService(),
            ToastService()
        ]
    }
   
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        do {
            try CommonsDependencies.register()
            try ModulesDependencies.register()
            Logger.info("All dependencies registered successfully")
        } catch {
            fatalError("❌ Critical error during dependency registration: \(error)")
        }
        
        let servicesResult = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        Logger.info("All Services Registered => \(servicesResult)")
        return true
    }
}
