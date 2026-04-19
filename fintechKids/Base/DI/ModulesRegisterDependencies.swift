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

public class ModulesDependencies: FHKDependencies {
    
    static func register() throws {
        
        /// Main App (fhkLanguage Depend of Storage)
        inject.fhkLanguage = FHKLanguageManager()
        inject.fhkLanguageRepository = LanguageRepository()
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
        
        /// Main App / Modules / Members
        let supabaseClient = try makeSupabaseClient()
        inject.fhkSupabaseMembers = FHKSupabaseMembers(supabaseClient: supabaseClient)
        
        // Main App / Modules / Task
        inject.fhkSupabaseTask = FHKSupabaseTask(supabaseClient: supabaseClient)
        inject.fhkTasksRepository = TasksRepository()
        
        // Main App / Modules / Goal
        inject.fhkSupabaseGoal = FHKSupabaseGoals(supabaseClient: supabaseClient)
        inject.fhkGoalsRepository = GoalRepository()
        
        // Main App / Modules / Balance
        inject.fhkSupabaseBalance = FHKSupabaseBalance(supabaseClient: supabaseClient)
        inject.fhkBalanceRepository = BalanceRepository()
        
        // Main App / Modules / Rewards
        inject.fhkSupabaseRewards = FHKSupabaseRewards(supabaseClient: supabaseClient)
        inject.fhkRewardsRepository = RewardCollectRepository()
    }
}
