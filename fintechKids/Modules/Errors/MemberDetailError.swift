//
//  MemberDetailError.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/4/26.
//

import FHKUtils
import FHKDomain

enum FHKMemberDetailError: FHKError {
    case getBalanceFailed
    
    var logMessage: String {
        switch self {
        case .getBalanceFailed:
            return "Error: getting balance"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .getBalanceFailed:
            return "msn_error_fetch_balance"
        }
    }
    
    var analyticsIdentifier: String? {
        switch self {
        case .getBalanceFailed:
            return "fetch_balance_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
