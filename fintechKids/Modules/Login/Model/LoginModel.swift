//
//  LoginModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/1/26.
//

import SwiftUI
import FHKAuth
import FHKUtils
import FHKCore
import FHKDesignSystem
import FHKInjections
import FHKObservability

public struct LoginModel {
    // Properties Observable
    public var email = ""
    public var password = ""
    
    // Injections Dependency
    private let analitycsManager = inject.analitycsManager
    
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
    
    public var startSesionYourAccount: String { "start_sesion_your_account".localized().capitalizingFirstLetter()
    }
    
    public var youForgotYourPassword: String { "you_forgot_your_password".localized().capitalizingFirstLetter()
    }
    
    public var startSesion: String {
        "start_sesion".localized().capitalizingFirstLetter()
    }
    
    public var youNotHaveAccount: String { "you_not_have_an_account".localized().capitalizingFirstLetter()
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
    
    func getBiometryPrompt(biometryType: BiometryType) -> String {
        switch biometryType {
        case .faceID:
            "prompt_face_id".localized().capitalizingFirstLetter()
            
        case .touchID:
            "prompt_touch_id".localized().capitalizingFirstLetter()
   
        default:
            "prompt_generic_id".localized().capitalizingFirstLetter()
        }
    }
    
    var isBtnContinueEnable: FHKButtonComponent.State {
        !email.isEmpty && !password.isEmpty && email.isValidEmail ? .enabled : .disabled
    }
    
    // Properties Logs Error
    public let attributesLoginError = ["platform": "supabase"]
    
    private var _loginState: FHKCore.State<Never> = .loaded
    var loginState: FHKCore.State<Never> {
        get { _loginState }
        set {
            _loginState = newValue
            switch newValue {
            case .loading:
                updateLoadingView()
                
            case .loaded:
                informateLoadedState()
                
            case .error(let error):
                informateError(error)
                
            case .finish:
                informateFinishState()
            }
        }
    }
    
    private func updateLoadingView() {
        // update label string from here
    }
    
    private func informateLoadedState() {
        Logger.info("LoginScreen loaded correctly")
    }
    
    private func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            analitycsManager.track(.error(.init(from: error)))
        }
        
        Logger.error(error.logMessage)
    }
    
    private func informateFinishState() {
        Logger.info("Login Success")
    }
}
