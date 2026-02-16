//
//  Dependencies+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import FHKInjections
import FHKUtils
import FHKConfig
import FHKDesignSystem
import FHKObservability
import FHKStorage
import FHKAuth

public class Dependencies {
    
    static func registerAll() {
        let deps = DependenciesInjection.shared
        
        // implementatios to inject here
        
        /// Configuration
        deps.set(FHKRemoteConfigManager(), for: (any FHKConfigManagerProtocol).self)
        
        /// Language
        deps.set(FHKLanguageManager(), for: (any FHKLanguageManagerProtocol).self)
        
        /// Camera Permission
        deps.set(CameraPermissionService(), for: PermissionProtocol.self)
        
        /// Toast
        deps.set(ToastService(), for: ToastServiceProtocol.self)
        
        /// Modal
        deps.set(FHKModal(), for: FHKModalProtocol.self)
        
        /// Analytics
        deps.set(FHKAnalytics(), for: FHKAnalyticsProtocol.self)
        
        /// Storage
        deps.set(FHKStorageManager(userDefault: FHKUserDefault(),
                                   keychain: FHKKeychainStorage()), for: FHKStorageManagerProtocol.self)
        
        /// Security
        deps.set(FHKSecurity(), for: FHKSecurityProtocol.self)
  
        Logger.info("All dependencies registered successfully")
    }
}
