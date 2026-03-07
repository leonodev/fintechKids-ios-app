//
//  HomeRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class HomeRepository: FHKHomeRepositoryProtocol {
    
    // Properties Injection
    private var fhkSupabaseMembers: FHKSupabaseMembersProtocol {
        inject.fhkSupabaseMembers
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    func fetchMembers(email: String) async throws -> [MemberEntity] {
        try await fhkSupabaseMembers.fetchFamilyMembers(parentEmail: email)
    }
    
    public func getParentMail() -> String? {
        fhkConfiguration.parentMail
    }
}
