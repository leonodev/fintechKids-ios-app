//
//  FHKRegisterMembersRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/9/26.
//

import FLibInjections

// MARK: - Contract
public struct FHKRegisterMembersRepository: Sendable {
    
    public var registerMembers: @Sendable
    ([FHKMemberEntity]) async throws -> Void = { _ in }
    
    public var getParentMail: @Sendable
    () async throws -> String? = { nil }
    
    public var getFamilyName: @Sendable
    () async throws -> String? = { nil }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkRegisterMembersRepository: FHKRegisterMembersRepository {
        get { get(FHKRegisterMembersRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKRegisterMembersRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKRegisterMembersRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.registerMembers = { _ in }
        
        preview.getFamilyName = {
            "Family Name"
        }
        
        preview.getParentMail = {
            "parent@mail.com"
        }
        
        return preview
    }
    
}

#endif

