//
//  FHKLoginResponseDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 24/11/2026.
//

import FHKDomain

public struct FHKLoginResponseDto: Sendable, Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresInMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresInMinutes = "expires_in_minutes"
    }
}


public extension FHKLoginResponseDto {
    func toDomain() -> FHKLoginEntity {
        FHKLoginEntity(accessToken: self.accessToken,
                       refreshToken: self.refreshToken,
                       tokenType: self.tokenType,
                       expiresInMinutes: self.expiresInMinutes)
    }
}

public extension FHKLoginEntity {
    func toDto() -> FHKLoginResponseDto {
        FHKLoginResponseDto(accessToken: self.accessToken,
                            refreshToken: self.refreshToken,
                            tokenType: self.tokenType,
                            expiresInMinutes: self.expiresInMinutes)
    }
}
