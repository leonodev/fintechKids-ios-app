//
//  ModulesRegisterDependencies.swift
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
        /// Main App (fhkLanguage Depend of Storage)
        inject.fhkLanguage = FHKLanguageManager()
        inject.fhkCameraPermission = CameraPermissionService()
        
        /// Main App / Modules / Login
        inject.fhkLoginRepository = LoginRepository()
        
        /// Main App / Modules / Splash
        inject.fhkSplashRepository = SplashRepository()
        
        /// Main App / Modules / Register
        inject.fhkRegisterRepository = RegisterRepository()
        
        /// Main App / Modules / Register Members
        inject.fhkRegisterMembersRepository = RegisterMembersRepository()

        /// Main App / Modules / Home
        inject.fhkHomeRepository = HomeRepository()
        
        /// Main App / Modules / Profile
        inject.fhkProfileRepository = ProfileRepository()
    }
}
