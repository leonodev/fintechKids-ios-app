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
    private var goalsMemberCache: CachedData<[GoalMemberEntity]>?
    
    func createGoal(goal: GoalEntity) async throws {
        try await fhkSupabaseGoal.createGoal(goal: goal)
    }
    
    func getGoals(emailParent: String, forceRefresh: Bool) async throws -> [GoalEntity] {
        if !forceRefresh, let cache = goalsCache, await !cache.isExpired() {
            Logger.info("📦 Return goal list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting goal list from backend")
        let goalList = try await fhkSupabaseGoal.getGoals(emailParent: emailParent)
        
        self.goalsCache = CachedData(content: goalList)
        return goalList
    }
    
    func createGoalMember(goal: GoalMemberEntity) async throws {
        try await fhkSupabaseGoal.createGoalMember(goal: goal)
    }
    
    func fetchGoalMember(member: MemberEntity, forceRefresh: Bool) async throws -> [GoalMemberEntity] {
        if !forceRefresh, let cache = goalsMemberCache, await !cache.isExpired() {
            Logger.info("📦 Return goals member list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting goal member list from backend")
        let goalMemberList = try await fhkSupabaseGoal.fetchGoalMember(member: member)
        
        self.goalsMemberCache = CachedData(content: goalMemberList)
        return goalMemberList
    }
    
    func clearCache() async {
        self.goalsCache = nil
    }
}
