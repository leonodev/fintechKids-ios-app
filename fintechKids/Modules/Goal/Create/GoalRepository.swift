//
//  GoalRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 15/3/26.
//

import Foundation
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
    private var goalsMemberFamilyCache: CachedData<[GoalMemberEntity]>?
    
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
    
    func fetchGoalMember(memberId: UUID, forceRefresh: Bool) async throws -> [GoalMemberEntity] {
        if !forceRefresh, let cache = goalsMemberCache, await !cache.isExpired() {
            Logger.info("📦 Return goals member list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting goal member list from backend")
        let goalMemberList = try await fhkSupabaseGoal.fetchGoalMember(memberId: memberId)
        
        self.goalsMemberCache = CachedData(content: goalMemberList)
        return goalMemberList
    }
    
    func fetchGoalMemberFamily(emailParent: String, forceRefresh: Bool) async throws -> [GoalMemberEntity] {
        if !forceRefresh, let cache = goalsMemberFamilyCache, await !cache.isExpired() {
            Logger.info("📦 Return goals member family list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting goal member family list from backend")
        let goalMemberFamilyList = try await fhkSupabaseGoal.fetchGoalMemberFamily(emailParent: emailParent)
        
        self.goalsMemberFamilyCache = CachedData(content: goalMemberFamilyList)
        return goalMemberFamilyList
    }
    
    func clearCache() async {
        self.goalsCache = nil
    }
}
