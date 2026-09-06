//
//  FHKRewardDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKCore
import FHKDomain

public struct FHKRewardDto: BusinessModelProtocol {
    public let id: Int?
    public let created_at: String
    public let name: String
    public let time_requiered: String
    public let coins_required: Int
    public let email_parent: String
}

extension FHKRewardDto: MappeableToDomain {
    public func toDomain() throws -> FHKRewardEntity {
        
        return FHKRewardEntity(
            id: self.id,
            createdAt: self.created_at,
            name: self.name,
            timeRequiered: self.time_requiered,
            coinsRequiered: self.coins_required,
            emailParent: self.email_parent)
    }
}

extension FHKRewardEntity: MappeableToSupabase {
    public func toDto() throws -> FHKRewardDto {
        return FHKRewardDto(
            id: self.id,
            created_at: self.createdAt,
            name: self.name,
            time_requiered: self.timeRequiered,
            coins_required: self.coinsRequiered,
            email_parent: self.emailParent
        )
    }
}
