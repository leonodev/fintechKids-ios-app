//
//  FHKGoalCreateViewState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 20/9/26.
//

import Observation
import FLibUtils
import FHKDesignSystem
import FHKDomain
import FHKCore

@MainActor
public struct FHKGoalCreateViewState {
    
    public var goalName: String = ""
    public var selectedGoalType: FHKWorkType?
    public var selectedDurationType: FHKDurationType?
    public var rewardsValue: String = ""
    public var msnUserError: String = ""
    
    public var goalTitle: String {
        "goal".localized.capitalizingFirstLetter()
    }
    
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
    
    public var goalNamePlaceholder: String {
        "title_placeholder_name_goal".localized.capitalizingFirstLetter()
    }
    
    public var rewardsValuePlaceholder: String {
        "goal_rewards_value_placeholder".localized.capitalizingFirstLetter()
    }
    
    public var titleHowGetGoal: String {
        "title_how_get_goal".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnCreateGoal: String {
        "title_btn_create_goal".localized.uppercased()
    }
    
    public var titleButtonContinue: String {
        "continue".localized.uppercased()
    }
    
    public var titleBtnOperationError: String {
        "title_btn_operation_error".localized.capitalizingFirstLetter()
    }
    
    public var msnCreateGoalSuccess: String {
        "msn_create_goal_success".localized.capitalizingFirstLetter()
    }
    
    public var msnCreateGoalFail: String {
        "msn_create_goal_error".localized.capitalizingFirstLetter()
    }
    
    public var msnWarningMissingGoalType: String {
        "goal_type_missing".localized.capitalizingFirstLetter()
    }
    
    public var msnWarningMissingEmail: String {
        "email_error".localized.capitalizingFirstLetter()
    }
    
    public var msnWarningMissingValue: String {
        "value_missing".localized.capitalizingFirstLetter()
    }
    
    public var msnWarningMissingDuration: String {
        "duration_missing".localized.capitalizingFirstLetter()
    }
    
    public func toastInfo(msn: String, type: ToastType) -> FHKToastInfo {
        FHKToastInfo(type: type, message: msn, hasIcon: true)
    }
    
    public func valueReal(value: String) -> String {
        let euroValue: Double = (Double(value) ?? 0) / 2
        let valueFormatted = euroValue.formattedValue(showDecimals: true)
        let msnValue = "msn_value_real_goal".localized
        return "\(msnValue)\(valueFormatted)"
    }
    
    public var isShowRewardOptions: Bool {
        selectedDurationType != nil
    }

    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
    }
    
    public var goalState: State = .loaded
    
    let workTimeType = [
        FHKRadioOption(value: FHKWorkType.time,
                       label: "title_in_time".localized.capitalizingFirstLetter()),

        FHKRadioOption(value: FHKWorkType.coins,
                       label: "title_in_coins".localized.capitalizingFirstLetter())
    ]

    let workDurationType = [
        FHKRadioOption(value: FHKDurationType.hours,
                       label: "title_hours".localized.capitalizingFirstLetter()),

        FHKRadioOption(value: FHKDurationType.days,
                       label: "title_days".localized.capitalizingFirstLetter()),

        FHKRadioOption(value: FHKDurationType.weeks,
                       label: "title_weeks".localized.capitalizingFirstLetter()),

        FHKRadioOption(value: FHKDurationType.months,
                       label: "title_month".localized.capitalizingFirstLetter())
    ]
}
