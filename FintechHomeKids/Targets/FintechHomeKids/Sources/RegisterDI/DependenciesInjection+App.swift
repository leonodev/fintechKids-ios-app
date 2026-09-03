//
//  DependenciesInjection+App.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain
import FHKInfrastructure

public extension DependenciesInjection {
    
    var fhkSession: FHKSession {
        get { get(FHKSession.self) }
        set { set(newValue, for: FHKSession.self) }
    }
    
    var fhkLanguage: FHKLanguage {
        get { get(FHKLanguage.self) }
        set { set(newValue, for: FHKLanguage.self) }
    }
    
    var fhkRemoteConfig: FHKRemoteConfig {
        get { get(FHKRemoteConfig.self) }
        set { set(newValue, for: FHKRemoteConfig.self) }
    }
    
    var fhkAnalitycs: FHKAnalytics {
        get { get(FHKAnalytics.self) }
        set { set(newValue, for: FHKAnalytics.self) }
    }
    
    var fhkAuth: FHKAuth {
        get { get(FHKAuth.self) }
        set { set(newValue, for: FHKAuth.self) }
    }
    
    // It only records what lives natively in Main App
    @MainActor
    static func registerMainApp() {
        do {
            inject.fhkSession = .live
            inject.fhkLanguage = .live
            inject.fhkRemoteConfig = .live
            inject.fhkAnalitycs = .live
            
            let client = try FHKSupabaseAPI.makeClient()
            inject.fhkAuth = .live(client: client)
        } catch {
            fatalError("❌ Critical error during dependency registration: \(error)")
        }
    }
}
