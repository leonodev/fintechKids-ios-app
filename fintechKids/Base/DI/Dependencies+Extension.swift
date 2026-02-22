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
import FHKCore
import Supabase

public class Dependencies {
    
    static func mainDependencies() {
        let deps = DependenciesInjection.shared
        let storageManager = FHKStorageManager(userDefault: FHKUserDefault(),
                                               keychain: FHKKeychainStorage())
        // implementatios to inject here
     
        /// Storage
        deps.set(storageManager, for: FHKStorageManagerProtocol.self)
        
        /// Language ( Depend of Storage)
        deps.set(FHKLanguageManager(), for: (any FHKLanguageManagerProtocol).self)
        
        /// Remote Configuration
        deps.set(FHKRemoteConfigManager(), for: (any FHKConfigManagerProtocol).self)
        
        /// Analytics
        deps.set(FHKAnalytics(), for: FHKAnalyticsProtocol.self)
        
        /// Security
        deps.set(FHKSecurity(), for: FHKSecurityProtocol.self)
        
        /// Configuration App
        deps.set(FHKConfiguration(storageManager: deps.storageManager),
                 for: (any FHKConfigurationProtocol).self)
        
        // API Services
        deps.set(ServicesAPI(), for: (any ServicesAPIProtocol).self)
        
        // Supabase
        deps.set(FHKSupabase(), for: (any FHKSupabaseProtocol).self)
        let currentSupabase = deps.supabaseManager
        let client = currentSupabase.client
        deps.set(FHKSupabaseMembers(supabaseClient: client), for: (any FHKSupabaseMembersProtocol).self)
        

        Logger.info("Main dependencies registered successfully")
    }
    
    static func otherDependencies() {
        let deps = DependenciesInjection.shared
        
        /// Camera Permission
        deps.set(CameraPermissionService(), for: PermissionProtocol.self)
        
        /// Toast
        deps.set(ToastService(), for: ToastServiceProtocol.self)
        
        /// Modal
        deps.set(FHKModal(), for: FHKModalProtocol.self)
        
        Logger.info("Other dependencies registered successfully")
    }
}
