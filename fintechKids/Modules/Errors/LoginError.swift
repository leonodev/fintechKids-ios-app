//
//  LoginError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/3/26.
//

import FHKUtils
import FHKDomain

enum FHKLoginError: FHKError {
    case loginUserFailed
    
    var logMessage: String {
        switch self {
        case .loginUserFailed:
            return "Error: User login process failed"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .loginUserFailed:
            return "invalid_credentials_error"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .loginUserFailed:
            return "login_user_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
