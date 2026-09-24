//
//  FHKRewardListViewState.swift
//  FHKRewards
//
//  Created by Fredy Leon on 21/9/26.
//

import Observation
import FLibUtils
import FHKDesignSystem
import FHKDomain
import FHKCore

@MainActor
public struct FHKRewardListViewState {
    
    public enum State: Equatable {
        case loading
        case empty
        case loaded
        case finish(result: FHKActionResult)
    }
    
    public var rewardListState: State = .empty
    public var rewardList: [FHKRewardEntity] = []
    public var goalList: [FHKGoalEntity] = []
    public var msnUserError: String = ""
    
    public var rewardsTitle: String {
        "title_rewards".localized.uppercased()
    }
    
    public var msnRewardsEmpty: String {
        "msn_rewards_empty".localized().capitalizingFirstLetter()
    }
    
    public var msnLoading: String {
        "msn_rewards_loading".localized().capitalizingFirstLetter()
    }
    
    public var titleHours: String {
        "title_hours".localized().capitalizingFirstLetter()
    }
}

