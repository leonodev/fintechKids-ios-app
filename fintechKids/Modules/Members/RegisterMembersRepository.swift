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
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    private var supabaseMembers: any FHKSupabaseMembersProtocol {
        inject.supabaseMembersManager
    }
    
    func registerMembers(members: [FamilyMember]) async throws {
        try await supabaseMembers.addMembers(members: members)
    }
    
    public func getParentMail() async -> String? {
        try? storageManager.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
    }
}
