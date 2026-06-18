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

public class CommonsDependencies: FHKDependencies {
    
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
        
        /// FHKDesignSystem
        inject.fhkModal = FHKModal()
        
        /// Main App
        inject.fhkToast = ToastService()
        
        /// Session Manager User
        inject.fhkSessionManager = FHKSessionManager()
    }
}

public class FHKDependencies {
    static func makeSupabaseClient(_ environment: EnvironmentType = .production) throws -> SupabaseClient {
        let urlString: String
        
        if environment == .localhost {
            urlString = "http://localhost:3001"
        } else {
            urlString = try inject.fhkServicesAPI.getURL(
                environment: environment,
                country: .spanish,
                serviceKey: .supabase
            )
        }
 
        guard let url = URL(string: urlString) else {
            throw FHKAppError.invalidURL(urlString)
        }
        
        let anonKey = try inject.fhkSecurity.getAnonKey()
        return SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }
}
