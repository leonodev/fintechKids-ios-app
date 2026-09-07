//
//  FHKGoalRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKGoalRepository: Sendable {
    
    public var createGoal: @Sendable
    (FHKGoalEntity) async throws -> Void = { _ in }
    
    public var getGoals: @Sendable
    (String, Bool) async throws -> [FHKGoalEntity] = { _, _ in [] }
    
    public var createGoalMember: @Sendable
    (FHKGoalMemberEntity) async throws -> Void = { _ in }
    
    public var fetchGoalMember: @Sendable
    (UUID, Bool) async throws -> [FHKGoalMemberEntity] = { _, _ in [] }
    
    public var fetchGoalMemberFamily: @Sendable
    (String, Bool) async throws -> [FHKGoalMemberEntity] = { _, _ in [] }
    
    public var clearCache: @Sendable
    () async -> Void = { }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkGoalsRepository: FHKGoalRepository {
        get { get(FHKGoalRepository.self, preview: .preview(2), testing: .test) }
        set { set(newValue, for: FHKGoalRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKGoalRepository {
    
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

#endif
