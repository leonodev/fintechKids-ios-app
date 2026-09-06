//
//  FHKHomeRepository+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKDomain

public extension FHKHomeRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var homeRepo = Self()
        
        homeRepo.fetchMembers = { _, _ in
            [FHKMemberEntity.previewItem]
        }
        
        homeRepo.fetchRewardCollected = { _, _ in
            FHKRewardCollectedEntity.previewItem(2)
        }
        
        homeRepo.getParentMail = {
            "parent@domain.com"
        }
        
        return homeRepo
    }
}


public extension FHKMemberEntity {
    static var previewItem: Self {
        FHKMemberEntity(emailParent: "parent@domain.com",
                        memberName: "New Member",
                        familyName: "Family Dummy")
    }
}

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
