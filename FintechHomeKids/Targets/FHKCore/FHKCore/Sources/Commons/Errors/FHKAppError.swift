//
//  FHKNetworkError.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

import FLibUtils

public enum FHKAppError: FHKError, Sendable, Equatable {
    // Storage & Device
    case readUserMailKeychainFailed
    case saveTokensKeychainFailed
    case saveUserMailKeychainFailed
    case userDefaultsFailed
    case remoteConfigFailed
    case biometryNotAvailable
    case biometryCancelAuthentication
    case biometryAuthenticationFailed
    case pinApproveFailed
    case familyNameFailed
    
    // Network & Transport
    case invalidURL(String)
    case notConnectedInternet
    case timeout
    case unauthorized
    case sslError
    case cancelled
    case decodingError
    case encodingError
    case emptyResponse
    case unknown
    
    // Backend Controlled Errors
    case backend(FHKBackendErrorCode, detail: String?)
    case apiError(statusCode: Int, detail: String?)
    
    public var logMessage: String {
        switch self {
        case .readUserMailKeychainFailed:
            return "Security: failed to read user email from secure keychain storage"
        case .saveTokensKeychainFailed:
            return "Security: failure saving tokens to keychain"
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
        case .pinApproveFailed:
            return "PIN: the pin validation failed"
        case .familyNameFailed:
            return "Family name failed"
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .notConnectedInternet:
            return "Not detected internet connection"
        case .timeout:
            return "The application took longer than usual"
        case .unauthorized:
            return "You are not authorized to access this resource"
        case .sslError:
            return "An error has occurred with the certificates"
        case .cancelled:
            return "Network request was cancelled"
        case .decodingError:
            return "Failed to decode server JSON response"
        case .encodingError:
            return "Failed to encode request payload"
        case .emptyResponse:
            return "Server returned an empty response body"
        case .unknown:
            return "Unexpected network error"
        case .backend(let code, let detail):
            return "Backend Error [\(code.rawValue)]: \(detail ?? "No detail")"
        case .apiError(let statusCode, let detail):
            return "API Error (\(statusCode)): \(detail ?? "Unknown detail")"
        }
    }
    
    public var msnLocalizedKey: String {
        switch self {
        case .saveTokensKeychainFailed, .readUserMailKeychainFailed:
            return "msn_proccessing_information_secure"
        case .biometryNotAvailable:
            return "msn_biometry_not_available_error"
        case .biometryAuthenticationFailed:
            return "msn_biometry_not_failed_error"
        case .pinApproveFailed, .familyNameFailed:
            return "msn_generic_error"
        case .notConnectedInternet:
            return "msn_not_connection_internet_error"
        case .timeout:
            return "timeout_internet_error"
        case .unauthorized:
            return "unauthorized_error"
        case .sslError:
            return "ssl_certificates_error"
        case .backend(let code, _):
            return code.localizedKey
        default:
            return ""
        }
    }
    
    // They cannot exceed 100 characters.
    public var analyticsIdentifier: String? {
        switch self {
        case .readUserMailKeychainFailed:
            return "read_user_mail_keychain_failed"
        case .saveTokensKeychainFailed:
            return "save_tokens_access_keychain_failed"
        case .saveUserMailKeychainFailed:
            return "save_user_mail_keychain_failed"
        case .userDefaultsFailed:
            return "user_defaults_failed"
        case .remoteConfigFailed:
            return "remote_config_failed"
        case .invalidURL:
            return "invalid_url"
        case .pinApproveFailed:
            return "pin_approve_failed"
        case .familyNameFailed:
            return "family_name_failed"
        case .notConnectedInternet:
            return "not_connected_internet_failed"
        case .timeout:
            return "timeout_failed"
        case .unauthorized:
            return "unauthorized_failed"
        case .sslError:
            return "ssl_certificates_failed"
        case .cancelled:
            return "request_cancelled"
        case .decodingError:
            return "decoding_error"
        case .encodingError:
            return "encoding_error"
        case .emptyResponse:
            return "empty_response"
        case .backend(let code, _):
            return code.rawValue.lowercased()
        case .apiError(let statusCode, _):
            return "api_error_\(statusCode)"
        case .unknown:
            return "unknown_error"
        default:
            return nil
        }
    }
    
    public var isShouldTrack: Bool {
        switch self {
        case .biometryNotAvailable, .biometryAuthenticationFailed, .biometryCancelAuthentication, .cancelled:
            return false
        default:
            return true
        }
    }
}
