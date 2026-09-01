//
//  FHKLoginRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation

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
