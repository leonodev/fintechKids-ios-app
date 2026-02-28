//
//  AddMemberModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import Observation
import FHKUtils
import FHKCore
import FHKDesignSystem
import FHKInjections
import FHKDomain
import FHKFirebase

@Observable
public class AddMemberModel {
    
    // Properties Observable
    public var memberNewName = ""
    public var familyName = ""
    
    // Injections Dependency
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    private var analitycsManager: any FHKAnalyticsProtocol {
        inject.firebaseAnalitycsManager
    }
    
    // Properties View
    public var familyNamePlaceholder = "family_name".localized().capitalizingFirstLetter()
    public var titleBtnAddMember = "title_add_member".localized().capitalizingFirstLetter()
    public var titleAddNewMember = "title_add_member".localized().capitalizingFirstLetter()
    public var memberNewNamePlaceholder = "title_name_new_member".localized().capitalizingFirstLetter()
    public var selectedAvatarName: String = AvatarType.boy_9.name
    public var titleSelectAvatar = "title_select_your_avatar".localized().capitalizingFirstLetter()
    public let avatarIList = AvatarType.allCases
    public var familyMembers: [FamilyMember] = []
    
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
  
    public var stateBtnAddMember: FHKButtonComponent.State {
        !memberNewName.isEmpty ? .enabled : .disabled
    }
    
    public var stateBtnRegisterMember: FHKButtonComponent.State {
        !familyName.isEmpty && !familyMembers.isEmpty
        ? .enabled
        : .disabled
    }
    
    public func getParentMail() async -> String? {
        try? storageManager.readKeychain(String.self, for: KeychainKeys.userKey, prompt: nil)
    }

    private var _addMemberState: FHKCore.State<Never> = .loaded
    var addMemberState: FHKCore.State<Never> {
        get { _addMemberState }
        set { _addMemberState = newValue
            switch newValue {
            case .error(let error):
                informateError(error)
                
            default:
                break
            }
        }
    }
    
    private func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            analitycsManager.track(.error(.init(from: error)))
        }
        
        titleUserError = error.titleUI
        msnUserError = error.messageUI
        Logger.error(error.logMessage)
    }
    
    public func msnRemoveMember(name: String) -> String {
        "msn_want_remove_member".localized(name).capitalizingFirstLetter()
    }
    
    public func clearInfoNewmember() {
        selectedAvatarName = AvatarType.boy_9.name
        memberNewName = ""
    }
}
