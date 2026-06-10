//
//  SupabaseMock.swift
//  fintechKids
//
//  Created by fleon  on 8/6/26.
//

import Foundation
import FHKDomain
import Supabase

public final class SupabaseMock: FHKAuthProtocol, FHKSupabaseErrorProtocol {
    private let client: SupabaseClient
    public var errorToThrow: Error? = nil
    public var session = FHKUserSession(id: UUID(),
                                         email: "user@test.com",
                                         accessToken: "3FD345GHY345345DF",
                                         refreshToken: "FSDFSD234234FSD",
                                         expiresAt: Date(),
                                         pinApproved: "1234")

    public init(client: SupabaseClient) {
        self.client = client
    }
    
    public func login(loginEntity: LoginEntity) async throws -> FHKUserSession {
        if let error = errorToThrow {
            throw error
        }
        
        return session
    }
    
    public func logout() async throws {
        
    }
    
    public func refreshSession(emailParent: String) async throws -> FHKUserSession {
        return session
    }
    
    public func register(registerEntity: RegisterUserEntity) async throws -> FHKUserSession {
        return session
    }
    
    public func setSession(accessToken: String) async throws {
        
    }
    
    public let isUserAuthenticated: Bool = false
}
