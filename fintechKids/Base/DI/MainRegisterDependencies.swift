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
    
    @MainActor
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
        
        // Creamos la configuración nativa de Apple
        let configuration = URLSessionConfiguration.default
        // peticiones de trafico de cada paquete
        configuration.timeoutIntervalForRequest = 10.0
        
        // para respuestas completas
        configuration.timeoutIntervalForResource = 30.0
        
        // Creamos la sesión con esa configuración
        let customSession = URLSession(configuration: configuration)
        
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
        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey,
            options: SupabaseClientOptions(
                db: .init(schema: "public"),
                auth: .init(
                    autoRefreshToken: true
                ),
                global: .init(
                    session: customSession
                )
            )
        )
    }
}
