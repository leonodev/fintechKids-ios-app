//
//  LoginRepositoryMock.swift
//  fintechKids
//
//  Created by fleon  on 5/6/26.
//

import Foundation
import FHKDomain

public final class LoginRepositoryMock: @unchecked Sendable, FHKLoginRepositoryProtocol {
    
    public func login(loginEntity: LoginEntity) async throws -> FHKUserSession? {
        return nil
    }
    
    public func loginWithBiometrics(prompt: String) async throws {
        
    }
    
    public func saveAuthToken(_ token: String, requiresBiometry: Bool) throws {
        
    }
    
    public func saveUserIntoKeychain(email: String) async throws {
        
    }
    
    public func savePinApproveTask(pin: String) async throws {
        
    }
    
    public func refreshParentMail() {
        
    }
    
    public var hasSavedToken: Bool = false
}
