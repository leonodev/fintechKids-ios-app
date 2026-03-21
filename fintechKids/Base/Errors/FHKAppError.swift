//
//  FHKAppError.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/2/26.
//

import FHKUtils
import FHKDomain

enum FHKAppError: FHKError {
    case readUserMailKeychainFailed
    case saveTokenAccessKeychainFailed
    case saveUserMailKeychainFailed
    case userDefaultsFailed
    case remoteConfigFailed
    case biometryNotAvailable
    case biometryCancelAuthentication
    case biometryAuthenticationFailed
    case invalidURL(String)
    
    var logMessage: String {
        switch self {
    
        case .readUserMailKeychainFailed:
            return "Security: failed to read user email from secure keychain storage"
        
        case .saveTokenAccessKeychainFailed:
            return "Security: failure saving access token to keychain"
        
        case .saveUserMailKeychainFailed:
            return "Security: failed to save user email in secure keychain storage"
            
        case .userDefaultsFailed:
            return "Error: UserDefaults"
            
        case .remoteConfigFailed:
            return "System: error getting remote configuration from server"
            
        case .biometryNotAvailable:
            return "Biometry: hardware or permissions are not available on this device"
            
        case .biometryCancelAuthentication:
            return "Biometry: user explicitly cancelled the biometric authentication"
            
        case .biometryAuthenticationFailed:
            return "Biometry: the biometric authentication failed"
            
        case .invalidURL(let url):
            return "Invalid Supabase URL: \(url)"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .saveTokenAccessKeychainFailed, .readUserMailKeychainFailed:
            return "msn_proccessing_information_secure"
        
        case .biometryNotAvailable:
            return "msn_biometry_not_available_error"
            
        case .biometryAuthenticationFailed:
            return "msn_biometry_not_failed_error"
 
        default:
            return ""
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .readUserMailKeychainFailed:
            return "read_user_mail_keychain_failed"
            
        case .saveTokenAccessKeychainFailed:
            return "save_token_access_keychain_failed"
            
        case .saveUserMailKeychainFailed:
            return "save_user_mail_keychain_failed"
            
        case .userDefaultsFailed:
            return "user_defaults_failed"
            
        case .remoteConfigFailed:
            return "remote_config_failed"
            
        case .invalidURL:
            return "invalid_url"
            
        default:
            return ""
        }
    }
    
    public var isShouldTrack: Bool {
        switch self {
        case .biometryNotAvailable, .biometryAuthenticationFailed, .biometryCancelAuthentication:
            return false
            
        default:
            return true
        }
    }
}
