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
        get { self[(any FHKStorageManagerProtocol).self] }
        set { self[(any FHKStorageManagerProtocol).self] = newValue }
    }
    
    /// (FHKFirebase)
    var firebaseRemoteConfigManager: any FHKRemoteConfigManagerProtocol {
        get { self[(any FHKRemoteConfigManagerProtocol).self] }
        set { self[(any FHKRemoteConfigManagerProtocol).self] = newValue }
    }
    
    var firebaseAnalitycsManager: any FHKAnalyticsProtocol {
        get { self[(any FHKAnalyticsProtocol).self] }
        set { self[(any FHKAnalyticsProtocol).self] = newValue }
    }
    
    /// (FHKSupabase)
    var supabaseManager: any FHKAuthProtocol {
        get { self[(any FHKAuthProtocol).self] }
        set { self[(any FHKAuthProtocol).self] = newValue }
    }
    
    /// (FHKSupabase)
    var supabaseMembersManager: any FHKSupabaseMembersProtocol {
        get { self[(any FHKSupabaseMembersProtocol).self] }
        set { self[(any FHKSupabaseMembersProtocol).self] = newValue }
    }
    
    /// (FHKCore)
    var servicesAPIManager: any FHKServicesAPIProtocol {
        get { self[(any FHKServicesAPIProtocol).self] }
        set { self[(any FHKServicesAPIProtocol).self] = newValue }
    }
    
    // --------- APLICATION LAYER ---------
    /// (FHKAuth)
    var securityManager: any FHKSecurityProtocol {
        get { self[(any FHKSecurityProtocol).self] }
        set { self[(any FHKSecurityProtocol).self] = newValue }
    }
    
    /// (FHKConfig)
    var configManager: any FHKConfigurationProtocol {
        get { self[(any FHKConfigurationProtocol).self] }
        set { self[(any FHKConfigurationProtocol).self] = newValue }
    }
    
    // --------- FOUNDATIONS LAYER ---------
    /// (FHKDesignSystem)
    var modalManager: any FHKModalProtocol {
        get { self[(any FHKModalProtocol).self] }
        set { self[(any FHKModalProtocol).self] = newValue }
    }
    
    // --------- COMPOSITIONS LAYER ---------
    /// (MAIN APP)
    var languageManager: any FHKLanguageManagerProtocol {
        get { self[(any FHKLanguageManagerProtocol).self] }
        set { self[(any FHKLanguageManagerProtocol).self] = newValue }
    }
    
    /// (MAIN APP)
    var toastManager: any FHKToastProtocol {
        get { self[(any FHKToastProtocol).self] }
        set { self[(any FHKToastProtocol).self] = newValue }
    }
    
    /// (MAIN APP)
    var camaraPermissionManager: any FHKPermissionProtocol {
        get { self[(any FHKPermissionProtocol).self] }
        set { self[(any FHKPermissionProtocol).self] = newValue }
    }
    
    /// (MAIN APP) / Modules / Login
    var loginRepository: any FHKLoginRepositoryProtocol {
        get { self[(any FHKLoginRepositoryProtocol).self] }
        set { self[(any FHKLoginRepositoryProtocol).self] = newValue }
    }
    
    /// (MAIN APP) / Modules / Splash
    var splashRepository: any FHKSplashRepositoryProtocol {
        get { self[(any FHKSplashRepositoryProtocol).self] }
        set { self[(any FHKSplashRepositoryProtocol).self] = newValue }
    }
    
    /// (MAIN APP) / Modules / Register
    var registerRepository: any RegisterRepositoryProtocol {
        get { self[(any RegisterRepositoryProtocol).self] }
        set { self[(any RegisterRepositoryProtocol).self] = newValue }
    }
    
    /// (MAIN APP) / Modules / RegisterMember
    var registerMembersRepository: any FHKRegisterMembersRepositoryProtocol {
        get { self[(any FHKRegisterMembersRepositoryProtocol).self] }
        set { self[(any FHKRegisterMembersRepositoryProtocol).self] = newValue }
    }

    /// (MAIN APP) / Modules / Home
    var homeRepository: any FHKHomeRepositoryProtocol {
        get { self[(any FHKHomeRepositoryProtocol).self] }
        set { self[(any FHKHomeRepositoryProtocol).self] = newValue }
    }
    
    /// (MAIN APP) / Modules / Language
    var languageRepository: any FHKLanguageRepositoryProtocol {
        get { self[(any FHKLanguageRepositoryProtocol).self] }
        set { self[(any FHKLanguageRepositoryProtocol).self] = newValue }
    }
}
