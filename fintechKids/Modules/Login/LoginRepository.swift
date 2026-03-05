//
//  LoginRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class LoginRepository: FHKLoginRepositoryProtocol {
    
    private var supabase: any FHKAuthProtocol {
        inject.supabaseManager
    }
    
    private var storage: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    var hasSavedToken: Bool {
        storage.exists(key: KeychainKey.authToken.rawValue)
    }

    func login(email: String, pwd: String) async throws -> String? {
        let userSession = try await supabase.login(email: email, password: pwd)
        return userSession.accessToken
    }
    
    func loginWithBiometrics(prompt: String) async throws {
        guard storage.isBiometryAvailable() else {
            throw FHKBiometryError.notAvailable
        }
        
        // Try reading the Keychain token
        guard let savedToken = try storage.readKeychain(
                    String.self,
                    for: KeychainKey.authToken.rawValue,
                    prompt: prompt
        ) else {
            throw FHKBiometryError.notAvailable
        }
        
        // If FaceID accepted, we went directly into the session
        try await supabase.setSession(accessToken: savedToken)
        let isAuthenticated = await supabase.isUserAuthenticated
        if !isAuthenticated {
            throw FHKBiometryError.notAvailable
        }
    }
    
    func saveAuthToken(_ token: String, requiresBiometry: Bool) throws {
        try storage.saveKeychain(
            token,
            for: KeychainKey.authToken.rawValue,
            requireBiometry: requiresBiometry
        )
    }
    
    func saveUserIntoKeychain(email: String) async throws {
        try storage.saveKeychain(email, for: KeychainKeys.userKey)
    }
}
