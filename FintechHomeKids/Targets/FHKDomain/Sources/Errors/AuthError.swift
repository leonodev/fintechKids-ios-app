//
//  AuthError.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import Foundation
import FHKCore

public enum AuthError: FHKError, Equatable {
    case userNotFound
    case invalidCredentials
    case accessTokenInvalid
    case pinApproveInvalid
    case familyNameInvalid
    case sessionExpired
    case unknown(String)
    
    public var logMessage: String {
        switch self {
        case .userNotFound:
            return "Error: User login process failed"
            
        case .invalidCredentials:
            return "Error: Invalid credentials"
     
        case .accessTokenInvalid:
            return "Error: Gettting Access token invalid"
            
        case .pinApproveInvalid:
            return "Error: Pin by approve invalid"
            
        case .sessionExpired:
            return "Error: Session expired"
            
        case .familyNameInvalid:
            return "Error: Family name invalid"
            
        case .unknown(let message):
            return "Error: \(message)"
        }
    }
    
    public var msnLocalizedKey: String {
        switch self {
        case .userNotFound, .invalidCredentials:
            return "invalid_credentials_error"
            
        case .accessTokenInvalid, .pinApproveInvalid, .sessionExpired:
            return "msn_generic_error"
            
        case .familyNameInvalid, .unknown:
            return "msn_generic_error"
        }
    }
    
    // They cannot exceed 100 characters.
    public var analyticsIdentifier: String? {
        switch self {
        case .userNotFound:
            return "login_user_failed"
            
        case .invalidCredentials:
            return "login_invalid_credentials"
            
        case .accessTokenInvalid:
            return "login_access_token_missing"
            
        case .pinApproveInvalid:
            return "login_pin_approve_missing"
            
        case .sessionExpired:
            return "session_expired"
            
        case .familyNameInvalid:
            return "family_name_missing"
            
        case .unknown:
            return "unknown_error"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
