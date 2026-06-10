//
//  LoginRepositoryMock.swift
//  fintechKids
//
//  Created by fleon  on 5/6/26.
//

import Foundation
import FHKDomain
import FHKInjections

public final class LoginRepositoryMock: @unchecked Sendable, FHKLoginRepositoryProtocol {
    
    private var fhkSupabase: any FHKAuthProtocol {
        inject.fhkSupabase
    }
    
    private var fhkStorage: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    public func login(loginEntity: LoginEntity) async throws -> FHKUserSession? {
        try await fhkSupabase.login(loginEntity: loginEntity)
    }
    
    public func loginWithBiometrics(prompt: String) async throws {
        
    }
    
    public func saveAuthToken(_ token: String, requiresBiometry: Bool) throws {
        try fhkStorage.saveKeychain(
            token,
            for: KeychainKey.authToken.rawValue,
            requireBiometry: requiresBiometry
        )
    }
    
    public func saveUserIntoKeychain(email: String) async throws {
        
    }
    
    public func savePinApproveTask(pin: String) async throws {
        
    }
    
    public func refreshParentMail() {
        
    }
    
    public var hasSavedToken: Bool = false
}
