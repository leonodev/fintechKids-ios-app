//
//  RegisterRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class RegisterRepository: RegisterRepositoryProtocol {
    
    // Properties Injected
    private var fhkSupabase: any FHKAuthProtocol {
        inject.fhkSupabase
    }
    
    private var fhkStorage: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    @discardableResult
    func register(email: String, password: String, familyName: String) async throws -> FHKUserSession {
        try await fhkSupabase.register(email: email,
                                       password: password,
                                       familyName: familyName)
    }
    
    func saveFamilyInfoKeychain(familyName: String) throws {
        try fhkStorage.saveKeychain(familyName, for: KeychainKeys.familyNameKey)
    }
}
