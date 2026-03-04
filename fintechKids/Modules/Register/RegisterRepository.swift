//
//  RegisterRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage
import FHKSupabase

final class RegisterRepository: RegisterRepositoryProtocol {
    
    // Properties Injected
    private var supabase: any FHKAuthProtocol {
        inject.supabaseManager
    }
    
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    @discardableResult
    func register(email: String, password: String) async throws -> FHKUserSession {
        try await supabase.register(email: email, password: password)
    }
    
    func saveUserIntoKeychain(email: String) async throws {
        try storageManager.saveKeychain(email, for: KeychainKeys.userKey)
    }
}
