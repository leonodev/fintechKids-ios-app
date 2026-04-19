//
//  RewardCollectViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/3/26.
//

import SwiftUI
import Foundation
import Observation
import FHKUtils
import FHKDesignSystem
import FHKDomain

@Observable
public class RewardCollectViewState {
    
    public func getTitleTypeReceive(collectModel: CollectRewardModel) -> String {
        switch collectModel.receiveRewardType {
        case .sendToSavings where collectModel.rewardType == .coins:
            let msn = "msn_saving_coins".localized()
            return "\(msn) \(collectModel.task.coinsGranted) KidsCoins"
            
        case .sendToSavings where collectModel.rewardType == .time:
            let msn = "msn_saving_time".localized()
            return "\(msn) \(collectModel.task.timeGranted)"
            
        case .changeByRewards where collectModel.rewardType == .coins:
            let msn = "msn_change_rewards_by_coins".localized()
            return "\(collectModel.task.coinsGranted) KidsCoins \(msn)"
            
        case .changeByRewards where collectModel.rewardType == .time:
            let msn = "msn_change_rewards_by_time".localized()
            return "\(collectModel.task.timeGranted) \(msn)"
            
        case .assignToGoal where collectModel.rewardType == .coins:
            let msn = "msn_change_goals_by_coins".localized()
            return "\(msn) \(collectModel.task.coinsGranted) KidsCoins"
            
        case .assignToGoal where collectModel.rewardType == .time:
            let msn = "msn_change_goals_by_time".localized()
            return "\(msn) \(collectModel.task.timeGranted)"
            
        default:
            return "-"
        }
    }
    public var titleCreateNewTask: String {
        "title_create_new_task".localized().capitalizingFirstLetter()
    }
    
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
    
    public var msnRewardsEmpty: String {
        "msn_rewards_empty".localized().capitalizingFirstLetter()
    }
    
    public var msnChangeRewardEnable: String {
        "msn_change_reward_enable".localized().capitalizingFirstLetter()
    }
    
    public var msnChangeRewardDisabled: String {
        "msn_change_reward_disabled".localized().capitalizingFirstLetter()
    }
    
    public var msnChectAcceptCollect: String {
        "msn_check_accept_collect".localized().capitalizingFirstLetter()
    }
    
    public var titleBtnContinue: String {
        "continue".localized().uppercased()
    }
    
    public var msnUpdateBalanceSuccess: String {
        "msn_update_balance_success".localized().uppercased()
    }
    
    public var msnUpdateBalanceFail: String {
        "msn_update_balance_fail".localized().uppercased()
    }
    
    public func imageBanner(type: WorkType) -> Image {
        if type == .coins {
            return .fintechkidsCoins
                .resizable()
        } else {
            return .fintechkidsTime
                .resizable()
        }
    }
    
    public func getMassageGoalCard(measureType: String) -> String {
        if measureType.lowercased() == WorkType.coins.value.lowercased() {
            return msnReachGoalCoin
        } else {
            return msnReachGoalTime
        }
    }
    
    public func getLottieAnimation(measureType: String) -> String {
        if measureType.lowercased() == WorkType.coins.value.lowercased() {
            return Lotties.coin
        } else {
            return Lotties.hours
        }
    }
    
    public func getHeightImageCard(measureType: String) -> CGFloat {
        if measureType.lowercased() == WorkType.coins.value.lowercased() {
            return 200
        } else {
            return 160
        }
    }
    
    public var msnUserError: String = ""
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var collectState: State = .loading
    
    public var balance: BalanceEntity?
    public var goalList: [GoalEntity] = []
    public var rewardList: [RewardEntity] = []
}
