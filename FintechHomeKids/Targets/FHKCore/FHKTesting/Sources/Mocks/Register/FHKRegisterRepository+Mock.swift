//
//  FHKRegisterRepository+Mock.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Foundation
import FHKDomain

public extension FHKRegisterRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.register = { _ in
            return FHKUserSession(id: UUID(),
                                  email: "user@domain.com",
                                  accessToken: "345345FDFDFTOKENTEST",
                                  refreshToken: "345345FDFDFREFRESHTOKENTEST",
                                  expiresAt: Date(),
                                  infoAditional: InfoAditional(pinApproved: "123", familyName: "FamilyTest"))
        }
        
        return preview
    }
}
