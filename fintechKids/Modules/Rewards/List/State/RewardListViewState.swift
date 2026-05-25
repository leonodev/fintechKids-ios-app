//
//  RewardListViewState.swift
//  fintechKids
//
//  Created by fleon  on 25/5/26.
//

import Foundation
import Observation
import FHKUtils
import FHKDomain
import FHKDesignSystem

@Observable
public class RewardListViewState {

    public enum State: Equatable {
        case loading
        case empty
        case loaded
        case finish(result: ActionResult)
    }
    
    public var rewardListState: State = .empty
    public var rewardList: [RewardEntity] = []
    public var goalList: [GoalEntity] = []
    public var msnUserError: String = ""
    
    public var rewardsTitle: String {
        "title_rewards".localized().capitalizingFirstLetter()
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
