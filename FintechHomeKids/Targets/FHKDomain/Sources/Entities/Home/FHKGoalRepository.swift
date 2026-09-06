//
//  FHKGoalRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation

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
