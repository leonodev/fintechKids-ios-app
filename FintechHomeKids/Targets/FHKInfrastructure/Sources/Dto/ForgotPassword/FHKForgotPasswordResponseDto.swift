//
//  FHKForgotPasswordResponseDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import Foundation
import FHKDomain

public struct FHKForgotPasswordResponseDto: Decodable, Sendable {
    public let message: String
    public let emailParent: String
    public let expiresInMinutes: Int
    public let debugRecoveryCode: String?

    enum CodingKeys: String, CodingKey {
        case message
        case emailParent = "email_parent"
        case expiresInMinutes = "expires_in_minutes"
        case debugRecoveryCode = "debug_recovery_code"
    }
}

public extension FHKForgotPasswordResponseDto {
    func toDomain() -> FHKForgotPasswordEntity {
        FHKForgotPasswordEntity(
            message: message,
            email: emailParent,
            expiresInMinutes: expiresInMinutes,
            debugRecoveryCode: debugRecoveryCode
        )
    }
}

public extension FHKForgotPasswordParams {
    func toDto() -> FHKForgotPasswordRequestDto {
        FHKForgotPasswordRequestDto(emailParent: self.emailParent)
    }
}
