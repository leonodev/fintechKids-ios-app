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
import FHKDomainTesting
import FHKSupabase

public class ModulesDependencies: FHKDependencies {
    
    @MainActor
    static func register() throws {
        /// Main App (fhkLanguage Depend of Storage)
        /// FHKLanguage
        inject.register(FHKLanguage.self,
                        standard: { .live },
                        preview: { .preview(.es) },
                        testing: { .test }
        )
        
        /// FHKLanguage
        inject.register(FHKLanguageRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )
        
        /// CameraPermission
        inject.register(FHKPermission.self,
                        standard: { .liveCamera },
                        preview: { .preview },
                        testing: { .test }
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
        inject.register(FHKRegisterMembersRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )

        /// Main App / Modules / Home
        inject.register(FHKHomeRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )
                                        
        /// Main App / Modules / Profile
        /// It only changes the flag for the selected language; if you want to view the entire screen in another language, you must change the language in FHKLanguage.
        inject.register(FHKProfileRepository.self,
                        standard: { .live },
                        preview: { .preview(.es) },
                        testing: { .test }
        )
        
        /// Main App / Modules / Members
        let supabaseClientMembers = try makeSupabaseClient()
        inject.register(FHKSupabaseMembers.self,
                        standard: { .live(supabaseClient: supabaseClientMembers) },
                        preview: { .preview },
                        testing: { .test }
        )
        
        // Main App / Modules / Task
        let supabaseClient = try makeSupabaseClient()
        inject.register(FHKSupabaseTask.self,
                        standard: { .live(supabaseClient: supabaseClient) },
                        preview: { .preview },
                        testing: { .test }
        )
        
        inject.register(FHKTasksRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { . test }
        )
        
        // Main App / Modules / Goal
        let supabaseClientGoal = try makeSupabaseClient()
        inject.register(FHKSupabaseGoal.self,
                        standard: { .live(supabaseClient: supabaseClientGoal) },
                        preview: { .preview },
                        testing: { .test }
        )
        
        inject.register(FHKGoalRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test }
        )

        // Main App / Modules / Balance
        let supabaseClientBalance = try makeSupabaseClient()
        inject.register(FHKSupabaseBalance.self,
                        standard: { .live(supabaseClient: supabaseClientBalance) },
                        preview: { .preview },
                        testing: { .test }
        )
       
        inject.register(FHKBalanceRepository.self,
                        standard: { .live },
                        preview: { .preview },
                        testing: { .test },
        )
        
        // Main App / Modules / Rewards
        let supabaseClientRewards = try makeSupabaseClient()
        inject.register(FHKSupabaseRewards.self,
                        standard: { .live(supabaseClient: supabaseClientRewards) },
                        preview: { .preview },
                        testing: { .test }
        )
        
        inject.register(FHKRewardRepository.self,
                        standard: { .live },
                        preview: { .preview(reward: 4)},
                        testing: { .test }
        )
    }
}
