//
//  FHKForgotViewState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import SwiftUI
import Observation
import FLibUtils
import FHKDesignSystem
import FHKCore

@MainActor
public struct FHKForgotViewState {
    
    public var titleRecoveryPassword: String {
        "title_recovery_password".localized.capitalizingFirstLetter()
    }
    
    public var msnRecoveryPassword: String {
        "msn_recovery_password".localized.capitalizingFirstLetter()
    }
    
    public var emailPlaceholder: String {
        "email".localized
    }
    
    public var email = ""
    public var msnForgotPasswordFail: String = ""
    
    // msn loading
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
    
    public var titleRequestCode: String {
        "title_request_code".localized.uppercased()
    }
    
    public var msnRequestCodeForgotSuccess: String {
        "msn_request_code_forgot_success".localized.capitalizingFirstLetter()
    }
    
    public var titleResetCode: String {
        "title_reset_code".localized.capitalizingFirstLetter()
    }
    
    public var passwordPlaceholder: String {
        "password".localized.capitalizingFirstLetter()
    }
    
    public var confirmPasswordPlaceholder: String {
        "confirm_password".localized.capitalizingFirstLetter()
    }
    
    public var titleBtnErrorSomething: String {
        "error_something_went_wrong".localized.capitalizingFirstLetter()
    }
    
    public var titleResetPassword: String {
        "title_reset_password".localized.uppercased()
    }
    
    public var titleContinue: String {
        "continue".localized.uppercased()
    }
    
    public var msnResetPasswordFinishSuccess: String {
        "msn_reset_password_finish_success".localized.capitalizingFirstLetter()
    }
    
    public var titleRetryButton: String {
        "retry_button".localized.uppercased()
    }
    
    public var debugRecoveryCode: String? = nil
    public var code = ""
    
    public var newPassword = ""
    public var confirmPassword = ""

    // States screen
    public enum ResultState: Equatable {
        case requestCode
        case resetPassword
    }
    
    public enum State: Equatable {
        case loading
        case loaded(ResultState)
        case error
        case finish
    }
    
    public var forgotState: State = .loaded(.requestCode)
    
    // Other properties
    var isBtnContinueEnable: FHKButtonComponent.State {
        !email.isEmpty && email.isValidEmail ? .enabled : .disabled
    }
    
    var isBtnResetContinueEnable: FHKButtonComponent.State {
        !code.isEmpty &&
        newPassword.count > UserDefaultValues.minCharactersPassword &&
        newPassword == confirmPassword ? .enabled : .disabled
    }
}
