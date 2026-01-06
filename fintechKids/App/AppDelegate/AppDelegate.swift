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
            PushNotificationService()
        ]
    }
   
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let servicesResult = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        Logger.info("All Services Registered => \(servicesResult)")
        
        Dependencies.registerAll()
        Logger.info("All Injection Values Success")
        return true
    }
}
