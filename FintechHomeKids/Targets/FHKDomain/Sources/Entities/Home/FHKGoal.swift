//
//  FHKGoal.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation

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
