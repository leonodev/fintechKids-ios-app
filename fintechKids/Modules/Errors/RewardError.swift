//
//  FHKRewardError.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/4/26.
//

import FHKUtils
import FHKDomain

enum FHKRewardError: FHKError {
    case fetchListRewardFailed

    var logMessage: String {
        switch self {
            
        case .fetchListRewardFailed:
            return "Error: fetching list reward"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .fetchListRewardFailed:
            return "msn_error_fetch_rewards"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .fetchListRewardFailed:
            return "fetch_rewards_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
