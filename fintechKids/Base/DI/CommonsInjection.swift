//
//  ModalInjections.swift
//  fintechKids
//
//  Created by Fredy Leon on 26/1/26.
//

import FHKDesignSystem
import FHKInjections
import FHKObservability
import FHKConfig
import FHKStorage
import FHKAuth

public extension DependenciesInjection {
    
    var remoteConfigManager: any FHKConfigManagerProtocol {
        get { self[(any FHKConfigManagerProtocol).self] }
        set { self[(any FHKConfigManagerProtocol).self] = newValue }
    }
    
    var modalManager: any FHKModalProtocol {
        get { self[(any FHKModalProtocol).self] }
        set { self[(any FHKModalProtocol).self] = newValue }
    }
    
    var analitycsManager: any FHKAnalyticsProtocol {
        get { self[(any FHKAnalyticsProtocol).self] }
        set { self[(any FHKAnalyticsProtocol).self] = newValue }
    }
    
    var languageManager: any FHKLanguageManagerProtocol {
        get { self[(any FHKLanguageManagerProtocol).self] }
        set { self[(any FHKLanguageManagerProtocol).self] = newValue }
    }
    
    var storagemanager: any FHKStorageManagerProtocol {
        get { self[(any FHKStorageManagerProtocol).self] }
        set { self[(any FHKStorageManagerProtocol).self] = newValue }
    }
    
    var securitymanager: any FHKSecurityProtocol {
        get { self[(any FHKSecurityProtocol).self] }
        set { self[(any FHKSecurityProtocol).self] = newValue }
    }
}
