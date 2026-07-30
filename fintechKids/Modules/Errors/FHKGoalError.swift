//
//  FHKGoalError.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/3/26.
//

import FHKUtils
import FHKDomain

enum FHKGoalError: FHKError {
    case createGoalFailed
    case fetchListGoalFailed
    case fetchListMemberGoalFailed
    case goalValueInvalid
    case rewardsTypeInvalid
    case durationTypeInvalid
    
    var logMessage: String {
        switch self {
            
        case .createGoalFailed:
            return "Error: creating new goal"
            
        case .fetchListGoalFailed:
            return "Error: fetching list of goals"
            
        case .goalValueInvalid:
            return "Error: value of goal is invalid"
            
        case .rewardsTypeInvalid:
            return "Error: rewards type is invalid"
            
        case .durationTypeInvalid:
            return "Error: duration type is invalid"
            
        case .fetchListMemberGoalFailed:
            return "Error: fetching list of goals of members"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .createGoalFailed:
            return "msn_error_create_goal"
            
        case .fetchListGoalFailed:
            return "msn_error_fetch_goal_list"
            
        case .goalValueInvalid:
            return "msn_error_value_goal"
            
        case .rewardsTypeInvalid:
            return "msn_error_reward_type_goal"
            
        case .durationTypeInvalid:
            return "msn_error_duration_type_goal"
            
        case .fetchListMemberGoalFailed:
            return "msn_error_fetch_goal_list"
        }
    }
    
    // They cannot exceed 100 characters.
    var analyticsIdentifier: String? {
        switch self {
        case .createGoalFailed:
            return "create_goal_failed"
            
        case .fetchListGoalFailed:
            return "fetch_goal_failed"
            
        case .goalValueInvalid:
            return "value_goal_invalid"
            
        case .rewardsTypeInvalid:
            return "type_reward_invalid"
            
        case .durationTypeInvalid:
            return "type_duration_invalid"
            
        case .fetchListMemberGoalFailed:
            return "fetch_goal_members_failed"
        }
    }
    
    public var isShouldTrack: Bool {
        switch self {
        case .createGoalFailed, .fetchListGoalFailed, .fetchListMemberGoalFailed:
            return true
            
        default:
            return false
        }
    }
}
