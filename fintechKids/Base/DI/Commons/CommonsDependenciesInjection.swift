//
//  CommonsInjection.swift
//  fintechKids
//
//  Created by Fredy Leon on 26/1/26.
//

import FHKInjections
import FHKDomain
import FHKDesignSystem
import FHKCore

public extension DependenciesInjection {
 
    // --------- INFRAESTRUCTURE LAYER ---------
    /// (FHKStorage)
    var storageManager: any FHKStorageManagerProtocol {
        get { get((any FHKStorageManagerProtocol).self) }
        set { set(newValue, for: (any FHKStorageManagerProtocol).self) }
    }
    
    /// (FHKFirebase)
    var firebaseRemoteConfigManager: any FHKRemoteConfigManagerProtocol {
        get { get((any FHKRemoteConfigManagerProtocol).self) }
        set { set(newValue, for: (any FHKRemoteConfigManagerProtocol).self) }
    }
    
    var firebaseAnalitycsManager: any FHKAnalyticsProtocol {
        get { get((any FHKAnalyticsProtocol).self) }
        set { set(newValue, for: (any FHKAnalyticsProtocol).self) }
    }
    
    /// (FHKSupabase)
    var supabaseManager: any FHKAuthProtocol {
        get { get((any FHKAuthProtocol).self) }
        set { set(newValue, for: (any FHKAuthProtocol).self) }
    }
    
    /// (FHKSupabase)
    var supabaseMembersManager: any FHKSupabaseMembersProtocol {
        get { get((any FHKSupabaseMembersProtocol).self) }
        set { set(newValue, for: (any FHKSupabaseMembersProtocol).self) }
    }
    
    /// (FHKCore)
    var servicesAPIManager: any FHKServicesAPIProtocol {
        get { get((any FHKServicesAPIProtocol).self) }
        set { set(newValue, for: (any FHKServicesAPIProtocol).self) }
    }
    
    /// (FHKAuth)
    var securityManager: any FHKSecurityProtocol {
        get { get((any FHKSecurityProtocol).self) }
        set { set(newValue, for: (any FHKSecurityProtocol).self) }
    }
    
    /// (FHKConfig)
    var configManager: any FHKConfigurationProtocol {
        get { get((any FHKConfigurationProtocol).self) }
        set { set(newValue, for: (any FHKConfigurationProtocol).self) }
    }
    
    /// (FHKDesignSystem)
    var modalManager: any FHKModalProtocol {
        get { get((any FHKModalProtocol).self) }
        set { set(newValue, for: (any FHKModalProtocol).self) }
    }
    
    /// (MAIN APP)
    var toastManager: any FHKToastProtocol {
        get { get((any FHKToastProtocol).self) }
        set { set(newValue, for: (any FHKToastProtocol).self) }
    }
    
    /// (MAIN APP)
    var camaraPermissionManager: any FHKPermissionProtocol {
        get { get((any FHKPermissionProtocol).self) }
        set { set(newValue, for: (any FHKPermissionProtocol).self) }
    }
}
