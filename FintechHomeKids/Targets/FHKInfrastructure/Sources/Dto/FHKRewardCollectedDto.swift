//
//  FHKRewardCollectedDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKDomain
import FHKCore

public struct FHKRewardCollectedDto: BusinessModelProtocol {
    public let id: Int
    public let created_at: String
    public let parent_email: String
    public let name_reward: String
    public let member: FHKMemberDto
    public let claimed_value: String
    public let state: String
    public let name_task: String
}

extension FHKRewardCollectedDto: MappeableToDomain {
    public func toDomain() -> FHKRewardCollectedEntity {
        return FHKRewardCollectedEntity(id: self.id,
                                        createdDate: self.created_at,
                                        member: self.member.toDomain(),
                                        parentEmail: self.parent_email,
                                        nameReward: self.name_reward,
                                        claimedValue: self.claimed_value,
                                        state: self.state,
                                        nameTask: self.name_task)
    }
}
