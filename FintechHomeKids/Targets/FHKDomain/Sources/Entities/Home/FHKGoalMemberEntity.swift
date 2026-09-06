//
//  FHKGoalMemberEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKCore

public struct FHKGoalMemberEntity: DomainModelProtocol {
    public let id: UUID = UUID()
    public let goalId: Int
    public let nameGoal: String
    public let memberId: UUID
    public let accumulatedValue: Int
    public let taskWinnedValue: Int
    public let rewardsSystemType: String
    public let rewardsSystemValue: Int
    public let parentEmail: String
    
    public init(goalId: Int,
                memberId: UUID,
                nameGoal: String,
                accumulatedValue: Int = 0,
                taskWinnedValue: Int = 0,
                rewardsSystemType: String,
                rewardsSystemValue: Int,
                parentEmail: String
    ) {
        self.goalId = goalId
        self.memberId = memberId
        self.nameGoal = nameGoal
        self.accumulatedValue = accumulatedValue
        self.taskWinnedValue = taskWinnedValue
        self.rewardsSystemType = rewardsSystemType
        self.rewardsSystemValue = rewardsSystemValue
        self.parentEmail = parentEmail
    }
}
