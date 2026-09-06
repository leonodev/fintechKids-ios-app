//
//  FHKHomeRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation

public struct FHKHomeRepository: Sendable {
    
    public var fetchMembers:
    @Sendable(String, Bool) async throws -> [FHKMemberEntity] = { _, _ in [] }
    
    public var fetchRewardCollected:
    @Sendable(String, Bool) async throws -> [FHKRewardCollectedEntity] = { _, _ in [] }
    
    public var getParentMail:
    @Sendable() async -> String? = { nil }
    
    public init() {}
}
