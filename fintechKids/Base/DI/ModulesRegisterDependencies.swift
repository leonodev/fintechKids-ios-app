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
        let supabaseClientMembers = try makeSupabaseClient()
        inject.fhkSupabaseMembers = FHKSupabaseMembers(supabaseClient: supabaseClientMembers)
        
        // Main App / Modules / Task
        let supabaseClient = try makeSupabaseClient()
        inject.fhkSupabaseTask = FHKSupabaseTask(supabaseClient: supabaseClient)
        inject.fhkTasksRepository = TasksRepository()
        
        // Main App / Modules / Goal
        let supabaseClientGoal = try makeSupabaseClient()
        inject.fhkSupabaseGoal = FHKSupabaseGoals(supabaseClient: supabaseClientGoal)
        inject.fhkGoalsRepository = GoalRepository()
        
        // Main App / Modules / Balance
        let supabaseClientBalance = try makeSupabaseClient()
        inject.fhkSupabaseBalance = FHKSupabaseBalance(supabaseClient: supabaseClientBalance)
        inject.fhkBalanceRepository = BalanceRepository()
        
        // Main App / Modules / Rewards
        let supabaseClientRewards = try makeSupabaseClient()
        inject.fhkSupabaseRewards = FHKSupabaseRewards(supabaseClient: supabaseClientRewards)
        inject.fhkRewardsRepository = RewardCollectRepository()
    }
}
