//
//  FHKRegisterDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/11/2026.
//

import FHKDomain

public struct FHKRegisterDto: Encodable, Sendable {
    public let emailParent: String
    public let password: String
    public let nameFamily: String
    public let approvePin: String

    enum CodingKeys: String, CodingKey {
        case emailParent = "email_parent"
        case password = "password"
        case nameFamily = "name_family"
        case approvePin = "approve_pin"
    }

    public init(
        emailParent: String,
        password: String,
        nameFamily: String,
        approvePin: String
    ) {
        self.emailParent = emailParent
        self.password = password
        self.nameFamily = nameFamily
        self.approvePin = approvePin
    }
}

public extension FHKRegisterDto {
    func toDomain() -> FHKRegisterEntity {
        return FHKRegisterEntity(email: self.emailParent,
                                 password: self.password,
                                 familyName: self.nameFamily,
                                 approvePIN: self.approvePin)
    }
}

public extension FHKRegisterEntity {
    func toDto() -> FHKRegisterDto {
        return FHKRegisterDto(emailParent: self.email,
                              password: self.password,
                              nameFamily: self.familyName,
                              approvePin: self.approvePIN)
    }
}
