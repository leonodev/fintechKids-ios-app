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
        // Register Base dependencies
        
        /// FHKServicesAPI
        inject.register(FHKServices.self,
                        standard: { .live },
                        testing: { .test }
        )
        
        /// FHKSecurity
        inject.register(FHKSecurity.self,
                        standard: { .live },
                        testing: { .test }
        )
        
        /// FHKStorage
        inject.register(FHKStorageManager.self,
                        standard: { .live(userDefault: FHKUserDefault(), keychain: FHKKeychainStorage()) },
                        testing: { .test }
        )
        
        /// FHKConfiguration
        inject.register(FHKConfiguration.self,
                        standard: { .live },
                        testing: { .test }
        )
        
        /// FHKFirebase
        inject.register(FHKRemoteConfig.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )

        /// FHKAuth
        inject.register((any FHKAnalyticsProtocol).self,
                        standard: { FHKAnalyticsService() }
        )
        
        // FHKAuth
        let supabaseClient = try makeSupabaseClient()
        inject.register((any FHKAuthProtocol).self,
                        standard: { FHKSupabase(client: supabaseClient) }
        )
        
        /// FHKDesignSystem
        inject.register((any FHKModalProtocol).self,
                        standard: { FHKModal() }
        )
        
        /// Main App
        inject.register(FHKToast.self,
                        standard: { .live }
        )

        /// Session Manager User
        inject.register((any FHKSessionManagerProtocol).self,
                        standard: { FHKSessionManager() }
        )
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
            urlString = try inject.fhkServicesAPI.getURL(environment, .spanish, .supabase)
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
