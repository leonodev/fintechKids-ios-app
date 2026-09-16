//
//  FHKMembersError.swift
//  FHKHome
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FLibUtils
import FHKCore

enum FHKMembersError: FHKError {
    case getBalanceFailed
    case getMemberByIdFailed
    
    
    var logMessage: String {
        switch self {
        case .getBalanceFailed:
            return "Error: getting balance"
            
        case .getMemberByIdFailed:
            return "Error: getting Member by ID"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .getBalanceFailed:
            return "msn_error_fetch_balance"
            
        case .getMemberByIdFailed:
            return "msn_error_fetch_member"
        }
    }
    
    var analyticsIdentifier: String? {
        switch self {
        case .getBalanceFailed:
            return "fetch_balance_failed"
            
        case .getMemberByIdFailed:
            return "fetch_member_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
