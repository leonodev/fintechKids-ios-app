//
//  FHKLoginRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/11/2026.
//

import FHKDomain

public struct FHKLoginRequestDto: Encodable, Sendable {
    public let emailParent: String
    public let password: String

    enum CodingKeys: String, CodingKey {
        case emailParent = "email_parent"
        case password
    }

    public init(emailParent: String, password: String) {
        self.emailParent = emailParent
        self.password = password
    }
}

public extension FHKLoginParams {
    func toDto() -> FHKLoginRequestDto {
        FHKLoginRequestDto(
            emailParent: self.email,
            password: self.password
        )
    }
}
