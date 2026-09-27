//
//  FHKRewardReceivedEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

public enum ReceiveFormType: Sendable {
    case sendToSavings
    case changeByRewards
    case assignToGoal
}

public struct FHKRewardReceivedEntity: Sendable, Equatable, Hashable {
    public let task: FHKTaskEntity
    public let receiveRewardType: ReceiveFormType
    public let rewardType: FHKWorkType
    
    public init(task: FHKTaskEntity,
                receiveRewardType:
                ReceiveFormType,
                rewardType: FHKWorkType
    ) {
        self.task = task
        self.receiveRewardType = receiveRewardType
        self.rewardType = rewardType
    }
}

#if DEBUG
public extension FHKRewardReceivedEntity {
    
    static var previewItemCoinAsignedToGoal: Self {
        FHKRewardReceivedEntity(task: FHKTaskEntity.previewItem,
                                receiveRewardType: .assignToGoal,
                                rewardType: .coins)
    }
    
    static var previewItemCoinChangeByRewards: Self {
        FHKRewardReceivedEntity(task: FHKTaskEntity.previewItem,
                                receiveRewardType: .changeByRewards,
                                rewardType: .coins)
    }
    
    static var previewItemCoinSaveSavings: Self {
        FHKRewardReceivedEntity(task: FHKTaskEntity.previewItem,
                                receiveRewardType: .sendToSavings,
                                rewardType: .coins)
    }
    
    static var previewItemTimeAsignedToGoal: Self {
        FHKRewardReceivedEntity(task: FHKTaskEntity.previewItem,
                                receiveRewardType: .assignToGoal,
                                rewardType: .time)
    }
    
    static var previewItemTimeChangeByRewards: Self {
        FHKRewardReceivedEntity(task: FHKTaskEntity.previewItem,
                                receiveRewardType: .changeByRewards,
                                rewardType: .time)
    }
    
    static var previewItemTimeSaveSavings: Self {
        FHKRewardReceivedEntity(task: FHKTaskEntity.previewItem,
                                receiveRewardType: .sendToSavings,
                                rewardType: .time)
    }
    
}
#endif
