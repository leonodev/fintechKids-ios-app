//
//  FHKAuth.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//


public struct FHKAuth: Sendable {
    public var login: @Sendable (LoginEntity) async throws -> FHKUserSession = { _ in
        throw FHKAuthError.userNotFound
    }
    public var logout: @Sendable () async throws -> Void = {}
    public var refreshSession: @Sendable (String) async throws -> FHKUserSession = { _ in
        throw FHKAuthError.sessionExpired
    }
    public var register: @Sendable (FHKRegisterEntity) async throws -> FHKUserSession = { _ in
        throw FHKAuthError.unknown("Error registering")
    }
    public var setSession: @Sendable(String) async throws -> Void = {  _ in }
    public var isUserAuthenticated: @Sendable () async -> Bool = { false }
    
    public init() {}
}
