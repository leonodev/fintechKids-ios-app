//
//  FHKAppDelegate.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI
import FHKAuth
import FHKCore
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
        DependenciesInjection.registerCore()
        DependenciesInjection.registerInfrastructure()
        DependenciesInjection.registerDesignSystem()
        DependenciesInjection.registerMainApp()
        DependenciesInjection.registerAuthFeature()
        DependenciesInjection.registerDomain()
        
        let servicesResult = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        Logger.info("All Services Registered => \(servicesResult)")
        return true
    }
}
