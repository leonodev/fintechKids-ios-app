//
//  AppDelegate.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/12/25.
//

import SwiftUI
import FirebaseCore
import FHKConfig

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
    private func setupConfig() {
        
#if DEBUG
        Configuration.setEnvironment(.develop)
#else
        Configuration.setEnvironment(.production)
#endif
     
    }
}
