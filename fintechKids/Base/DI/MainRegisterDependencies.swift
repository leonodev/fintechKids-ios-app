//
//  MainRegisterDependencies.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import Foundation
import Supabase
import FHKInjections
import FHKConfig
import FHKFirebase
import FHKStorage
import FHKAuth
import FHKCore
import FHKDomain
import FHKSupabase

public class CommonsDependencies {
    
    static func register() throws {
        let storage = FHKStorageManager(userDefault: FHKUserDefault(),
                                        keychain: FHKKeychainStorage())
        
        /// FHKStorage
        inject.fhkStorage = storage

        /// FHKFirebase
        inject.fhkFirebaseRemoteConfig = FHKRemoteConfigService()
        inject.fhkFirebaseAnalitycs = FHKAnalyticsService()
        
        /// FHKAuth
        inject.fhkSecurity = FHKSecurity()
        
        /// FHKConfig
        inject.fhkConfiguration = FHKConfiguration()
        
        // FHKCore
        inject.fhkServicesAPI = FHKServicesAPI()
           
        // FHKAuth
        let supabaseClient = try makeSupabaseClient()
        inject.fhkSupabase = FHKSupabase(client: supabaseClient)
        
        // FHKSupabase
        inject.fhkSupabaseMembers = FHKSupabaseMembers(supabaseClient: supabaseClient)
        
        /// FHKDesignSystem
        inject.fhkModal = FHKModal()
        
        /// Main App
        inject.fhkToast = ToastService()
    }
}

extension CommonsDependencies {
    
    static func makeSupabaseClient() throws -> SupabaseClient {
        let urlString = try inject.fhkServicesAPI.getURL(
            environment: .production,
            country: .spanish,
            serviceKey: .supabase
        )

        guard let url = URL(string: urlString) else {
            throw SupabaseError.invalidURL(urlString)
        }

        let anonKey = try inject.fhkSecurity.getAnonKey()
        return SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }
}
