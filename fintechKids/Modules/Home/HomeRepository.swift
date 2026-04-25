//
//  HomeRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage
import FHKCore
import FHKUtils

final actor HomeRepository: FHKHomeRepositoryProtocol {
    
    // Properties Injection
    private var fhkSupabaseMembers: FHKSupabaseMembersProtocol {
        inject.fhkSupabaseMembers
    }
    
    private var fhkSupabaseRewards: FHKSupabaseRewardsProtocol {
        inject.fhkSupabaseRewards
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var membersCache: CachedData<[MemberEntity]>?
    private var rewardCollectedCache: CachedData<[RewardCollectedEntity]>?
    
    func fetchMembers(email: String, forceRefresh: Bool) async throws -> [MemberEntity] {
        if !forceRefresh, let cache = membersCache, await !cache.isExpired() {
            Logger.info("📦 Return Members list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting Members list from backend")
        let membersList = try await fhkSupabaseMembers.fetchFamilyMembers(parentEmail: email)
        
        self.membersCache = CachedData(content: membersList)
        return membersList
    }
    
    func fetchRewardCollected(parentEmail: String, forceRefresh: Bool) async throws -> [RewardCollectedEntity] {
        if !forceRefresh, let cache = rewardCollectedCache, await !cache.isExpired() {
            Logger.info("📦 Return Reward Collected list cached")
            return cache.content
        }
        Logger.info("🌐 Getting Reward Collected list from backend")
        let rewardCollectedList =  try await fhkSupabaseRewards.fetchRewardCollected(parentEmail: parentEmail)
        
        self.rewardCollectedCache = CachedData(content: rewardCollectedList)
        
        return rewardCollectedList
    }
    
    public func getParentMail() async -> String? {
        fhkConfiguration.parentMail
    }
}
