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
    
    public var isShouldTrack: Bool {
        true
    }
}
