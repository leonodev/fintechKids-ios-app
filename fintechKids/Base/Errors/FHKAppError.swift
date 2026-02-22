//
//  FHKAppError.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/2/26.
//

import Foundation
import FHKCore
import FHKUtils

enum FHKAppError: FHKError {
    case loginUserFailed
    case registerUserFailed
    case addMembersFailed
    case supabaseClientFailed
 
    var logMessage: String {
        switch self {
  
        case .loginUserFailed:
            return "Error: User login process failed"
 
        case .registerUserFailed:
            return "Error: User registration failed"
            
        case .addMembersFailed:
            return "Error: Adding family members failed"
            
        case .supabaseClientFailed:
            return "Error: Supabase client not configured"
        }
    }
    
    var messageUI: String {
        switch self {
            
        case .loginUserFailed:
            return "invalid_credentials_error".localized().capitalizingFirstLetter()
            
        case .registerUserFailed:
            return "msn_register_user_error".localized().capitalizingFirstLetter()
            
        case .addMembersFailed:
            return "msn_add_new_member_error".localized().capitalizingFirstLetter()
            
        case .supabaseClientFailed:
            return "msn_unexpected_error".localized().capitalizingFirstLetter()
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
