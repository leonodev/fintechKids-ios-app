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
        
        /// Main App (Depend of Storage)
        deps[\.languageManager] = FHKLanguageManager()
        
        /// Main App
        deps[\.camaraPermissionManager] = CameraPermissionService()
        
        /// Main App / Modules / Login
        deps[\.loginRepository] = LoginRepository()
        
        /// Main App / Modules / Splash
        deps[\.splashRepository] = SplashRepository()
        
        /// Main App / Modules / Register
        deps[\.registerRepository] = RegisterRepository()
        
        /// Main App / Modules / Register Members
        deps[\.registerMembersRepository] = RegisterMembersRepository()

        /// Main App / Modules / Home
        deps[\.homeRepository] = HomeRepository()
        
        /// Main App / Modules / Language
        deps[\.languageRepository] = LanguageRepository()
    }
}
