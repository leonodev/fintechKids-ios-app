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
        let storageManager = FHKStorageManager(userDefault: FHKUserDefault(),
                                               keychain: FHKKeychainStorage())
        
        /// FHKStorage
        deps.set(storageManager, for: FHKStorageManagerProtocol.self)

        /// FHKFirebase
        deps.set(FHKRemoteConfigService(), for: (any FHKRemoteConfigManagerProtocol).self)
        
        /// FHKFirebase
        deps.set(FHKAnalyticsService(), for: FHKAnalyticsProtocol.self)
        
        /// FHKAuth
        deps.set(FHKSecurity(), for: FHKSecurityProtocol.self)
        
        /// FHKConfig
        deps.set(FHKConfiguration(), for: (any FHKConfigurationProtocol).self)
        
        // FHKCore
        deps.set(FHKServicesAPI(), for: (any FHKServicesAPIProtocol).self)
           
        // FHKAuth
        let supabaseClient = try makeSupabaseClient()
        deps.set(FHKSupabase(client: supabaseClient), for: (any FHKAuthProtocol).self)
        
        // FHKSupabase
        deps.set(FHKSupabaseMembers(supabaseClient: supabaseClient), for: (any FHKSupabaseMembersProtocol).self)
        
        /// FHKDesignSystem
        deps.set(FHKModal(), for: FHKModalProtocol.self)
        
        /// Main App
        deps.set(ToastService(), for: (any FHKToastProtocol).self)
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
