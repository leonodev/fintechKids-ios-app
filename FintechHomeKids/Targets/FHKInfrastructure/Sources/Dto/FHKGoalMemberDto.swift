//
//  FHKGoalMemberDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKDomain
import FHKCore

public struct FHKGoalMemberDto: BusinessModelProtocol {
    let goal_id: Int
    let member_id: UUID
    let name_goal: String
    let accumulated_value: Int
    let rewards_system_type: String
    let rewards_system_value: Int
    let parent_email: String
}

extension FHKGoalMemberDto: MappeableToDomain {
    public func toDomain() throws -> FHKGoalMemberEntity {
        
        return FHKGoalMemberEntity(goalId: self.goal_id,
                                   memberId: self.member_id,
                                   nameGoal: self.name_goal,
                                   accumulatedValue: self.accumulated_value,
                                   rewardsSystemType: self.rewards_system_type,
                                   rewardsSystemValue: self.rewards_system_value,
                                   parentEmail: self.parent_email
        )
    }
}
