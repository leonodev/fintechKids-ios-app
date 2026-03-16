//
//  GoalRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 15/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage
import FHKCore
import FHKUtils

final actor GoalRepository: FHKGoalRepositoryProtocol {
    
    // Properties injected
    private var fhkSupabaseGoal: any FHKSupabaseGoalProtocol {
        inject.fhkSupabaseGoal
    }
    
    private var goalsCache: CachedData<[GoalEntity]>?
    
    func createGoal(goal: FHKDomain.GoalEntity) async throws {
        try await fhkSupabaseGoal.createGoal(goal: goal)
    }
    
    func getGoal(emailParent: String, forceRefresh: Bool) async throws -> [GoalEntity] {
        if !forceRefresh, let cache = goalsCache, await !cache.isExpired() {
            Logger.info("📦 Return goal list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting goal list from backend")
        let goalList = try await fhkSupabaseGoal.getGoals(emailParent: emailParent)
        
        self.goalsCache = CachedData(content: goalList)
        return goalList
    }
    
    func clearCache() async {
        self.goalsCache = nil
    }
}
