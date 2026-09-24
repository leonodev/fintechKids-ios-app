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

#if DEBUG
public extension FHKRewardCollectedEntity {
    static func previewItem(_ count: Int) -> [Self] {
        var previewItems = [Self]()
        
        for i in 1...count {
            let item = FHKRewardCollectedEntity(id: 1,
                                                createdDate: Date().toUTC,
                                                member: FHKMemberEntity.previewItem,
                                                parentEmail: "parent@domain.com",
                                                nameReward: "Go to Karting \(i)",
                                                claimedValue: "200 KidsCoins",
                                                state: "PENDING",
                                                nameTask: "pass the school term exams")
            previewItems.append(item)
        }
        
        return previewItems
    }
}

#endif
