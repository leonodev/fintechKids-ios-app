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
    case getInfoFamilyFailed
    case addMembersFailed
    
    
    var logMessage: String {
        switch self {
        case .getBalanceFailed:
            return "Error: getting balance"
            
        case .getMemberByIdFailed:
            return "Error: getting Member by ID"
            
        case .getInfoFamilyFailed:
            return "Error: getting family information"
            
        case .addMembersFailed:
            return "Error: Adding family members failed"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .getBalanceFailed:
            return "msn_error_fetch_balance"
            
        case .getMemberByIdFailed:
            return "msn_error_fetch_member"
            
        case .getInfoFamilyFailed:
            return "msn_error_fetch_family_info"
            
        case .addMembersFailed:
            return "msn_add_new_member_error"
        }
    }
    
    var analyticsIdentifier: String? {
        switch self {
        case .getBalanceFailed:
            return "fetch_balance_failed"
            
        case .getMemberByIdFailed:
            return "fetch_member_failed"
            
        case .getInfoFamilyFailed:
            return "fetch_family_info_failed"
            
        case .addMembersFailed:
            return "add_family_member_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
