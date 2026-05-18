//
//  BalanceError.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/4/26.
//

import FHKUtils
import FHKDomain

enum FHKBalanceError: FHKError {
    case fetchBalanceFailed
    case updateBalanceFailed
    
    var logMessage: String {
        switch self {
            
        case .fetchBalanceFailed:
            return "Error: fetching balance"
            
        case .updateBalanceFailed:
            return "Error: update balance"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .fetchBalanceFailed:
            return "msn_error_fetch_balance"
            
        case .updateBalanceFailed:
            return "msn_update_balance_fail"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .fetchBalanceFailed:
            return "fetch_balance_failed"
            
        case .updateBalanceFailed:
            return "db_table_name_unknown"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
