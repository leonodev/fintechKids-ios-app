//
//  FHKGoalRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKDomain
import FLibInjections
import FHKCore
import FLibUtils

public extension FHKGoalRepository {
    
    static var live: Self {
        let cache = GoalsLiveCached()
        var goalsRepository = Self()
        
        /// Goals
        goalsRepository.createGoal = { goal in
            try await inject.fhkGoal.createGoal(goal)
        }
        
        goalsRepository.getGoals = { emailParent, isForceRefresh in
            if let cachedList = await cache.getValidGoalsCache(forceRefresh: isForceRefresh) {
                Logger.info("📦 Return Goals list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting Goals list from backend")
            let goalList = try await inject.fhkGoal.getGoals(emailParent)
            await cache.setGoalsCache(goalList)
            return goalList
        }
        
        /// Member
        goalsRepository.createGoalMember = { goalMember in
            try await inject.fhkGoal.createGoalMember(goalMember)
        }
        
        goalsRepository.fetchGoalMember = { memberId, isForceRefresh in
            if let cachedList = await cache.getValidMemberCache(forceRefresh: isForceRefresh) {
                Logger.info("📦 Return Goal Member list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting Goal Member from backend")
            let memberList = try await inject.fhkGoal.fetchGoalMember(memberId)
            await cache.setMemberCache(memberList)
            return memberList
        }
        
        /// Member Family
        goalsRepository.fetchGoalMemberFamily = { emailParent, isForceRefresh in
            if let cachedList = await cache.getValidMemberFamilyCache(forceRefresh: isForceRefresh) {
                Logger.info("📦 Return Goal Member list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting goal member family list from backend")
            let goalMemberFamilyList = try await inject.fhkGoal.fetchGoalMemberFamily(emailParent)
            await cache.setMemberFamilyCache(goalMemberFamilyList)
            return goalMemberFamilyList
        }
        
        goalsRepository.clearCache = {
            await cache.clearCache()
        }
        
        return goalsRepository
    }
}

private final actor GoalsLiveCached {
    var goalsCache: CachedData<[FHKGoalEntity]>?
    var goalsMemberCache: CachedData<[FHKGoalMemberEntity]>?
    var goalsMemberFamilyCache: CachedData<[FHKGoalMemberEntity]>?
    
    /// Goals
    func getValidGoalsCache(forceRefresh: Bool) async -> [FHKGoalEntity]? {
        guard !forceRefresh, let cache = goalsCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setGoalsCache(_ list: [FHKGoalEntity]) {
        self.goalsCache = CachedData(content: list)
    }
    
    /// Member
    func getValidMemberCache(forceRefresh: Bool) async -> [FHKGoalMemberEntity]? {
        guard !forceRefresh, let cache = goalsMemberCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setMemberCache(_ list: [FHKGoalMemberEntity]) {
        self.goalsMemberCache = CachedData(content: list)
    }
    
    /// Member Family
    func getValidMemberFamilyCache(forceRefresh: Bool) async -> [FHKGoalMemberEntity]? {
        guard !forceRefresh, let cache = goalsMemberFamilyCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setMemberFamilyCache(_ list: [FHKGoalMemberEntity]) {
        self.goalsMemberFamilyCache = CachedData(content: list)
    }
    
    func clearCache() async {
        self.goalsMemberFamilyCache = nil
        self.goalsMemberCache = nil
        self.goalsCache = nil
    }
}
