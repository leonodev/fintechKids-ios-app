//
//  RegisterMembersViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import Observation
import FHKUtils
import FHKDesignSystem

@Observable
public class RegisterMembersViewState {
    
    // Properties Observable
    public var memberNewName = ""
    public var familyName = ""
    
    // Properties View
    public var msnLoading = "loading".localized().capitalizingFirstLetter()
    public var familyNamePlaceholder = "family_name".localized().capitalizingFirstLetter()
    public var titleBtnAddMember = "title_add_member".localized().capitalizingFirstLetter()
    public var titleAddNewMember = "title_add_member".localized().capitalizingFirstLetter()
    public var memberNewNamePlaceholder = "title_name_new_member".localized().capitalizingFirstLetter()
    public var selectedAvatarName: String = AvatarType.boy_9.name
    public var titleSelectAvatar = "title_select_your_avatar".localized().capitalizingFirstLetter()
    public let avatarIList = AvatarType.allCases
    public var titleRemoveMember = "title_remove_member".localized().capitalizingFirstLetter()
    public var titleBtnConfirm = "confirm".localized().capitalizingFirstLetter()
    public var titleBtnCancel = "cancel".localized().capitalizingFirstLetter()
    
    public var familyMemberDescription = "add_family_member_description".localized().capitalizingFirstLetter()
    public var titleBtnRegisterMember = "title_register_members".localized().capitalizingFirstLetter()
    
    public var titleUserError: String = ""
    public var msnUserError: String = ""
    public var btnUserError: String = "title_btn_operation_error".localized().capitalizingFirstLetter()
    
    public var titleMembersAddedSuccess: String = ""
    public var msnMembersAddedSuccess: String = "msn_members_added_success".localized().capitalizingFirstLetter()
    public var titleModalMembersAddedSuccess: String = "continue".localized().capitalizingFirstLetter()
  
    public var msnRegisteringMembersFail: String = "msn_add_new_member_error".localized().capitalizingFirstLetter()
    public var titleBtnOperationError: String = "title_btn_operation_error".localized().capitalizingFirstLetter()
 
    public var stateBtnAddMember: FHKButtonComponent.State {
        !memberNewName.isEmpty ? .enabled : .disabled
    }
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var registerMembersState: State = .loaded
    
    public func msnRemoveMember(name: String) -> String {
        "msn_want_remove_member".localized(name).capitalizingFirstLetter()
    }
    
    public func stateBtnRegisterMember(isEnable: Bool) -> FHKButtonComponent.State {
        isEnable ? .enabled : .disabled
    }
}
