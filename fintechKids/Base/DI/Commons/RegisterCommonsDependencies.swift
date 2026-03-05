//
//  CommonsDependencies+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import FHKInjections
import FHKUtils
import FHKConfig
import FHKDesignSystem
import FHKFirebase
import FHKStorage
import FHKAuth
import FHKCore
import Supabase
import FHKDomain
import FHKSupabase

public class CommonsDependencies {
    
    static func register() throws {
        let deps = DependenciesInjection.shared
        
        let storage = FHKStorageManager(userDefault: FHKUserDefault(),
                                        keychain: FHKKeychainStorage())
        
        /// FHKStorage
        deps[\.storageManager] = storage

        /// FHKFirebase
        deps[\.firebaseRemoteConfigManager] = FHKRemoteConfigService()
        
        /// FHKFirebase
        deps[\.firebaseAnalitycsManager] = FHKAnalyticsService()
        
        /// FHKAuth
        deps[\.securityManager] = FHKSecurity()
        
        /// FHKConfig
        deps[\.configManager] = FHKConfiguration()
        
        // FHKCore
        deps[\.servicesAPIManager] = FHKServicesAPI()
           
        // FHKAuth
        let supabaseClient = try makeSupabaseClient()
        deps[\.supabaseManager] = FHKSupabase(client: supabaseClient)
        
        // FHKSupabase
        deps[\.supabaseMembersManager] = FHKSupabaseMembers(supabaseClient: supabaseClient)
        
        /// FHKDesignSystem
        deps[\.modalManager] = FHKModal()
        
        /// Main App
        deps[\.toastManager] = ToastService()
    }
}

extension CommonsDependencies {
    
    static func makeSupabaseClient() throws -> SupabaseClient {
        let deps = DependenciesInjection.shared

        let urlString = try deps.servicesAPIManager.getURL(
            environment: .production,
            country: .spanish,
            serviceKey: .supabase
        )

        guard let url = URL(string: urlString) else {
            throw SupabaseError.invalidURL(urlString)
        }

        let anonKey = try deps.securityManager.getAnonKey()

        return SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }
}
