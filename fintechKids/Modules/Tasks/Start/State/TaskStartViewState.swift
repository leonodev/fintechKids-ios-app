//
//  TaskStartViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 22/3/26.
//

import Observation
import FHKUtils
import FHKDomain

@Observable
public class TaskStartViewState {
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
}
