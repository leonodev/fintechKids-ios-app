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
        get { self[(any FHKLanguageManagerProtocol).self] }
        set { self[(any FHKLanguageManagerProtocol).self] = newValue }
    }
    
    var languageRepository: any FHKLanguageRepositoryProtocol {
        get { self[(any FHKLanguageRepositoryProtocol).self] }
        set { self[(any FHKLanguageRepositoryProtocol).self] = newValue }
    }
    
    /// Modules / Login
    var loginRepository: any FHKLoginRepositoryProtocol {
        get { self[(any FHKLoginRepositoryProtocol).self] }
        set { self[(any FHKLoginRepositoryProtocol).self] = newValue }
    }
    
    /// Modules / Splash
    var splashRepository: any FHKSplashRepositoryProtocol {
        get { self[(any FHKSplashRepositoryProtocol).self] }
        set { self[(any FHKSplashRepositoryProtocol).self] = newValue }
    }
    
    /// Modules / Register
    var registerRepository: any RegisterRepositoryProtocol {
        get { self[(any RegisterRepositoryProtocol).self] }
        set { self[(any RegisterRepositoryProtocol).self] = newValue }
    }
    
    /// Modules / RegisterMember
    var registerMembersRepository: any FHKRegisterMembersRepositoryProtocol {
        get { self[(any FHKRegisterMembersRepositoryProtocol).self] }
        set { self[(any FHKRegisterMembersRepositoryProtocol).self] = newValue }
    }

    /// Modules / Home
    var homeRepository: any FHKHomeRepositoryProtocol {
        get { self[(any FHKHomeRepositoryProtocol).self] }
        set { self[(any FHKHomeRepositoryProtocol).self] = newValue }
    }
}
