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
import FHKDomainTesting
import FHKSupabase

public class FHKBasicDependencies {
    
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
                        preview: { .preview },
                        testing: { .test }
        )
        
        /// FHKFirebase
        inject.register(FHKRemoteConfig.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )

        /// FHKAuth
        inject.register(FHKAnalytics.self,
                        standard: { .live },
                        testing: { .test }
        )
        
        // FHKAuth
        let supabaseClient = try FHKAPIClientFactory.makeSupabaseClient()
        inject.register(FHKAuth.self,
                        standard: { .live(client: supabaseClient) },
                        testing: { .test }
        )
        
        /// FHKDesignSystem
        inject.register(FHKModal.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: {.test }
        )
        
        /// Main App
        inject.register(FHKToast.self,
                        standard: { .live }
        )

        /// Session Manager User
        inject.register(FHKSession.self,
                        standard: { .live },
                        testing: {.test }
        )
    }
}
