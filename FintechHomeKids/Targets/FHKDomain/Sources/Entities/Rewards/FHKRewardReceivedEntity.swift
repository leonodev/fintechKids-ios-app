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
