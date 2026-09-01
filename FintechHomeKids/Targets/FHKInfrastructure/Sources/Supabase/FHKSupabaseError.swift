//
//  FHKSupabaseError.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

/// Codes API Doc: https://www.postgresql.org/docs/current/errcodes-appendix.html

import FHKCore

public enum FHKSupabaseError: Error {
    
    // Errors Auth
    case emailAddressInvalid
    case invalidCredentials(context: String? = nil)
    case userNotFound
    case emailNotConfirmed
    case otpExpired
    case tooManyRequests
    case userAlreadyExists(context: String? = nil)
    case accessToken
    case notImplemented
    
    // Errors PostgREST
    case dateInvalid(context: String? = nil)          // Error 22007: Incorrect date format
    case nameAlreadyExists(context: String? = nil)    // Error 23505: A record with that name already exists.
    case missingRequiredField(context: String? = nil) // Error 23502: A required field is missing.
    case tableNameUnknown(context: String? = nil)     // Error 42P01: relation "members_table" does not exist.
    case networkError         // Anywhere Clase 08: Connection failure or timeout
    case unknown(String)      // For any other unmapped errors
    
    public static func from(errorCode: String) -> FHKSupabaseError {
        switch errorCode {
            
        case "email_address_invalid":
            return .emailAddressInvalid
                
        case "invalid_credentials":
            return .invalidCredentials(context: nil)
            
        case "user_not_found":
            return .userNotFound
            
        case "email_not_confirmed":
            return .emailNotConfirmed
            
        case "otp_expired":
            return .otpExpired
            
        case "too_many_requests":
            return .tooManyRequests
          
        case "user_already_exists":
            return .userAlreadyExists(context: nil)
            
        default:
            return .unknown(errorCode)
        }
    }
}


public protocol FHKSupabaseErrorProtocol {
    func mapPostgresError(_ code: String, message: String) -> FHKSupabaseError
}

/// Codes API Doc: https://www.postgresql.org/docs/current/errcodes-appendix.html
public extension FHKSupabaseErrorProtocol {
    
    func mapPostgresError(_ code: String, message: String) -> FHKSupabaseError {
        switch code {
        case "22007":
            return .dateInvalid(context: message)
            
        case "23505":
            return .nameAlreadyExists(context: message)
            
        case "23502":
            return .missingRequiredField(context: message)
            
        case "42P01":
            return .tableNameUnknown(context: message)
            
        default:
            // We group by class prefix
            if code.hasPrefix("08") {
                return .networkError
            }
            return .unknown("Code: \(code) - \(message)")
        }
    }
}

