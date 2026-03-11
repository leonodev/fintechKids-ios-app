//
//  FHKAppError.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/2/26.
//

import FHKUtils
import FHKDomain

enum FHKAppError: FHKError {
    case loginUserFailed
    case logoutUserFailed
    case registerUserFailed
    case addMembersFailed
    case supabaseClientFailed
    case fetchMembersFailed
    case userDefaultsFailed
 
    var logMessage: String {
        switch self {
  
        case .loginUserFailed:
            return "Error: User login process failed"
            
        case .logoutUserFailed:
            return "Error: User logout process failed"
 
        case .registerUserFailed:
            return "Error: User registration failed"
            
        case .addMembersFailed:
            return "Error: Adding family members failed"
            
        case .supabaseClientFailed:
            return "Error: Supabase client not configured"
            
        case .fetchMembersFailed:
            return "Error: Fetching family members failed"
            
        case .userDefaultsFailed:
            return "Error: UserDefaults"
        }
    }
    
    var messageUI: String {
        switch self {
            
        case .loginUserFailed:
            return "invalid_credentials_error".localized().capitalizingFirstLetter()
            
        case .logoutUserFailed:
            return "msn_error_logout".localized().capitalizingFirstLetter()
            
        case .registerUserFailed:
            return "msn_register_user_error".localized().capitalizingFirstLetter()
            
        case .addMembersFailed:
            return "msn_add_new_member_error".localized().capitalizingFirstLetter()
            
        case .supabaseClientFailed:
            return "msn_unexpected_error".localized().capitalizingFirstLetter()
            
        case .fetchMembersFailed:
            return "msn_fetch_members_error".localized().capitalizingFirstLetter()
            
        default:
            return ""
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
