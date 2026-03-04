//
//  RegisterFeaturesDependencies.swift
//  fintechKids
//
//  Created by Fredy Leon on 4/3/26.
//


import Foundation
import FHKInjections
import FHKUtils
import FHKConfig
import FHKDesignSystem
import FHKFirebase
import FHKStorage
import FHKAuth
import FHKCore
import Supabase
import FHKDomain
import FHKSupabase

public class ModulesDependencies {
    
    static func register() throws {
        let deps = DependenciesInjection.shared
        
        /// Main App ( Depend of Storage)
        deps.set(FHKLanguageManager(), for: (any FHKLanguageManagerProtocol).self)
        
        /// Main App
        deps.set(CameraPermissionService(), for: (any FHKPermissionProtocol).self)
        
        /// Main App  / Modules / Login
        deps.set(LoginRepository(), for: (any FHKLoginRepositoryProtocol).self)
        
        /// Main App  / Modules / Splash
        deps.set(SplashRepository(), for: (any FHKSplashRepositoryProtocol).self)
        
        /// Main App  / Modules / Register
        deps.set(RegisterRepository(), for: (any RegisterRepositoryProtocol).self)
        
        /// Main App  / Modules / Register Members
        deps.set(RegisterMembersRepository(), for: (any FHKRegisterMembersRepositoryProtocol).self)

        /// Main App  / Modules / Home
        deps.set(HomeRepository(), for: (any FHKHomeRepositoryProtocol).self)
        
        /// Main App  / Modules / Language
        deps.set(LanguageRepository(), for: (any FHKLanguageRepositoryProtocol).self) 
    }
}
