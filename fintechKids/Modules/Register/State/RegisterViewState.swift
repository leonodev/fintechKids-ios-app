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
    public var familyName = ""
    public var emailFamily = ""
    public var password = ""
    public var confirmPassword = ""
    public var pinApproveTask = ""
    
    // Properties View
    public var familyNamePlaceholder = "family_name".localized().capitalizingFirstLetter()
    public var emailFamilyPlaceholder = "email".localized().capitalizingFirstLetter()
    public var passwordPlaceholder = "password".localized().capitalizingFirstLetter()
    public var confirmPasswordPlaceholder = "confirm_password".localized().capitalizingFirstLetter()
    public var pinApproveTaskPlaceholder = "title_pin_approve_task_placeholder".localized().capitalizingFirstLetter()
    public var titleRegisterBtn = "register".localized().uppercased()
    public var msnLoading = ""
    public var msnRegisterSuccess = "msn_register_user_success".localized().capitalizingFirstLetter()
    public var titleButtonContinue = "continue".localized().uppercased()
    public var registerEmailInstruction = "register_email_instruction".localized().capitalizingFirstLetter()
    public var msnRegisterFail = ""
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
    
    var isPasswordValid: Bool {
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password.count > 6 &&
        password == confirmPassword
    }
    
    var isEmailValid: Bool {
        !emailFamily.isEmpty &&
        emailFamily.isValidEmail
    }
    
    var isBtnContinueEnable: FHKButtonComponent.State {
        !familyName.isEmpty &&
        isEmailValid &&
        isPasswordValid &&
        pinApproveTask.isEmpty
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
