//
//  FHKRewardsEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//


public struct FHKRewards: Sendable {
    public var createReward:
    @Sendable(FHKRewardEntity) async throws -> Void = { _ in }
    
    public var fetchRewards:
    @Sendable(String) async throws -> [FHKRewardEntity] = { _ in [] }
    
    public var fetchRewardCollected:
    @Sendable(String) async throws -> [FHKRewardCollectedEntity] = { _ in [] }
    
    public init() {}
}
