//
//  FHKBalanceEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FHKCore

public struct FHKBalanceEntity: DomainModelProtocol {
    public let id: UUID = UUID()
    public let memberId: UUID
    public let coinsObtained: Int
    public let timeObtained: String
    
    public init(memberId: UUID,
                coinsObtained: Int,
                timeObtained: String
    ) {
        self.memberId = memberId
        self.coinsObtained = coinsObtained
        self.timeObtained = timeObtained
    }
}
