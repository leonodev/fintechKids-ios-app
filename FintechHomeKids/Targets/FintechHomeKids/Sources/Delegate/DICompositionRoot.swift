//
//  DICompositionRoot.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 7/9/26.
//

import Foundation
import FHKAuth
import FHKHome
import FHKCore
import FHKInfrastructure
import FLibStorage
import FLibInjections

@MainActor
enum DICompositionRoot {
    
    static func configure() {
        registerCore()
        registerServices()
        registerFeatures()
    }
    
    // MARK: - Core & Storage
    private static func registerCore() {
        inject.fhkStorage = .live(
            userDefault: FHKUserDefault(),
            keychain: FHKKeychainStorage()
        )
        inject.fhkEnvironment = .live
        inject.fhkSecurity = .live
        inject.fhkRemoteConfig = .live
        inject.fhkAnalitycs = .live
        inject.fhkConfiguration = .live
        inject.fhkLanguage = .live
    }
    
    // MARK: - External Services & Supabase
    private static func registerServices() {
        do {
            let client = try FHKSupabaseAPI.makeClient()
            
            inject.fhkAuth = .live(client: client)
            inject.fhkRewards = .live(supabaseClient: client)
            inject.fhkMembers = .live(supabaseClient: client)
            inject.fhkGoal = .live(supabaseClient: client)
        } catch {
            fatalError("❌ Critical error during dependency registration: \(error)")
        }
    }
    
    // MARK: - Features
    private static func registerFeatures() {
        inject.fhkHomeRepository = .live
        inject.fhkSplashRepository = .live
        inject.fhkLanguageRepository = .live
        inject.fhkLoginRepository = .live
        inject.fhkRegisterRepository = .live
        inject.fhkGoalsRepository = .live
    }
}
