//
//  DependenciesInjection+Infrastructure.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//


import Foundation
import FLibStorage
import FLibInjections
import FHKCore

public extension DependenciesInjection {
    
    // It only records what lives natively in Infrastructure
    @MainActor
    static func registerInfrastructure() {
        do {
            inject.fhkStorage = .live(userDefault: FHKUserDefault(),
                                      keychain: FHKKeychainStorage())
            inject.fhkSecurity = .live
            inject.fhkRemoteConfig = .live
            inject.fhkAnalitycs = .live
            
            let client = try FHKSupabaseAPI.makeClient()
            inject.fhkAuth = .live(client: client)
        } catch {
            fatalError("❌ Critical error during dependency registration: \(error)")
        }
    }
}
