//
//  ProfileError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/3/26.
//

import FHKUtils
import FHKDomain

enum FHKProfileError: FHKError {
    case logoutUserFailed
    
    var logMessage: String {
        switch self {
        case .logoutUserFailed:
            return "Error: User logout process failed"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .logoutUserFailed:
            return "msn_error_logout"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
