//
//  AddMemberModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import SwiftUI
import Combine
import Observation
import Supabase
import FHKAuth
import FHKUtils
import FHKCore
import FHKDesignSystem

@Observable
public class AddMemberModel {
    
    public enum FinishStep: Equatable {
        case information
    }
    
    // Properties Observable
    public var memberNewName = ""
    public var familyName = ""
    public var emailFamily = ""
    
    // Properties View
    public var familyNamePlaceholder = "family_name".localized().capitalizingFirstLetter()
    public var titleBtnAddMember = "title_add_member".localized().capitalizingFirstLetter()
    public var titleAddNewMember = "title_add_member".localized().capitalizingFirstLetter()
    public var memberNewNamePlaceholder = "title_name_new_member".localized().capitalizingFirstLetter()
    public var selectedAvatarName: String?
    public var titleSelectAvatar = "title_select_your_avatar".localized().capitalizingFirstLetter()
    public let avatarIList = AvatarType.allCases
    public var familyMembers: [FamilyMember] = []
    
    public var titleRemoveMember = "title_remove_member".localized().capitalizingFirstLetter()
    public var titleBtnConfirm = "confirm".localized().capitalizingFirstLetter()
    public var titleBtnCancel = "cancel".localized().capitalizingFirstLetter()
  
    public var stateButtonCreateMember: FHKButtonComponent.State {
        (selectedAvatarName != nil && !memberNewName.isEmpty)
        ? .enabled
        : .disabled
    }
    
    private var _addMemberState: FHKCore.State<FinishStep> = .loaded
    var addMemberState: FHKCore.State<FinishStep> {
        get { _addMemberState }
        set { _addMemberState = newValue }
    }
    
    
    public func msnRemoveMember(name: String) -> String {
        "msn_want_remove_member".localized(name).capitalizingFirstLetter()
    }
    
    public func clearInfoNewmember() {
        selectedAvatarName = nil
        memberNewName = ""
    }
}
