//
//  RewardCollectRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/4/26.
//

import FHKDomain
import FHKInjections
import FHKStorage
import FHKCore
import FHKUtils

final actor RewardCollectRepository: FHKRewardRepositoryProtocol {
    
    // Properties injected
    private var fhkSupabaseReward: any FHKSupabaseRewardsProtocol {
        inject.fhkSupabaseRewards
    }
    
    private var rewardsCache: CachedData<[RewardEntity]>?
    
    func createReward(reward: RewardEntity) async throws {
        try await fhkSupabaseReward.createReward(reward: reward)
    }
    
    func fetchRewards(emailParent: String, forceRefresh: Bool) async throws -> [RewardEntity] {
        if !forceRefresh, let cache = rewardsCache, await !cache.isExpired() {
            Logger.info("📦 Return rewards list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting reward list from backend")
        let rewardList = try await fhkSupabaseReward.fetchRewards(emailParent: emailParent)
        
        self.rewardsCache = CachedData(content: rewardList)
        return rewardList
    }
    
    func clearCache() async {
        self.rewardsCache = nil
    }
}
