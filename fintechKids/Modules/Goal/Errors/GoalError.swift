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
    case goalValueInvalid
    case rewardsTypeInvalid
    case durationTypeInvalid
    
    var logMessage: String {
        switch self {
            
        case .createGoalFailed:
            return "Error: creating new goal"
            
        case .goalValueInvalid:
            return "Error: value of goal is invalid"
            
        case .rewardsTypeInvalid:
            return "Error: rewards type is invalid"
            
        case .durationTypeInvalid:
            return "Error: duration type is invalid"
        }
    }
    
    var msnLocalizedKey: String {
        switch self {
            
        case .createGoalFailed:
            return "msn_error_create_goal".localized().capitalizingFirstLetter()
            
        case .goalValueInvalid:
            return "msn_error_value_goal".localized().capitalizingFirstLetter()
            
        case .rewardsTypeInvalid:
            return "msn_error_reward_type_goal".localized().capitalizingFirstLetter()
            
        case .durationTypeInvalid:
            return "msn_error_duration_type_goal".localized().capitalizingFirstLetter()
        }
    }
    
    public var isShouldTrack: Bool {
        switch self {
        case .createGoalFailed:
            return true
            
        default:
            return false
        }
    }
}
