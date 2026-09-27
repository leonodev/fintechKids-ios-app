//
//  FHKMembersError.swift
//  FHKHome
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FLibUtils
import FHKCore

enum FHKRewardError: FHKError {
    case fetchListRewardFailed
    case createRewardFailed
    case fetchListGoalFailed
    case fetchListMemberGoalFailed
    case fetchBalanceFailed

    var logMessage: String {
        switch self {
            
        case .fetchListRewardFailed:
            return "Error: fetching list reward"
            
        case .createRewardFailed:
            return "Error: creating reward"
            
        case .fetchListGoalFailed:
            return "Error: fetching list of goals"
            
        case .fetchListMemberGoalFailed:
            return "Error: fetching list of goals of members"
            
        case .fetchBalanceFailed:
            return "msn_error_fetch_balance"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .fetchListRewardFailed:
            return "msn_error_fetch_rewards"
            
        case .createRewardFailed:
            return "msn_error_create_reward"
            
        case .fetchListGoalFailed:
            return "msn_error_fetch_goal_list"
            
        case .fetchListMemberGoalFailed:
            return "msn_error_fetch_goal_list"
            
        case .fetchBalanceFailed:
            return "msn_error_fetch_balance"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .fetchListRewardFailed:
            return "fetch_rewards_failed"
            
        case .createRewardFailed:
            return "create_reward_failed"
            
        case .fetchListGoalFailed:
            return "fetch_goal_failed"
            
        case .fetchListMemberGoalFailed:
            return "fetch_goal_members_failed"
            
        case .fetchBalanceFailed:
            return "fetch_balance_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        true
    }
}
