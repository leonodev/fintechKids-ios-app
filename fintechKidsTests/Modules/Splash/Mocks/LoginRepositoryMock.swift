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
    
    public var isCalledLogin = false
    public var isCalledLoginBiometrics = false
    
    public var isCalledSaveAuthToken = false
    public var isCalledSaveAuthTokenCount = 0
    
    public var isCalledSaveUserIntoKeychain = false
    public var isCalledSaveUserIntoKeychainCount = 0
    
    public var isCalledSavePinApproveTask = false
    public var isCalledSavePinApproveTaskCount = 0
 
    public var sessionToReturn: FHKUserSession?
    public var errorLoginToThrow: Error?
    public var errorSaveTokenToThrow: Error?
    public var errorSavePinToThrow: Error?
    public var errorSaveUserKeyChainToThrow: Error?
    
    public func login(loginEntity: LoginEntity) async throws -> FHKUserSession? {
        isCalledLogin = true
        if let error = errorLoginToThrow { throw error }
        return sessionToReturn
    }
    
    public func loginWithBiometrics(prompt: String) async throws {
        isCalledLoginBiometrics = true
        if let error = errorLoginToThrow { throw error }
    }
    
    public func saveAuthToken(_ token: String, requiresBiometry: Bool) throws {
        isCalledSaveAuthToken = true
        isCalledSaveAuthTokenCount += 1
        if let error = errorSaveTokenToThrow { throw error }
    }
    
    public func saveUserIntoKeychain(email: String) async throws {
        isCalledSaveUserIntoKeychain = true
        isCalledSaveUserIntoKeychainCount += 1
        if let error = errorSaveUserKeyChainToThrow { throw error }
    }
    
    public func readUserIntoKeychain() async throws -> String? {
        sessionToReturn?.email
    }
    
    public func savePinApproveTask(pin: String) async throws {
        isCalledSavePinApproveTask = true
        isCalledSavePinApproveTaskCount += 1
        if let error = errorSavePinToThrow { throw error }
    }
    
    public func refreshParentMail() {
        
    }
    
    public var hasSavedToken: Bool {
        sessionToReturn?.accessToken != nil
    }
}
