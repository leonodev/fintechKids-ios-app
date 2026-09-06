//
//  FHKGoalDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKDomain
import FHKCore

public struct FHKGoalDto: BusinessModelProtocol {
    public let id: Int?
    public let date_expiration: String
    public let name: String
    public let email_parent: String
    public let value: Int
    public let measure_type: String
    public let status: String
}

extension FHKGoalDto: MappeableToDomain {
    public func toDomain() throws -> FHKGoalEntity {
        let domainStatus = OperationStatus(rawValue: self.status) ?? .inCurse
        
        return FHKGoalEntity(
            id: self.id,
            expirationDate: self.date_expiration,
            name: self.name,
            emailParent: self.email_parent,
            value: self.value,
            measureType: self.measure_type,
            status: domainStatus)
    }
}

extension FHKGoalEntity: MappeableToSupabase {
    public func toDto() throws -> FHKGoalDto {
        return FHKGoalDto(id: self.id,
                          date_expiration: self.expirationDate,
                          name: self.name,
                          email_parent: self.emailParent,
                          value: self.value,
                          measure_type: self.measureType,
                          status: self.status.value
        )
    }
}

extension FHKGoalMemberEntity: MappeableToSupabase {
    public func toDto() throws -> FHKGoalMemberDto {
        return FHKGoalMemberDto(goal_id: self.goalId,
                             member_id: self.memberId,
                             name_goal: self.nameGoal,
                             accumulated_value: self.taskWinnedValue, // It takes the value of the task and adds it to what is in the backend.
                             rewards_system_type: self.rewardsSystemType,
                             rewards_system_value: self.rewardsSystemValue,
                             parent_email: self.parentEmail
        )
    }
}
