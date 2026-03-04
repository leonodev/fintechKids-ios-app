//
//  RegisterModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI
import Observation
import FHKUtils
import FHKCore
import FHKDesignSystem

@Observable
public class RegisterViewState {
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
    public var registerEmailInstruction = "register_email_instruction".localized().capitalizingFirstLetter()
    
    public var stateRegisterOperation: FHKInformationView.ResultType {
        registerState.isError ? .error : .success
    }

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
                
            case .error:
                informateError()
                
            case .finish:
                informateFinishState()
            }
        }
    }
    
    var isBtnContinueEnable: FHKButtonComponent.State {
        !emailFamily.isEmpty && !password.isEmpty && emailFamily.isValidEmail
        ? .enabled
        : .disabled
    }
}

extension RegisterViewState {
    private func updateLoadingView() {
        msnLoading = "title_loading_registering_user".localized().capitalizingFirstLetter()
    }

    private func informateError() {
        msnRegisterConfirmation = "msn_register_user_error".localized().capitalizingFirstLetter()
    }
    
    private func informateFinishState() {
        msnRegisterConfirmation = "msn_register_user_success".localized().capitalizingFirstLetter()
        Logger.info("REGISTER USER SUCCESS")
    }
}
