//
//  HomeViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import SwiftUI
import Observation
import FHKDesignSystem
import FHKUtils
import FHKDomain

@Observable
public class HomeViewState {
    var options: [FloatMenu.Option]
    var menuTabBarItems: [FHKMenuTabBar.Item] = []
    var parentEmail: String?

    public var errorNameMember: String {
        "error_name_member".localized().capitalizingFirstLetter()
    }
    
    public var errorRecoveryInfoUser: String {
        "msn_recovery_info_user_error".localized().capitalizingFirstLetter()
    }
    
    public var errorFetchMembers: String {
        "msn_fetch_members_error".localized().capitalizingFirstLetter()
    }
    
    public var errorRewardCollect: String {
        "msn_fetch_rewards_collect_error".localized().capitalizingFirstLetter()
    }
    
    public var msnErrorFetchGoalList: String {
        "msn_error_fetch_goal_list".localized().capitalizingFirstLetter()
    }
    
    public var titleMemberFamily: String {
        "title_members_family".localized().uppercased()
    }
    
    public var titleRewardsCollected: String {
        "title_rewards_collected".localized().uppercased()
    }
 
    public var titleBtnPay: String {
        "title_pay".localized().uppercased()
    }
    
    public var titleDataUnavailable: String {
        "title_data_unavailable".localized().capitalizingFirstLetter()
    }
    
    public var msnGoalsInCurse: String {
        "msn_goals_in_curse".localized().uppercased()
    }
    
    public var stateItemMemberComponent: ComponentState = .skeleton
    
    // Independent states by component
    public var familyState: ComponentStateType = .skeleton
    public var rewardsState: ComponentStateType = .skeleton
    public var goalMemberState: ComponentStateType = .skeleton

    init() {
        options = [
            .init(title: "title_menu_members".localized().capitalizingFirstLetter(),
                  image: .init(systemName: "person.crop.circle.badge.plus"),
                  color: FHKColor.wine,
                  menuType: .members),
            
            .init(title: "title_menu_tasks".localized().capitalizingFirstLetter(),
                  image: .init(systemName: "house"),
                  color: FHKColor.wine.opacity(0.8),
                  menuType: .tasks),
            
            .init(title: "title_menu_goals".localized().capitalizingFirstLetter(),
                  image: .init(systemName: "note.text.badge.plus"),
                  color: FHKColor.ultraPurple.opacity(0.8),
                  menuType: .goals),
            
            .init(title: "title_menu_rewards".localized().capitalizingFirstLetter(),
                  image: .init(systemName: "gamecontroller"),
                  color: FHKColor.ultraPurple,
                  menuType: .rewards)
        ]
    }
    
    public func settingMenuOption(items: [MenuHomeItem]) {
        for item in items {
            menuTabBarItems.append(
                FHKMenuTabBar.Item(title: item.label_localized_key.localized().capitalizingFirstLetter(),
                                   activeIcon: getIconMenuHome(option: item.name),
                                   lockedIcon: getIconMenuHome(option: item.name, isEnable: false),
                                   isDisabled: !item.active)
            )
        }
    }
    
    public func getStateItemMemberComponent(memberName: String, avatarName: String) -> ComponentStateType {
        let isInfoComplete = !memberName.isEmpty && !avatarName.isEmpty
        return isInfoComplete ? .loaded : .error(errorNameMember)
    }
}

private extension HomeViewState {
    func getIconMenuHome(option: String, isEnable: Bool = true) -> Image {
        switch option {
        case "payments":
            isEnable ? .menuPaymentEnable : .menuPaymentDisabled
            
        case "transfers":
            isEnable ?  .menuTransferEnable : .menuTransferDisabled
            
        case "loans":
            isEnable ?  .menuLoansEnable : .menuLoansDisabled
            
        case "savings":
            isEnable ?  .menuSavingsEnable : .menuSavingsDisabled
            
        default:
            Image("")
        }
    }
}
