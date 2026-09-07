//
//  FHKMembers.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKMembers: Sendable {
    
    public var addMembers:
    @Sendable([FHKMemberEntity]) async throws -> Void = { _ in }
    
    public var fetchFamilyMembers:
    @Sendable(String) async throws -> [FHKMemberEntity] = { _ in []}
    
    public var deleteMember:
    @Sendable(UUID) async throws -> Void = { _ in }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    var fhkMembers: FHKMembers {
        get { get(FHKMembers.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKMembers.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
public extension FHKMembers {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var supabase = Self()
        
        supabase.fetchFamilyMembers = { email in
            [FHKMemberEntity(emailParent: "parent@domain.com",
                             memberName: "New Member",
                             familyName: "Family Dummy")]
        }
        
        return supabase
    }
}

#endif
