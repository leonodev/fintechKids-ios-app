//
//  FHKTaskDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 11/11/2026.
//

import Foundation
import FHKDomain
import FHKCore

public struct FHKTaskDto: BusinessModelProtocol {
    public let created_at: String
    public let name: String
    public let description: String
    public let time_granted: String
    public let coins_granted: Int
    public let email_parent: String
}

extension FHKTaskDto: MappeableToDomain {
    public func toDomain() -> FHKTaskEntity {
        return FHKTaskEntity(
            createdAt: self.created_at,
            name: self.name,
            description: self.description,
            timeGranted: self.time_granted,
            coinsGranted: self.coins_granted,
            emailParent: self.email_parent
        )
    }
}

extension FHKTaskEntity: MappeableToSupabase {
    public func toDto() throws -> FHKTaskDto {
        return FHKTaskDto(created_at: self.createdAt,
                          name: self.name,
                          description: self.description,
                          time_granted: self.timeGranted,
                          coins_granted: self.coinsGranted,
                          email_parent: self.emailParent
        )
    }
}
