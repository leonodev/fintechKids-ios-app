//
//  FHKRegisterError.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 5/9/26.
//

import FLibUtils
import FHKDomain
import FHKCore

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
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .registerUserFailed:
            return "register_user_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
