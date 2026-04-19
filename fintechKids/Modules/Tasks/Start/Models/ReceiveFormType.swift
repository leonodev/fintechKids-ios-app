//
//  ReceiveFormType.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/3/26.
//

import FHKDomain

enum ReceiveFormType {
    case sendToSavings
    case changeByRewards
    case assignToGoal
}

public struct CollectRewardModel: Equatable, Hashable {
    let task: TaskEntity
    let receiveRewardType: ReceiveFormType
    let rewardType: WorkType
}
