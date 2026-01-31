//
//  RegisterModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI
import Combine
import Observation
import FHKAuth
import FHKUtils
import FHKCore
import FHKDesignSystem

public struct FamilyMember: Identifiable, Hashable {
    public let id = UUID()
    public let name: String
    public let avatarImage: String
    public let iconName: String = "trash"
}

@Observable
public class RegisterModel {
    public var familyName = ""
    public var titleFamilyName = ""
    public var familyNamePlaceholder = ""
    
    public var emailFamily = ""
    public var titleEmailFamily = ""
    public var emailFamilyPlaceholder = ""
    
    public var titlePassword = ""
    public var passwordPlaceholder = ""
    public var password = ""
    
    public var titleSelectAvatar = ""
    public var titleBtnAddMember = ""
    
    public var titleMemberNewName = ""
    public var memberNewName = ""
    public var memberNewNamePlaceholder = ""
    public var titleRegisterBtn = ""
    
    public var titleRemoveMember = ""
    public var titleBtnCancel = ""
    public var titleBtnConfirm = ""
    
    public var selectedAvatarName: String?
    public var familyMembers: [FamilyMember] = []
    public let avatarIList = AvatarType.allCases
    
    public var msnError = ""
    
    public var stateButtonCreateMember: FHKButtonComponent.State {
        (selectedAvatarName != nil && !memberNewName.isEmpty)
        ? .enabled
        : .disabled
    }
    
    public var isRegisterSuccess: Bool = false
    
    private var _registerState: FHKCore.State<SupabaseAuthResponse> = .loaded(nil)
    var registerState: FHKCore.State<SupabaseAuthResponse> {
        get { _registerState }
        set {
            _registerState = newValue
            switch newValue {
            case .loading:
                updateLoadingView()
                
            case .loaded(let info):
                updateLoadedView()
                
            case .error:
                updateErrorView()
            }
        }
    }
    
    init() {
        titleFamilyName = "family_name".localized().capitalizingFirstLetter()
        familyNamePlaceholder = "family_name".localized().capitalizingFirstLetter()
        
        titleEmailFamily = "email".localized().capitalizingFirstLetter()
        emailFamilyPlaceholder = "email".localized().capitalizingFirstLetter()
        
        titlePassword = "password".localized().capitalizingFirstLetter()
        passwordPlaceholder = "password".localized().capitalizingFirstLetter()
        
        titleSelectAvatar = "title_select_your_avatar".localized().capitalizingFirstLetter()
        titleBtnAddMember = "title_add_member".localized().capitalizingFirstLetter()
        
        titleRemoveMember = "title_remove_member".localized().capitalizingFirstLetter()
        
        titleBtnCancel = "cancel".localized().capitalizingFirstLetter()
        titleBtnConfirm = "confirm".localized().capitalizingFirstLetter()
        titleRegisterBtn = "register".localized().uppercased()
        titleMemberNewName = "title_name_new_member".localized().capitalizingFirstLetter()
    }
    
    public func msnRemoveMember(name: String) -> String {
        "msn_want_remove_member".localized(name).capitalizingFirstLetter()
    }
    
    public func clearInfoNewmember() {
        selectedAvatarName = nil
        memberNewName = ""
    }
    
    public func setMessageRegisterError(error: AuthDomainError) {
        switch error {
        case .userAlreadyExist:
            msnError = "user_already_exist_error".localized().capitalizingFirstLetter()
            
        default:
            msnError = "unknown_error".localized()
        }
    }
}

extension RegisterModel {
    private func updateLoadingView() {
        // update label string from here
    }
    
    private func updateLoadedView() {
        // update label string from here
    }
    
    private func updateErrorView() {
        // update label string from here
    }
}
