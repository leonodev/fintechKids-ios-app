//
//  FHKUserSession.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation

public struct FHKUserSession: Sendable {
    public let id: UUID
    public let email: String
    public let accessToken: String?
    public let refreshToken: String?
    public let expiresAt: Date?
    public let infoAditional: InfoAditional?
    
    public var hasActiveSession: Bool {
        return accessToken != nil
    }

    public init(id: UUID,
                email: String,
                accessToken: String? = nil,
                refreshToken: String? = nil,
                expiresAt: Date? = nil,
                infoAditional: InfoAditional? = nil
    ) {
        self.id = id
        self.email = email
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
        self.infoAditional = infoAditional
    }
}
