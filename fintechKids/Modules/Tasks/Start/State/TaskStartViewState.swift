//
//  TaskStartViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 22/3/26.
//

import Observation
import FHKUtils
import FHKDomain
import FHKDesignSystem

@Observable
public class TaskStartViewState {
    public var selectedRewardType: WorkType?
    
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
