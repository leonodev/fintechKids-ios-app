//
//  FHKLoginRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import FLibInjections
import FHKCore

// MARK: - Contract
public struct FHKLoginRepository: Sendable {
    
    public var login: @Sendable (_ loginParams: FHKLoginParams) async throws(FHKAppError) -> FHKLoginEntity = { _ in throw  FHKAppError.unknown }
    
    public var loginWithBiometrics: @Sendable (_ prompt: String) async throws(FHKAppError) -> Void = { _ in }
    
    public var saveAuthToken: @Sendable (_ token: String, _ requiresBiometry: Bool) throws(FHKAppError) -> Void = { _, _ in }
    
    public var saveUserIntoKeychain: @Sendable (_ email: String) async throws(FHKAppError) -> Void = { _ in }
    public var savePinApproveTask: @Sendable (_ pin: String) async throws(FHKAppError) -> Void = { _ in }
    public var refreshParentMail: @Sendable () -> Void = {}
    public var hasSavedToken: @Sendable () -> Bool = { false }

    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkLoginRepository: FHKLoginRepository {
        get { get(FHKLoginRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKLoginRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
public extension FHKLoginRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.hasSavedToken = { true }
        
        preview.login = { _ in
            FHKLoginEntity(accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
                           refreshToken: "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkZy",
                           tokenType: "bearer",
                           expiresInMinutes: 1,
                           approvePin: "0000",
                           familyName: "familyName"
            )
        }
        
        return preview
    }
}

#endif
