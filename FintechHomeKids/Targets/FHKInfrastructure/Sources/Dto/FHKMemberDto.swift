//
//  FHKMemberDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKDomain
import FHKCore

public struct FHKMemberDto: BusinessModelProtocol {
    public let identification_uuid: UUID
    public let email_parent: String
    public let member_name: String
    public let name_family: String
    public let avatar_name: String
}

extension FHKMemberDto: MappeableToDomain {
    public func toDomain() -> FHKMemberEntity {
        return FHKMemberEntity(
            id: self.identification_uuid,
            emailParent: self.email_parent,
            memberName: self.member_name,
            familyName: self.name_family,
            avatarName: self.avatar_name
        )
    }
}

extension FHKMemberEntity: MappeableToSupabase {
    public func toDto() throws -> FHKMemberDto {
        return FHKMemberDto(
            identification_uuid: self.id,
            email_parent: self.emailParent,
            member_name: self.memberName,
            name_family: self.familyName,
            avatar_name: self.avatarName
        )
    }
}
