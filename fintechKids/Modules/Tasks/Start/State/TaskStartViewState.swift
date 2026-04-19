//
//  TaskStartViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 22/3/26.
//

import Foundation
import Observation
import FHKUtils
import FHKDomain
import FHKDesignSystem

@Observable
public class TaskStartViewState {
    public var selectedRewardType: WorkType?
    // Propiedad computada
    
    // Properties Observable
    public var titleDescription: String {
        "title_task_description".localized().capitalizingFirstLetter()
    }
    
    public var titleRewards: String {
        "title_rewards".localized().capitalizingFirstLetter()
    }
    
    public var titleStart: String {
        "title_start".localized().uppercased()
    }
    
    public var titleStop: String {
        "title_stop".localized().uppercased()
    }
    
    public var titleReset: String {
        "title_reset".localized().uppercased()
    }
    
    public var titleApproved: String {
        "title_approved".localized().capitalizingFirstLetter()
    }
    
    public var titleCancel: String {
        "cancel".localized().capitalizingFirstLetter()
    }
    
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    public var titleHowReceiveReward: String {
        "title_how_receive_reward".localized().capitalizingFirstLetter()
    }
    
    public var titleSendSavings: String {
        "title_send_to_savings".localized().capitalizingFirstLetter()
    }
    
    public var titleChangeRewards: String {
        "title_change_by_rewards".localized().capitalizingFirstLetter()
    }
    
    public var titleAssignMyGoals: String {
        "title_assign_to_my_goals".localized().capitalizingFirstLetter()
    }
    
    public var collectTypeError: String {
        "msn_reward_type_missing".localized().capitalizingFirstLetter()
    }
    
    public func toastInfo(msn: String, type: ToastType) -> FHKToastInfo {
        FHKToastInfo(type: type, message: msn, hasIcon: true)
    }
 
    public var dedicatedTimeTask: TimeInterval?
    
    public var buttonAprovalState: FHKButtonComponent.State {
        
        guard let time = dedicatedTimeTask, time > 0 else {
            return FHKButtonComponent.State.disabled
        }
            return FHKButtonComponent.State.enabled
    }
    
    public enum State: Equatable {
        case loading
        case loaded
        case confirmation
    }
    
    public var startTaskState: State = .loaded
    
    let rewardsOptions = [
        FHKRadioOption(value: WorkType.time,
                       label: "title_in_time".localized().capitalizingFirstLetter()),
        
        FHKRadioOption(value: WorkType.coins,
                       label: "title_in_coins".localized().capitalizingFirstLetter())
    ]
}
