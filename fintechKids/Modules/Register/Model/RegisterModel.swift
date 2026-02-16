//
//  RegisterModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI
import Combine
import Observation
import Supabase
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
    // Properties Observable
    public var emailFamily = ""
    public var password = ""
    
    // Properties View
    public var emailFamilyPlaceholder = "email".localized().capitalizingFirstLetter()
    public var passwordPlaceholder = "password".localized().capitalizingFirstLetter()
    public var titleRegisterBtn = "register".localized().uppercased()
    public var msnLoading = ""
    public var titleRegisterConfirmation = "title_register_user".localized().uppercased()
    public var msnRegisterConfirmation = "msn_register_user_success".localized().capitalizingFirstLetter()
    public var titleButtonContinue = "continue".localized().uppercased()
    
    private var _registerState: FHKCore.State<Never> = .loaded
    var registerState: FHKCore.State<Never> {
        get { _registerState }
        set {
            _registerState = newValue
            switch newValue {
            case .loading:
                updateLoadingView()
                
            case .loaded:
                break
                
            case .error(let error):
                sendCrashlyticsError(error)
                
            case .finish:
                informateFinishState()
            }
        }
    }
    
    var isBtnContinueEnable: FHKButtonComponent.State {
        return !emailFamily.isEmpty && !password.isEmpty ? .enabled : .disabled
    }
}

extension RegisterModel {
    private func updateLoadingView() {
        msnLoading = "title_loading_registering_user".localized().capitalizingFirstLetter()
    }

    private func sendCrashlyticsError(_ error: Log) {
        msnRegisterConfirmation = "msn_register_user_error".localized().capitalizingFirstLetter()
        CrashlyticsError.send(log: error)
    }
    
    private func informateFinishState() {
        msnRegisterConfirmation = "msn_register_user_success".localized().capitalizingFirstLetter()
        Logger.info("User Registered Success")
    }
}
