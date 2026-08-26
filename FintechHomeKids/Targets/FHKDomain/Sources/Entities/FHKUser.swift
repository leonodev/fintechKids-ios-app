//
//  FHKUser.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation

public struct FHKUser: Sendable {
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

public struct InfoAditional: Sendable {
    public let pinApproved: String
    public let familyName: String
    
    public init(pinApproved: String, familyName: String) {
        self.pinApproved = pinApproved
        self.familyName = familyName
    }
}
