//
//  FHKLoginEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 24/11/2026.
//

public struct FHKLoginEntity: Sendable, Equatable {
    public let accessToken: String
    public let refreshToken: String
    public let tokenType: String
    public let expiresInMinutes: Int
    
    public init(accessToken: String,
                refreshToken: String,
                tokenType: String,
                expiresInMinutes: Int
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.expiresInMinutes = expiresInMinutes
    }
}
