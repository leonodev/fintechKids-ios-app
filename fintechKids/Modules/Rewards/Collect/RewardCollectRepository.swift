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

public extension FHKRewardRepository {
    
    static var live: Self {
        var repository = Self()
        let rewardCollet = RewardCollectRepository()
        
        repository.createReward = { reward in
            try await rewardCollet.createReward(reward: reward)
        }
        
        repository.fetchRewards = { emailParent, forceRefresh in
            try await rewardCollet.fetchRewards(emailParent: emailParent, forceRefresh: forceRefresh)
        }
        
        repository.clearCache = {
            await rewardCollet.clearCache()
        }
        
        return repository
    }
}

private final actor RewardCollectRepository {
    private var rewardsCache: CachedData<[RewardEntity]>?
    
    func createReward(reward: RewardEntity) async throws {
        try await inject.fhkSupabaseRewards.createReward(reward)
    }
    
    func fetchRewards(emailParent: String, forceRefresh: Bool) async throws -> [RewardEntity] {
        if !forceRefresh, let cache = rewardsCache, await !cache.isExpired() {
            Logger.info("📦 Return rewards list cached")
            return cache.content
        }
        
        Logger.info("🌐 Getting reward list from backend")
        let rewardList = try await inject.fhkSupabaseRewards.fetchRewards(emailParent)
        
        self.rewardsCache = CachedData(content: rewardList)
        return rewardList
    }
    
    func clearCache() async {
        self.rewardsCache = nil
    }
}
