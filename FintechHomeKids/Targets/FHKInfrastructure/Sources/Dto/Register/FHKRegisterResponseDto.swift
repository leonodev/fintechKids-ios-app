//
//  FHKRegisterResponseDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 17/11/2026.
//

import FHKDomain

public struct FHKRegisterResponseDto: Sendable, Decodable {
    let id: Int
    let createdAt: String
    let nameFamily: String
    let emailParent: String
    let approvePin: String
    let isActive: Bool
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case nameFamily = "name_family"
        case emailParent = "email_parent"
        case approvePin = "approve_pin"
        case isActive = "is_active"
        case updatedAt = "updated_at"
    }
}

public extension FHKRegisterResponseDto {
    func toDomain() -> FHKRegisterEntity {
        FHKRegisterEntity(id: self.id,
                          createdAt: self.createdAt,
                          nameFamily: self.nameFamily,
                          emailParent: self.emailParent,
                          approvePin: self.approvePin,
                          isActive: self.isActive,
                          updatedAt: self.updatedAt
        )
    }
}
