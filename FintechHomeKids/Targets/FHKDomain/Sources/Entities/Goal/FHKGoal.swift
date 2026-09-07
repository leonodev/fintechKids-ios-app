//
//  FHKGoal.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKGoal: Sendable {
    public var createGoal:
    @Sendable(FHKGoalEntity) async throws -> Void = { _ in }
    
    public var getGoals:
    @Sendable(String) async throws -> [FHKGoalEntity] = {_ in []}
    
    public var createGoalMember:
    @Sendable(FHKGoalMemberEntity) async throws -> Void = {_ in }
    
    public var fetchGoalMember:
    @Sendable(UUID) async throws -> [FHKGoalMemberEntity] = {_ in []}
    
    public var fetchGoalMemberFamily:
    @Sendable(String) async throws -> [FHKGoalMemberEntity] = {_ in []}
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    var fhkGoal: FHKGoal {
        get { get(FHKGoal.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKGoal.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKGoal {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var goals = Self()
        
        goals.createGoal = { _ in }
        goals.getGoals = { emailParent in
            FHKGoalEntity.previewItem(2)
        }
        
        return goals
    }
}

extension FHKGoalEntity {
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

#endif



