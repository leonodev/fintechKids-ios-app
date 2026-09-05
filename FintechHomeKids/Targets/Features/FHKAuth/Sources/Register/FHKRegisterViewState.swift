//
//  FHKRegisterViewState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 5/9/26.
//

import SwiftUI
import Observation
import FLibUtils
import FHKDesignSystem
import FHKCore

@MainActor
@Observable
public class FHKRegisterViewState {
    // Properties Observable
    public var familyName = ""
    public var emailFamily = ""
    public var password = ""
    public var confirmPassword = ""
    public var pinApproveTask = ""
    public var msnLoading = ""
    public var msnRegisterFail = ""
    
    // Properties View
    public var familyNamePlaceholder: String {
        "family_name".localized.capitalizingFirstLetter()
    }
    
    public var emailFamilyPlaceholder: String {
        "email".localized.capitalizingFirstLetter()
    }
    
    public var passwordPlaceholder: String {
        "password".localized.capitalizingFirstLetter()
    }
    
    public var confirmPasswordPlaceholder: String {
        "confirm_password".localized.capitalizingFirstLetter()
    }
    
    public var pinApproveTaskPlaceholder: String {
        "title_pin_approve_task_placeholder".localized.capitalizingFirstLetter()
    }
    
    public var titleRegisterBtn: String {
        "register".localized().uppercased()
    }
    
    public var msnRegisterSuccess: String {
        "msn_register_user_success".localized.capitalizingFirstLetter()
    }
    
    public var titleButtonContinue: String {
        "continue".localized().uppercased()
    }
    
    public var registerEmailInstruction: String {
        "register_email_instruction".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnOperationError: String {
        "title_btn_operation_error".localized.capitalizingFirstLetter()
    }

    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
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
        !pinApproveTask.isEmpty
        ? .enabled
        : .disabled
    }
}

extension FHKRegisterViewState {
    private func updateLoadingView() {
        msnLoading = "title_loading_registering_user".localized().capitalizingFirstLetter()
    }
    
    private func informateSuccess() {
        Logger.info("REGISTER USER SUCCESS")
    }
}
