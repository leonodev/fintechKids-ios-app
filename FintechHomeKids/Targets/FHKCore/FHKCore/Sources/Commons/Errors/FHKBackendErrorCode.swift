//
//  FHKBackendErrorCode.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 23/11/2026.
//

import Foundation
import FLibUtils
/// Códigos controlados devueltos por FHKBackend (`{"error_code": "...", "detail": "..."}`)
public enum FHKBackendErrorCode: String, Decodable, Sendable, Equatable {
    // Authentication & Security
    case invalidCredentials = "INVALID_CREDENTIALS"
    case invalidOrExpiredToken = "INVALID_OR_EXPIRED_TOKEN"
    case invalidRefreshToken = "INVALID_REFRESH_TOKEN"
    case accountInactive = "ACCOUNT_INACTIVE"
    case emailAlreadyRegistered = "EMAIL_ALREADY_REGISTERED"
    case userNotFound = "USER_NOT_FOUND"
    case recoveryCodeNotRequested = "RECOVERY_CODE_NOT_REQUESTED"
    case recoveryCodeExpired = "RECOVERY_CODE_EXPIRED"
    case invalidRecoveryCode = "INVALID_RECOVERY_CODE"
    
    // Family Ownership
    case parentEmailNotFound = "PARENT_EMAIL_NOT_FOUND"
    case parentEmailMismatch = "PARENT_EMAIL_MISMATCH"
    
    // Family Members
    case familyMemberAlreadyExists = "FAMILY_MEMBER_ALREADY_EXISTS"
    case familyMemberNotFound = "FAMILY_MEMBER_NOT_FOUND"
    
    // Tasks, Goals, Rewards & Balances
    case taskNotFound = "TASK_NOT_FOUND"
    case goalNotFound = "GOAL_NOT_FOUND"
    case memberGoalNotFound = "MEMBER_GOAL_NOT_FOUND"
    case rewardNotFound = "REWARD_NOT_FOUND"
    case memberRewardNotFound = "MEMBER_REWARD_NOT_FOUND"
    case rewardNameOrIdRequired = "REWARD_NAME_OR_ID_REQUIRED"
    case memberBalanceNotFound = "MEMBER_BALANCE_NOT_FOUND"
    
    // System / Validation
    case validationError = "VALIDATION_ERROR"
    case httpError = "HTTP_ERROR"
    case internalServerError = "INTERNAL_SERVER_ERROR"
    
    /// Key de traducción en tu Localizable.xcstrings para cada error controlado
    public var localizedKey: String {
        switch self {
        case .invalidCredentials: return "error_invalid_credentials"
        case .invalidOrExpiredToken, .invalidRefreshToken: return "unauthorized_error"
        case .accountInactive: return "error_account_inactive"
        case .emailAlreadyRegistered: return "error_email_already_registered"
        case .userNotFound: return "error_user_not_found"
        case .recoveryCodeNotRequested: return "error_recovery_code_not_requested"
        case .recoveryCodeExpired: return "error_recovery_code_expired"
        case .invalidRecoveryCode: return "error_invalid_recovery_code"
        case .parentEmailNotFound, .parentEmailMismatch: return "error_parent_ownership"
        case .familyMemberAlreadyExists: return "error_member_already_exists"
        case .familyMemberNotFound: return "error_member_not_found"
        case .taskNotFound: return "error_task_not_found"
        case .goalNotFound, .memberGoalNotFound: return "error_goal_not_found"
        case .rewardNotFound, .memberRewardNotFound, .rewardNameOrIdRequired: return "error_reward_error"
        case .memberBalanceNotFound: return "error_balance_not_found"
        case .validationError: return "error_validation_failed"
        case .httpError, .internalServerError: return "error_server_generic"
        }
    }
}
