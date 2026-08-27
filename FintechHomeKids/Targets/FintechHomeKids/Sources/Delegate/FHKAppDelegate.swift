//
//  FHKAppDelegate.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI
import FHKAuth
import FLibUtils
import FLibStorage

class FHKAppDelegate: ServicesApplicationDelegate {
    
    override var services: [ApplicationService] {
        [
            //FirebaseRemoteService(),
            //PushNotificationService(),
            //FHKToastService()
        ]
    }
   
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        do {
            try FHKBaseDependencies.register()
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
