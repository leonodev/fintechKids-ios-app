//
//  Session+Mapper.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import Supabase
import FHKDomain

public extension Session {
    func toDomain(aditionalInfo: InfoAditional? = nil) -> FHKUserSession {
        return FHKUserSession(
            id: self.user.id,
            email: self.user.email ?? "",
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            expiresAt: Date(timeIntervalSince1970: TimeInterval(self.expiresAt)),
            infoAditional: aditionalInfo
        )
    }
}
