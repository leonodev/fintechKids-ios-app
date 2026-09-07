//
//  FHKAuth.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import FLibInjections

// MARK: - Contract
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

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkAuth: FHKAuth {
        get { get(FHKAuth.self, preview: .test, testing: .test) }
        set { set(newValue, for: FHKAuth.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
public extension FHKAuth {
    static var test: Self {
        Self()
    }
}

#endif
