//
//  FHKSession.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/8/26.
//

import Foundation

public struct FHKSession: Sendable {
    public var isAuthenticated: @MainActor @Sendable () -> Bool = { false }
    public var setIsAuthenticated: @MainActor @Sendable (Bool) -> Void = { _ in }
    
    public var initializeSession: @Sendable () async -> Void = { }
    public var login: @Sendable () async throws -> Void = { }
    public var logout: @Sendable () async throws -> Void = { }
    
    public init(
            isAuthenticated: @escaping @MainActor @Sendable () -> Bool = { false },
            setIsAuthenticated: @escaping @MainActor @Sendable (Bool) -> Void = { _ in },
            initializeSession: @escaping @Sendable () async -> Void = {},
            login: @escaping @Sendable () async throws -> Void = {},
            logout: @escaping @Sendable () async throws -> Void = {}
    ) {
        self.isAuthenticated = isAuthenticated
        self.setIsAuthenticated = setIsAuthenticated
        self.initializeSession = initializeSession
        self.login = login
        self.logout = logout
    }
}
