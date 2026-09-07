//
//  FHKRewardsEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import FLibInjections

// MARK: - Contract
public struct FHKRewards: Sendable {
    public var createReward:
    @Sendable(FHKRewardEntity) async throws -> Void = { _ in }
    
    public var fetchRewards:
    @Sendable(String) async throws -> [FHKRewardEntity] = { _ in [] }
    
    public var fetchRewardCollected:
    @Sendable(String) async throws -> [FHKRewardCollectedEntity] = { _ in [] }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkRewards: FHKRewards {
        get { get(FHKRewards.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKRewards.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKRewards {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        return preview
    }
}

#endif

