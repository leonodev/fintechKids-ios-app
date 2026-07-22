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
    
    @MainActor
    static func register() throws {
        /// Main App (fhkLanguage Depend of Storage)
        /// FHKLanguage
        inject.register(FHKLanguage.self,
                        standard: { .live },
                        preview: { .english },
                        testing: { .test }
        )
        
        /// FHKLanguage
        inject.register((any FHKLanguageRepositoryProtocol).self,
                        standard: { LanguageRepository() }
        )
        
        /// CameraPermissionService
        inject.register((any FHKPermissionProtocol).self,
        standard: { CameraPermissionService() }
        )
    
        /// Main App / Modules / Login
        inject.register(FHKLoginRepository.self,
                        standard: { .live },
                        testing: { .test }
        )
        
        /// Main App / Modules / Splash
        inject.register(FHKSplashRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )
        
        /// Main App / Modules / Register
        inject.register(FHKRegisterRepository.self,
                        standard: { .live },
                        testing: { .test }
        )
        
        /// Main App / Modules / Register Members
        inject.register((any FHKRegisterMembersRepositoryProtocol).self,
                        standard: { RegisterMembersRepository() }
        )

        /// Main App / Modules / Home
        inject.register((any FHKHomeRepositoryProtocol).self,
                        standard: { HomeRepository() }
        )
                                        
        /// Main App / Modules / Profile
        inject.register((any FHKProfileRepositoryProtocol).self,
                        standard: { ProfileRepository() }
        )
        
        /// Main App / Modules / Members
        let supabaseClientMembers = try makeSupabaseClient()
        inject.register((any FHKSupabaseMembersProtocol).self,
                        standard: { FHKSupabaseMembers(supabaseClient: supabaseClientMembers) }
        )
        
        // Main App / Modules / Task
        let supabaseClient = try makeSupabaseClient()
        inject.register((any FHKSupabaseTaskProtocol).self,
                        standard: { FHKSupabaseTask(supabaseClient: supabaseClient) }
        )
        
        inject.register((any FHKTasksRepositoryProtocol).self,
                        standard: { TasksRepository() }
        )
        
        // Main App / Modules / Goal
        let supabaseClientGoal = try makeSupabaseClient()
        inject.register((any FHKSupabaseGoalProtocol).self,
                        standard: { FHKSupabaseGoals(supabaseClient: supabaseClientGoal) }
        )
        
        inject.register((any FHKGoalRepositoryProtocol).self,
                        standard: { GoalRepository() }
        )

        // Main App / Modules / Balance
        let supabaseClientBalance = try makeSupabaseClient()
        inject.register((any FHKSupabaseBalanceProtocol).self,
                        standard: { FHKSupabaseBalance(supabaseClient: supabaseClientBalance) }
        )
       
        inject.register((any FHKBalanceRepositoryProtocol).self,
                        standard: { BalanceRepository() }
        )
        
        // Main App / Modules / Rewards
        let supabaseClientRewards = try makeSupabaseClient()
        inject.register((any FHKSupabaseRewardsProtocol).self,
                        standard: { FHKSupabaseRewards(supabaseClient: supabaseClientRewards) }
        )
        
        inject.register((any FHKRewardRepositoryProtocol).self,
                        standard: { RewardCollectRepository() }
        )
    }
}
