//
//  FHKBalanceRemainingEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

import Foundation

public struct FHKBalanceRemainingEntity: Equatable {
    public let memberId: UUID
    public let collectReward: FHKRewardReceivedEntity
    public let goal: FHKGoalEntity
    
    public init(
        memberId: UUID,
        collectReward: FHKRewardReceivedEntity,
        goal: FHKGoalEntity
    ) {
        self.memberId = memberId
        self.collectReward = collectReward
        self.goal = goal
    }
}
