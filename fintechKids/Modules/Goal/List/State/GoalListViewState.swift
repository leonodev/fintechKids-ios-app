//
//  GoalListViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/3/26.
//

import Foundation
import Observation
import FHKUtils
import FHKDomain
import FHKDesignSystem

@Observable
public class GoalListViewState {
    // Properties Observable
   
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    public var msnReachGoalCoin: String {
        "msn_reach_goal_coin".localized().capitalizingFirstLetter()
    }
    
    public var msnReachGoalTime: String {
        "msn_reach_goal_time".localized().capitalizingFirstLetter()
    }
    
    public var msnGoalEmpty: String {
        "msn_goal_empty".localized().capitalizingFirstLetter()
    }
    
    public func getMassageGoalCard(measureType: String) -> String {
        if measureType.lowercased() == WorkType.coins.value.lowercased() {
            return msnReachGoalCoin
        } else {
            return msnReachGoalTime
        }
    }
    
    public func getHeightImageCard(measureType: String) -> CGFloat {
        if measureType.lowercased() == WorkType.coins.value.lowercased() {
            return 200
        } else {
            return 160
        }
    }
    
    public func getLottieAnimation(measureType: String) -> String {
        if measureType.lowercased() == WorkType.coins.value.lowercased() {
            return Lotties.coin
        } else {
            return Lotties.hours
        }
    }
    
    public var msnUserError: String = ""
    
    public enum State: Equatable {
        case loading
        case empty
        case loaded
        case finish(result: ActionResult)
    }
    
    public var goalListState: State = .empty
    public var goalList: [GoalEntity] = []
}
