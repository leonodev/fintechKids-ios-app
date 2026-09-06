//
//  FHKMembers.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation

public struct FHKMembers: Sendable {
    
    public var addMembers:
    @Sendable([FHKMemberEntity]) async throws -> Void = { _ in }
    
    public var fetchFamilyMembers:
    @Sendable(String) async throws -> [FHKMemberEntity] = { _ in []}
    
    public var deleteMember:
    @Sendable(UUID) async throws -> Void = { _ in }
    
    public init() {}
}
