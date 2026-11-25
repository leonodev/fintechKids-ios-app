//
//  FHKResetPasswordResponseDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 22/11/2026.
//

import Foundation
import FHKDomain

public struct FHKResetPasswordResponseDto: Decodable, Sendable {
    public let message: String
    public let emailParent: String
    public let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case message
        case emailParent = "email_parent"
        case updatedAt = "updated_at"
    }
}

public extension FHKResetPasswordResponseDto {
    func toDomain() -> FHKResetPasswordEntity {
        FHKResetPasswordEntity(
            message: message,
            email: emailParent,
            updatedAt: updatedAt
        )
    }
}
