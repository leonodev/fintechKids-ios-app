//
//  FHKRewardCreateViewState.swift
//  FHKRewards
//
//  Created by Fredy Leon on 24/9/26.
//

import FHKDesignSystem
import FHKCore

@MainActor
public struct FHKRewardCreateViewState {
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
    }
    
    // Properties Observable
    public var name = ""
    public var timeRequired = ""
    public var coinsRequired = ""
    
    public var selectedDurationType: FHKDurationType?
    
    public var rewardsCreateTitle: String {
        "create_reward_title".localized.uppercased()
    }
    
    // Placeholder
    public var namePlaceholder: String {
        "name_create_reward_placeholder".localized.capitalizingFirstLetter()
    }
    
    public var timeRequiredPlaceholder: String {
        "time_required_create_reward_placeholder".localized.capitalizingFirstLetter()
    }
    
    public var coinsRequiredPlaceholder: String {
        "coins_required_create_reward_placeholder".localized.capitalizingFirstLetter()
    }
    
    public var createState: State = .loaded
    public var msnUserError: String = ""
    
    public var msnLoading: String {
        "msn_create_reward_loading".localized.capitalizingFirstLetter()
    }
    
    public var buttonCreateRewardTitle: String {
        "create_reward_title".localized.capitalizingFirstLetter()
    }
    
    public var msnCreateRewardInstruction: String {
        "msn_create_reward_instruction".localized.capitalizingFirstLetter()
    }
    
    public var msnWarningMissingEmail: String {
        "email_error".localized.capitalizingFirstLetter()
    }
    
    public var msnErrorCannotCreateReward: String {
        "msn_error_cannot_create_reward".localized.capitalizingFirstLetter()
    }
    
    public var msnCreateRewardSuccess: String {
        "msn_create_reward_success".localized.capitalizingFirstLetter()
    }
    
    public var msnCreateRewardFail: String {
        "msn_create_reward_fail".localized.capitalizingFirstLetter()
    }
    
    public var titleButtonContinue: String {
        "continue".localized.uppercased()
    }
    
    var isBtnCreateRewardEnable: FHKButtonComponent.State {
        !name.isEmpty && !timeRequired.isEmpty && !coinsRequired.isEmpty && selectedDurationType != nil
        ? .enabled
        : .disabled
    }
    
    public func toastInfo(msn: String, type: ToastType) -> FHKToastInfo {
        FHKToastInfo(type: type, message: msn, hasIcon: true)
    }
    
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
