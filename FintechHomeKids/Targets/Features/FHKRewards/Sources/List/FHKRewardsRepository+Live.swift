//
//  FHKRewardsRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/9/26.
//

import Foundation
import FHKDomain
import FLibInjections
import FHKCore
import FLibUtils

public extension FHKRewardRepository {
    
    static var live: Self {
        let cache = RewardLiveCached()
        var rewardsRepository = Self()
        
        rewardsRepository.createReward = { reward in
            try await inject.fhkRewards.createReward(reward)
        }
        
        rewardsRepository.fetchRewards = { emailParent, forceRefresh in
            if let cachedList = await cache.getValidRewardsCache(forceRefresh: forceRefresh) {
                Logger.info("📦 Return Rewards list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting Rewards list from backend")
            let rewardsList = try await inject.fhkRewards.fetchRewards(emailParent)
            await cache.setRewardsCache(rewardsList)
            return rewardsList
        }
        
        rewardsRepository.clearCache = {
            await cache.clearCache()
        }
        
        return rewardsRepository
    }
}

private final actor RewardLiveCached {
    private var rewardsCache: CachedData<[FHKRewardEntity]>?
    
    func getValidRewardsCache(forceRefresh: Bool) async -> [FHKRewardEntity]? {
        guard !forceRefresh, let cache = rewardsCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setRewardsCache(_ list: [FHKRewardEntity]) {
        self.rewardsCache = CachedData(content: list)
    }
    
    func clearCache() async {
        self.rewardsCache = nil
    }
    
}
