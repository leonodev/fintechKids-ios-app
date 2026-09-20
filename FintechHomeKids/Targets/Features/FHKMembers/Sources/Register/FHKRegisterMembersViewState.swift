//
//  FHKRegisterMembersViewState.swift
//  FHKMembers
//
//  Created by Fredy Leon on 16/9/26.
//

import Observation
import FLibUtils
import FHKDesignSystem
import FHKCore

@MainActor
public struct FHKRegisterMembersViewState {
    
    // Properties Observable
    public var memberNewName = ""
    public var msnUserError: String = ""
    
    // Properties View
    public var membersTitle: String {
        "add_new_member".localized.uppercased()
    }
    
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnAddMember: String {
        "title_add_member".localized.capitalizingFirstLetter()
    }
    
    public var titleAddNewMember: String {
        "title_add_member".localized.capitalizingFirstLetter()
    }
    
    public var memberNewNamePlaceholder: String {
        "title_name_new_member".localized.capitalizingFirstLetter()
    }
    
    public var titleSelectAvatar: String {
        "title_select_your_avatar".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnConfirm: String {
        "confirm".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnCancel: String {
        "cancel".localized.capitalizingFirstLetter()
    }
    
    public var familyMemberDescription: String {
        "add_family_member_description".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnRegisterMember: String {
        "title_register_members".localized.capitalizingFirstLetter()
    }
    
    public var btnUserError: String {
        "title_btn_operation_error".localized.capitalizingFirstLetter()
    }
    
    public var msnMembersAddedSuccess: String {
        "msn_members_added_success".localized.capitalizingFirstLetter()
    }
    
    public var titleModalMembersAddedSuccess: String {
        "continue".localized.capitalizingFirstLetter()
    }
  
    public var msnRegisteringMembersFail: String {
        "msn_add_new_member_error".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnOperationError: String {
        "title_btn_operation_error".localized.capitalizingFirstLetter()
    }
    
    public func msnRemoveMember(name: String) -> String {
        let msnInfo = "msn_want_remove_member".localized
        let msnComplete = "\(msnInfo)\(name)"
        return msnComplete.capitalizingFirstLetter()
    }
 
    public var selectedAvatarName: String = AvatarType.boy_9.name
    public let avatarIList = AvatarType.allCases
    public var stateBtnAddMember: FHKButtonComponent.State {
        !memberNewName.isEmpty ? .enabled : .disabled
    }
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
    }
    
    public var registerMembersState: State = .loaded
    
    public func stateBtnRegisterMember(isEnable: Bool) -> FHKButtonComponent.State {
        isEnable ? .enabled : .disabled
    }
}
