//
//  RegisterError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/3/26.
//

import FHKUtils
import FHKDomain

enum FHKRegisterError: FHKError {
    case registerUserFailed
    
    var logMessage: String {
        switch self {
        case .registerUserFailed:
            return "Error: User registration failed"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .registerUserFailed:
            return "msn_register_user_error"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
