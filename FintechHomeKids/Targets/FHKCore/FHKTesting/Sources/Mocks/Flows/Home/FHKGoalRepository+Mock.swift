//
//  FHKGoalRepository+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import FHKDomain
import Foundation

public extension FHKGoalRepository {
    
    static var test: Self {
        Self()
    }
    
    static func preview(_ count: Int) -> Self {
        var repository = Self()
        
        repository.clearCache = {}
        
        repository.getGoals = { _, _ in
            FHKGoalEntity.previewItem(count)
        }
        
        repository.createGoalMember = { _ in }
        
        repository.fetchGoalMember = { memberId, isForceRefresh in
            FHKGoalMemberEntity.previewItem(count)
        }
        
        repository.fetchGoalMemberFamily = { emailParent, isForceRefresh in
            FHKGoalMemberEntity.previewItem(count)
        }
        
        repository.clearCache = {}
        
        return repository
    }
}

public extension FHKGoalMemberEntity {
    static func previewItem(_ count: Int) -> [Self] {
        var previewItems = [FHKGoalMemberEntity]()
        
        for i in 1...count {
            let item = FHKGoalMemberEntity(goalId: i,
                                           memberId: UUID.init(),
                                           nameGoal: "PSP5 \(i)",
                                           rewardsSystemType: "coins",
                                           rewardsSystemValue: 45,
                                           parentEmail: "parent@domain.com")
            
            previewItems.append(item)
        }
        return previewItems
    }
}

public extension FHKGoalEntity {
    static func previewItem(_ count: Int) -> [Self] {
        var previewItems = [FHKGoalEntity]()
        
        for i in 1...count{
            let item = FHKGoalEntity(id: i,
                                     expirationDate: Date().toUTC,
                                     name: "PSP5 - \(i)",
                                     emailParent: "parent@domain.com",
                                     value: 35,
                                     measureType: "coins",
                                     status: .inCurse)
            
            previewItems.append(item)
        }
        return previewItems
    }
}
