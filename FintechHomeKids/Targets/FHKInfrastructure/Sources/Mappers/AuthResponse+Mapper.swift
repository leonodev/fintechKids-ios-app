//
//  AuthResponse+Mapper.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import Supabase
import FHKDomain

extension AuthResponse {
    func toDomain(aditionalInfo: InfoAditional? = nil) -> FHKUserSession {
        switch self {
        case .session(let session):
            return FHKUserSession(
                id: session.user.id,
                email: session.user.email ?? "",
                accessToken: session.accessToken,
                refreshToken: session.refreshToken,
                infoAditional: aditionalInfo
            )
        case .user(let user):
            return FHKUserSession(
                id: user.id,
                email: user.email ?? "",
                accessToken: nil,
                refreshToken: nil,
                infoAditional: aditionalInfo
            )
        }
    }
}
