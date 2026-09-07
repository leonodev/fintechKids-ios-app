//
//  FHKRewardCollectedEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKCore

public struct FHKRewardCollectedEntity: DomainModelProtocol {
    public let id: Int
    public let createdDate: String
    public let member: FHKMemberEntity
    public let parentEmail: String
    public let nameReward: String
    public let claimedValue: String
    public let state: String
    public let nameTask: String
   
    
    public init(id: Int,
                createdDate: String,
                member: FHKMemberEntity,
                parentEmail: String,
                nameReward: String,
                claimedValue: String,
                state: String,
                nameTask: String
    ) {
        self.id = id
        self.createdDate = createdDate
        self.member = member
        self.parentEmail = parentEmail
        self.nameReward = nameReward
        self.claimedValue = claimedValue
        self.state = state
        self.nameTask = nameTask
    }
}
