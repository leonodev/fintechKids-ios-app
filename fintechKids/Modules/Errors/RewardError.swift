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
    case createRewardFailed

    var logMessage: String {
        switch self {
            
        case .fetchListRewardFailed:
            return "Error: fetching list reward"
            
        case .createRewardFailed:
            return "Error: creating reward"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .fetchListRewardFailed:
            return "msn_error_fetch_rewards"
            
        case .createRewardFailed:
            return "msn_error_create_reward"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .fetchListRewardFailed:
            return "fetch_rewards_failed"
            
        case .createRewardFailed:
            return "create_reward_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
