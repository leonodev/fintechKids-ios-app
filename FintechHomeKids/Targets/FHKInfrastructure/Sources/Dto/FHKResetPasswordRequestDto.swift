//
//  FHKResetPasswordRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 22/11/2026.
//

import FHKDomain

public struct FHKResetPasswordRequestDto: Encodable, Sendable {
    public let emailParent: String
    public let recoveryCode: String
    public let newPassword: String
    
    enum CodingKeys: String, CodingKey {
        case emailParent = "email_parent"
        case recoveryCode = "recovery_code"
        case newPassword = "new_password"
    }
}

public extension FHKResetPasswordRequestDto {
    func toDomain() -> FHKResetPasswordParams {
        FHKResetPasswordParams(
            email: self.emailParent,
            recoveryCode: self.recoveryCode,
            newPassword: self.newPassword
        )
    }
}

public extension FHKResetPasswordParams {
    func toDto() -> FHKResetPasswordRequestDto {
        FHKResetPasswordRequestDto(
            emailParent: self.email,
            recoveryCode: self.recoveryCode,
            newPassword: self.newPassword
        )
    }
}


