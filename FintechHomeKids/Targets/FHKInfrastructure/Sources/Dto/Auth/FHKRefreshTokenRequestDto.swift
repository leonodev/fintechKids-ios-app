//
//  FHKRefreshTokenRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/11/2026.
//

public struct FHKRefreshTokenRequestDto: Encodable, Sendable {
    public let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }

    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
