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
    private var supabaseMembers: FHKSupabaseMembersProtocol {
        inject.supabaseMembersManager
    }
    
    private var storageManager: FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    func fetchMembers(email: String) async throws -> [MemberEntity] {
        try await supabaseMembers.fetchFamilyMembers(parentEmail: email)
    }
    
    public func getParentMail() async -> String? {
        try? storageManager.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
    }
}
