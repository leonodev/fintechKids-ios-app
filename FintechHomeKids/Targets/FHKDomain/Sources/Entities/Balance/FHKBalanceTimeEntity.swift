//
//  FHKBalanceTimeEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FHKCore

public struct FHKBalanceTimeEntity: DomainModelProtocol {
    public let id: UUID = UUID()
    public let memberId: UUID
    public let timeObtained: String
    
    public init(memberId: UUID,
                timeObtained: String
    ) {
        self.memberId = memberId
        self.timeObtained = timeObtained
    }
}
