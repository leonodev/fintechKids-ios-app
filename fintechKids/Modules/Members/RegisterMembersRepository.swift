//
//  RegisterMembersRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class RegisterMembersRepository: FHKRegisterMembersRepositoryProtocol {
    
    // Properties injected
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    private var fhkSupabaseMembers: any FHKSupabaseMembersProtocol {
        inject.fhkSupabaseMembers
    }
    
    func registerMembers(members: [MemberEntity]) async throws {
        try await fhkSupabaseMembers.addMembers(members: members)
    }
    
    public func getParentMail() async -> String? {
        fhkConfiguration.parentMail
    }
}
