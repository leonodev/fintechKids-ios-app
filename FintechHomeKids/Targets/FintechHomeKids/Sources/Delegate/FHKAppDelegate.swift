//
//  FHKAppDelegate.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI
import FHKAuth
import FHKHome
import FHKCore
import FHKInfrastructure
import FLibUtils
import FLibStorage
import FLibInjections

class FHKAppDelegate: ServicesApplicationDelegate {
    
    override var services: [ApplicationService] {
        [
            FHKFirebaseRemoteService(),
            FHKToastService()
        ]
    }
   
    @MainActor
    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
       
        
        // Centralized injection of live variants
        DICompositionRoot.configure()
        
        let servicesResult = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        Logger.info("All Services Registered => \(servicesResult)")
        return true
    }
}
