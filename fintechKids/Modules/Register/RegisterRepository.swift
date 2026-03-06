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
    private var supabase: any FHKAuthProtocol {
        inject.supabaseManager
    }
    
    @discardableResult
    func register(email: String, password: String) async throws -> FHKUserSession {
        try await supabase.register(email: email, password: password)
    }
}

