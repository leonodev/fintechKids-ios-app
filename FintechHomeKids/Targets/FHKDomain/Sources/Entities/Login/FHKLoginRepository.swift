//
//  FHKLoginRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKLoginRepository: Sendable {
    public var login: @Sendable (_ loginEntity: LoginEntity) async throws -> FHKUserSession? = { _ in nil }
    public var loginWithBiometrics: @Sendable (_ prompt: String) async throws -> Void = { _ in }
    public var saveAuthToken: @Sendable (_ token: String,
                                         _ requiresBiometry: Bool) throws -> Void = { _, _ in }
    public var saveUserIntoKeychain: @Sendable (_ email: String) async throws -> Void = { _ in }
    public var savePinApproveTask: @Sendable (_ pin: String) async throws -> Void = { _ in }
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
            FHKUserSession(id: UUID(),
                           email: "parent@domian.com",
                           accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
                           refreshToken: "eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkZy",
                           expiresAt: Date(),
                           infoAditional: InfoAditional(pinApproved: "0000",
                                                        familyName: "Dummy Family")
               )
        }
        
        return preview
    }
}

#endif
