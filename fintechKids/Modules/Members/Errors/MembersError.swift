//
//  MembersError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/3/26.
//

import FHKUtils
import FHKDomain

enum FHKMembersError: FHKError {
    case addMembersFailed
    
    var logMessage: String {
        switch self {
        case .addMembersFailed:
            return "Error: Adding family members failed"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .addMembersFailed:
            return "msn_add_new_member_error"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
