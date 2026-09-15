//
//  FHKHomeError.swift
//  FHKHome
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FLibUtils
import FHKCore

enum FHKHomeError: FHKError {
    case logoutUserFailed
    
    var msnLocalizedKey: String {
        switch self {
        case .logoutUserFailed:
            return "msn_error_logout"
        }
    }
    
    var logMessage: String {
        switch self {
        case .logoutUserFailed:
            return "Error: User logout process failed"
        }
    }
    
    var analyticsIdentifier: String? {
        switch self {
        case .logoutUserFailed:
            return "user_logout_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
