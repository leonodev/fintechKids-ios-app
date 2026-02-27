//
//  FHKSecurityError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/2/26.
//

import FHKUtils
import FHKDomain

public enum FHKSecurityError: FHKError {
    case saveTokenAccessKeychainFailed
    case saveUserMailKeychainFailed
    case readUserMailKeychainFailed
    
    public var logMessage: String {
        switch self {            
        case .saveTokenAccessKeychainFailed:
            return "Security: failure saving access token to keychain"
            
        case .saveUserMailKeychainFailed:
            return "Security: failed to save user email in secure keychain storage"
            
        case .readUserMailKeychainFailed:
            return "Security: failed to read user email from secure keychain storage"
        }
    }
    
    public var messageUI: String {
        "msn_proccessing_information_secure".localized().capitalizingFirstLetter()
    }
    
    // These are all critical system errors, so we ALWAYS track them.
    public var isShouldTrack: Bool {
        true
    }
}
