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

@Observable
public class HomeViewState {
    var options: [FloatMenu.Option]

    public var errorNameMember: String {
        "error_name_member".localized().capitalizingFirstLetter()
    }
    
    public var errorRecoveryInfoUser: String {
        "msn_recovery_info_user_error".localized().capitalizingFirstLetter()
    }
    
    public var errorFetchMembers: String {
        "msn_fetch_members_error".localized().capitalizingFirstLetter()
    }
    
    public var stateItemMemberComponent: ComponentState = .skeleton
    
    public enum State: Equatable {
        case loaded
    }
    
    public var homeState: State = .loaded

    init() {
        options = [
            .init(image: .init(systemName: "person.crop.circle.badge.plus"), color: FHKColor.ultraPurple),
            .init(image: .init(systemName: "note.text.badge.plus"), color: FHKColor.fuchsiaPink),
            .init(image: .init(systemName: "star.fill"), color: FHKColor.yellow)
        ]
    }
    
    public func getStateItemMemberComponent(memberName: String, avatarName: String) -> ComponentState {
        let isInfoComplete = !memberName.isEmpty && !avatarName.isEmpty
        return isInfoComplete ? .loaded : .error
    }
}
