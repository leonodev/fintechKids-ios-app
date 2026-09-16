//
//  FHKBalanceDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/9/26.
//

import Foundation
import FHKCore
import FHKDomain

public struct FHKBalanceDto: BusinessModelProtocol {
    public let member_id: UUID
    public let coins_obtained: Int
    public let time_obtained: String
}

extension FHKBalanceDto: MappeableToDomain {
    public func toDomain() -> FHKBalanceEntity {
        return FHKBalanceEntity(
            memberId: self.member_id,
            coinsObtained: self.coins_obtained,
            timeObtained: self.time_obtained
        )
    }
}
