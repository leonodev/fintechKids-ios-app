//
//  FHKHomeRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import FHKDomain
import FHKCore
import FLibInjections
import FLibUtils

public extension FHKHomeRepository {
    
    static var live: Self {
        let cache = HomeLiveCached()
        var repository = Self()
        
        repository.fetchMembers = { email, forceRefresh in
            // first ckeck if exist data in cache
            if let cachedList = await cache.getValidMembersCache(forceRefresh: forceRefresh) {
                Logger.info("📦 Return Members list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting Members list from backend")
            let membersList = try await inject.fhkMembers.fetchFamilyMembers(email)
            await cache.setMembersCache(membersList)
            return membersList
        }

        repository.fetchRewardCollected = { email, forceRefresh in
            // first ckeck if exist data in cache
            if let cachedList = await cache.getValidRewardsCache(forceRefresh: forceRefresh) {
                Logger.info("📦 Return Reward Collected list cached")
                return cachedList
            }
            
            Logger.info("🌐 Getting Reward Collected list from backend")
            let rewardCollectedList =  try await inject.fhkRewards.fetchRewardCollected(email)
            await cache.setRewardsCache(rewardCollectedList)
            return rewardCollectedList
        }
        
        repository.getParentMail = {
            inject.fhkConfiguration.parentMail()
        }
        
        return repository
    }
}

private final actor HomeLiveCached {
    var membersCache: CachedData<[FHKMemberEntity]>?
    var rewardCollectedCache: CachedData<[FHKRewardCollectedEntity]>?
    
    func getValidMembersCache(forceRefresh: Bool) async -> [FHKMemberEntity]? {
        guard !forceRefresh, let cache = membersCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setMembersCache(_ list: [FHKMemberEntity]) {
        self.membersCache = CachedData(content: list)
    }
    
    func getValidRewardsCache(forceRefresh: Bool) async -> [FHKRewardCollectedEntity]? {
        guard !forceRefresh, let cache = rewardCollectedCache, await !cache.isExpired() else {
            return nil
        }
        return cache.content
    }
    
    func setRewardsCache(_ list: [FHKRewardCollectedEntity]) {
        self.rewardCollectedCache = CachedData(content: list)
    }
}
