//
//  FHKMemberDetailState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//


import SwiftUI
import FLibUtils
import FHKDesignSystem
import FHKDomain
import FHKCore

@MainActor
public struct FHKMemberDetailState {
    public var member: FHKMemberEntity? = nil
    var menuTabBarItems: [FHKMenuTabBar.Item] = [
        FHKMenuTabBar.Item(title: "expenses".localized.capitalizingFirstLetter(),
                           activeIcon: Image.expansiveMemberEnable,
                           lockedIcon: Image.expansiveMemberDisable),
        
        FHKMenuTabBar.Item(title: "loans".localized.capitalizingFirstLetter(),
                           activeIcon: Image.loansMemberEnable,
                           lockedIcon: Image.loansMemberDisable),
        
        FHKMenuTabBar.Item(title: "Item 3", // Move
                           activeIcon: Image.movementsMemberEnable,
                           lockedIcon: Image.movementsMemberDisable),
        
        FHKMenuTabBar.Item(title: "Item 4", // Tranfers
                           activeIcon: Image.transferMemberEnable,
                           lockedIcon: Image.transferMemberDisable)
    ]
    
    
    let cardGradients: [LinearGradient] = [
            .cardBlue,
            .cardYellow
        ]
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
    }
    
    public var memberState: State = .loading
    
    public var balance: FHKBalanceEntity?
    public var msnUserError: String = ""
    
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
    
    public var titleMyGoals: String {
        "title_my_goals".localized
    }
    
    public var titleMyRewards: String {
        "title_my_rewards".localized
    }
    
    public var titleWelcome: String {
        "title_welcome".localized
    }
    
    public var titleLevel: String {
        "title_level".localized
    }
    
    public var titleViewTask: String {
        "title_view_task".localized
    }
    
    public var avatarUser: Image {
        member?.avatarName.getAvatar ??
        FHKDesignSystemAsset.Images.boy9.name.getAvatar
    }
}
