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
    static func registerInfrastructure() {
        inject.fhkStorage = .live(userDefault: FHKUserDefault(),
                                  keychain: FHKKeychainStorage())
        inject.fhkSecurity = .live
    }
}
