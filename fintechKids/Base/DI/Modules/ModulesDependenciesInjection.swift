//
//  FeaturesInjections.swift
//  fintechKids
//
//  Created by Fredy Leon on 4/3/26.
//

import FHKInjections
import FHKDomain
import FHKDesignSystem
import FHKCore

/// (MAIN APP)
public extension DependenciesInjection {
    
    /// Modules / Language
    var languageManager: any FHKLanguageManagerProtocol {
        get { get((any FHKLanguageManagerProtocol).self) }
        set { set(newValue, for: (any FHKLanguageManagerProtocol).self) }
    }
    
    var languageRepository: any FHKLanguageRepositoryProtocol {
        get { get((any FHKLanguageRepositoryProtocol).self) }
        set { set(newValue, for: (any FHKLanguageRepositoryProtocol).self) }
    }
    
    /// Modules / Login
    var loginRepository: any FHKLoginRepositoryProtocol {
        get { get((any FHKLoginRepositoryProtocol).self) }
        set { set(newValue, for: (any FHKLoginRepositoryProtocol).self) }
    }
    
    /// Modules / Splash
    var splashRepository: any FHKSplashRepositoryProtocol {
        get { get((any FHKSplashRepositoryProtocol).self) }
        set { set(newValue, for: (any FHKSplashRepositoryProtocol).self) }
    }
    
    /// Modules / Register
    var registerRepository: any RegisterRepositoryProtocol {
        get { get((any RegisterRepositoryProtocol).self) }
        set { set(newValue, for: (any RegisterRepositoryProtocol).self) }
    }
    
    /// Modules / RegisterMember
    var registerMembersRepository: any FHKRegisterMembersRepositoryProtocol {
        get { get((any FHKRegisterMembersRepositoryProtocol).self) }
        set { set(newValue, for: (any FHKRegisterMembersRepositoryProtocol).self) }
    }

    /// Modules / Home
    var homeRepository: any FHKHomeRepositoryProtocol {
        get { get((any FHKHomeRepositoryProtocol).self) }
        set { set(newValue, for: (any FHKHomeRepositoryProtocol).self) }
    }
}
