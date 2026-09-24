//
//  FHKRewardRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKRewardRepository: Sendable {
    public var createReward:
    @Sendable(FHKRewardEntity) async throws -> Void = { _ in }
    
    
    public var fetchRewards:
    @Sendable(String, Bool) async throws -> [FHKRewardEntity] = { _, _ in [] }
    
    public var clearCache: @Sendable() async -> Void = { }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkRewardRepository: FHKRewardRepository {
        get { get(FHKRewardRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKRewardRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKRewardRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.createReward = { _ in }
        
        preview.fetchRewards = { _, _ in
            FHKRewardEntity.previewItem(2)
        }
        
        preview.clearCache = { }
        
        return preview
    }
}
#endif
