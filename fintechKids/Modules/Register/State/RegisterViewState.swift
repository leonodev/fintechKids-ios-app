//
//  RegisterModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI
import Observation
import FHKUtils
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
    public var titleUserRegister = ""
    public var msnRegisterSuccess = "msn_register_user_success".localized().capitalizingFirstLetter()
    public var titleButtonContinue = "continue".localized().uppercased()
    public var registerEmailInstruction = "register_email_instruction".localized().capitalizingFirstLetter()
    public var msnRegisterFail = "msn_register_user_error".localized().capitalizingFirstLetter()
    public var titleBtnOperationError = "title_btn_operation_error".localized().capitalizingFirstLetter()

    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var _registerState: State = .loaded
    var registerState: State {
        get { _registerState }
        set {
            _registerState = newValue
            switch newValue {
            case .loading:
                updateLoadingView()
                
            case .loaded:
                informateSuccess()
                
            default:
                break
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
    
    private func informateSuccess() {
        Logger.info("REGISTER USER SUCCESS")
    }
}
