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
import FHKDomain

public class Dependencies {
    
    static func registerAll() {
        let deps = DependenciesInjection.shared
        let storageManager = FHKStorageManager(userDefault: FHKUserDefault(),
                                               keychain: FHKKeychainStorage())
        // ------MAIN INJECTIONS------
        
        /// Storage
        deps.set(storageManager, for: FHKStorageManagerProtocol.self)
        
        /// Language ( Depend of Storage)
        deps.set(FHKLanguageManager(), for: (any FHKLanguageManagerProtocol).self)
        
        /// Remote Configuration
        deps.set(FHKRemoteConfigManager(), for: (any FHKRemoteConfigManagerProtocol).self)
        
        /// Analytics
        deps.set(FHKAnalytics(), for: FHKAnalyticsProtocol.self)
        
        /// Security
        deps.set(FHKSecurity(), for: FHKSecurityProtocol.self)
        
        /// Configuration App
        deps.set(FHKConfiguration(), for: (any FHKConfigurationProtocol).self)
        
        // API Services
        deps.set(ServicesAPI(), for: (any ServicesAPIProtocol).self)
        
        // Supabase
        // Here should query country persisted
        deps.set(FHKSupabase(country: .spanish), for: (any FHKSupabaseProtocol).self)
        
        // Supabase Tables
        let client = deps.supabaseManager.getClient()
        deps.set(FHKSupabaseMembers(supabaseClient: client), for: (any FHKSupabaseMembersProtocol).self)
        
        // ------OTHERS INJECTIONS------
        
        /// Camera Permission
        deps.set(CameraPermissionService(), for: (any FHKPermissionProtocol).self)
        
        /// Toast
        deps.set(ToastService(), for: (any FHKToastManagerProtocol).self)
        
        /// Modal
        deps.set(FHKModal(), for: FHKModalProtocol.self)
    }
}
