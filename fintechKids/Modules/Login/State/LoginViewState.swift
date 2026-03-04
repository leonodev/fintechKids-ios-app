//
//  LoginViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/1/26.
//

import FHKUtils
import FHKCore
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
        "title_error".localized().capitalizingFirstLetter()
    }
    
    public var msnError: String {
        "invalid_credentials_error".localized().capitalizingFirstLetter()
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
    private var _loginState: FHKCore.State<Never> = .loaded
    var loginState: FHKCore.State<Never> {
        get { _loginState }
        set {_loginState = newValue }
    }
    
    // Other properties
    var isBtnContinueEnable: FHKButtonComponent.State {
        !email.isEmpty && !password.isEmpty && email.isValidEmail ? .enabled : .disabled
    }
}
