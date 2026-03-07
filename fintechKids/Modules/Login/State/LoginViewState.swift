//
//  LoginViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/1/26.
//

import FHKUtils
import FHKDesignSystem

public struct LoginViewState {
    // Properties Observable
    public var email = ""
    public var password = ""
    
    // Properties Screen View
    public var emailPlaceholder: String {
        "email".localized()
    }
    
    public var passwordPlaceholder: String {
        "password".localized()
    }
    
    public var wellcome: String {
        "wellcome".localized().capitalizingFirstLetter()
    }
    
    public var startSesionYourAccount: String {
        "start_sesion_your_account".localized().capitalizingFirstLetter()
    }
    
    public var youForgotYourPassword: String {
        "you_forgot_your_password".localized().capitalizingFirstLetter()
    }
    
    public var startSesion: String {
        "start_sesion".localized().capitalizingFirstLetter()
    }
    
    public var youNotHaveAccount: String {
        "you_not_have_an_account".localized().capitalizingFirstLetter()
    }
    
    public var register: String {
        "register".localized().capitalizingFirstLetter()
    }
    
    // msn loading
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    // errors screen
    public var titleError: String {
        "start_sesion".localized().capitalizingFirstLetter()
    }
    
    public var msnError: String {
        "msn_operation_error".localized().capitalizingFirstLetter()
    }

    public var titleBtnError: String {
        "title_btn_error".localized().capitalizingFirstLetter()
    }
    
    public var msnFaceId: String {
        "prompt_face_id".localized().capitalizingFirstLetter()
    }
    
    public var msnTouchId: String {
        "prompt_touch_id".localized().capitalizingFirstLetter()
    }
    
    public var msnGenericId: String {
        "prompt_generic_id".localized().capitalizingFirstLetter()
    }
 
    // States screen
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
        case error
    }
    
    public var loginState: State = .loaded
    
    // Other properties
    var isBtnContinueEnable: FHKButtonComponent.State {
        !email.isEmpty && !password.isEmpty && email.isValidEmail ? .enabled : .disabled
    }
}
