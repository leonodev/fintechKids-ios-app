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
    
    private var fhkSupabase: any FHKAuthProtocol {
        inject.fhkSupabase
    }
    
    private var fhkStorage: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    private var fhkConfiguration: any FHKConfigurationProtocol {
        inject.fhkConfiguration
    }
    
    var hasSavedToken: Bool {
        fhkStorage.exists(key: KeychainKey.authToken.rawValue)
    }

    func login(email: String, pwd: String) async throws -> String? {
        let userSession = try await fhkSupabase.login(email: email, password: pwd)
        return userSession.accessToken
    }
    
    func loginWithBiometrics(prompt: String) async throws {
        guard fhkStorage.isBiometryAvailable() else {
            throw FHKAppError.biometryNotAvailable
        }
        
        // Try reading the Keychain token
        guard let savedToken = try fhkStorage.readKeychain(
                    String.self,
                    for: KeychainKey.authToken.rawValue,
                    prompt: prompt
        ) else {
            throw FHKAppError.biometryNotAvailable
        }
        
        // If FaceID accepted, we went directly into the session
        try await fhkSupabase.setSession(accessToken: savedToken)
        let isAuthenticated = await fhkSupabase.isUserAuthenticated
        if !isAuthenticated {
            throw FHKAppError.biometryNotAvailable
        }
    }
    
    func saveAuthToken(_ token: String, requiresBiometry: Bool) throws {
        try fhkStorage.saveKeychain(
            token,
            for: KeychainKey.authToken.rawValue,
            requireBiometry: requiresBiometry
        )
    }
    
    func saveUserIntoKeychain(email: String) async throws {
        try fhkStorage.saveKeychain(email, for: KeychainKeys.userKey)
        refreshParentMail()
    }
    
    func refreshParentMail() {
        fhkConfiguration.refreshParentMail()
    }
}
