//
//  TaskCreateViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 14/3/26.
//

import Observation
import FHKUtils
import FHKDesignSystem

@Observable
public class TaskCreateViewState {
    
    // Properties Observable
    public var taskName: String = ""
    public var taskDescription: String = ""
    public var rewardsTime: String = ""
    public var rewardsKidsCoin: String = ""
    public var selectedDuration: String?
    
    public var titleCreateNewTask: String {
        "title_create_new_task".localized().capitalizingFirstLetter()
    }
    
    public var taskNamePlaceholder: String {
        "title_placeholder_name_task".localized().capitalizingFirstLetter()
    }
    
    public var titleDescriptionTask: String {
        "title_description_task".localized().capitalizingFirstLetter()
    }
    
    public var titleDurationType: String {
        "title_duration_type".localized().capitalizingFirstLetter()
    }
    
    public var titleRewardsType: String {
        "title_rewards_type".localized().capitalizingFirstLetter()
    }
    
    public var titleInTime: String {
        "title_in_time".localized().capitalizingFirstLetter()
    }
    
    public var titleInCoins: String {
        "title_in_coins".localized().capitalizingFirstLetter()
    }
    
    public var titleBtnCreateTask: String {
        "title_btn_create_task".localized().uppercased()
    }
    
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    public var titleBtnUnderstood: String {
        "title_btn_understood".localized().capitalizingFirstLetter()
    }
    
    public var msnCreateTaskSuccess: String {
        "msn_success_create_task".localized().capitalizingFirstLetter()
    }
    
    public var createTaskButtonState: FHKButtonComponent.State {
        !taskName.isEmpty && selectedDuration != nil && !rewardsTime.isEmpty && !rewardsKidsCoin.isEmpty
        ? .enabled
        : .disabled
    }
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var taskCreateState: State = .loaded
    public var msnUserError: String = ""
    
    let durationOptions = [
        FHKRadioOption(value: "title_hours".localized().capitalizingFirstLetter(),
                       label: "title_hours".localized().capitalizingFirstLetter()),
        
        FHKRadioOption(value: "title_days".localized().capitalizingFirstLetter(),
                       label: "title_days".localized().capitalizingFirstLetter()),
        
        FHKRadioOption(value: "title_weeks".localized().capitalizingFirstLetter(),
                       label: "title_weeks".localized().capitalizingFirstLetter()),
        
        FHKRadioOption(value: "title_month".localized().capitalizingFirstLetter(),
                       label: "title_month".localized().capitalizingFirstLetter())
    ]
}
