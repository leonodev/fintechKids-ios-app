//
//  HomeError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/3/26.
//

import FHKUtils
import FHKDomain

enum FHKHomeError: FHKError {
    case fetchMembersFailed
    
    var logMessage: String {
        switch self {
        case .fetchMembersFailed:
            return "Error: Fetching family members failed"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
        case .fetchMembersFailed:
            return "msn_fetch_members_error"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
