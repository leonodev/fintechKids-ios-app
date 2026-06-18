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
    case accessTokenInvalid
    case pinApproveInvalid
    case familyNameInvalid
    
    var logMessage: String {
        switch self {
        case .loginUserFailed:
            return "Error: User login process failed"
            
        case .accessTokenInvalid:
            return "Error: Gettting Access token invalid"
            
        case .pinApproveInvalid:
            return "Error: Pin by approve invalid"
            
        case .familyNameInvalid:
            return "Error: Family name invalid"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .loginUserFailed:
            return "invalid_credentials_error"
            
        case .accessTokenInvalid, .pinApproveInvalid:
            return "msn_generic_error"
            
        case .familyNameInvalid:
            return "msn_generic_error"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .loginUserFailed:
            return "login_user_failed"
            
        case .accessTokenInvalid:
            return "login_access_token_missing"
            
        case .pinApproveInvalid:
            return "login_pin_approve_missing"
            
        case .familyNameInvalid:
            return "family_name_missing"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
