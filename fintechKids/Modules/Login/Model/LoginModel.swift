//
//  LoginModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 7/1/26.
//

import SwiftUI
import Combine
import FHKAuth
import FHKUtils
import FHKCore
import Observation

@Observable
public class LoginModel {
    public var email = ""
    public var password = ""
    
    // form view
    public var emailPlaceholder = ""
    public var passwordPlaceholder = ""
    public var wellcome = ""
    public var startSesionYourAccount = ""
    public var youForgotYourPassword = ""
    public var startSesion = ""
    public var youNotHaveAccount = ""
    public var register = ""
    
    // errors screen
    public var msnLoading = ""
    public var titleError = ""
    public var msnError = ""
    public var titleBtnError = ""
    
    public var isLogginSuccess: Bool = false
    
    private var _loginState: FHKCore.State<SupabaseAuthResponse> = .loaded(nil)
    var loginState: FHKCore.State<SupabaseAuthResponse> {
        get { _loginState }
        set {
            _loginState = newValue
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
        emailPlaceholder = "email".localized()
        passwordPlaceholder = "password".localized()
        msnLoading = "loading".localized().capitalizingFirstLetter()
        
        wellcome = "wellcome".localized().capitalizingFirstLetter()
        startSesionYourAccount = "start_sesion_your_account".localized().capitalizingFirstLetter()
        youForgotYourPassword = "you_forgot_your_password".localized().capitalizingFirstLetter()
        startSesion = "start_sesion".localized().capitalizingFirstLetter()
        youNotHaveAccount = "you_not_have_an_account".localized().capitalizingFirstLetter()
        register = "register".localized().capitalizingFirstLetter()
        
        titleError = "title_error".localized().capitalizingFirstLetter()
        msnError = "msn_error".localized().capitalizingFirstLetter()
        titleBtnError = "title_btn_error".localized().capitalizingFirstLetter()
    }
    
    private func updateLoadingView() {
        // update label string from here
    }
    
    private func updateLoadedView() {
        // update label string from here
    }
    
    private func updateErrorView() {
        // update label string from here
    }
    
    public func setMessageLoginError(error: AuthDomainError) {
        
        switch error {
        case .invalidCredentials:
            msnError = "invalid_credentials_error".localized().capitalizingFirstLetter()
            
        case .userNotFound:
            msnError = "user_not_found_error".localized().capitalizingFirstLetter()
            
        case .emailNotConfirmed:
            msnError = "email_not_confirmed_error".localized().capitalizingFirstLetter()
            
        case .otpExpired:
            msnError = "otp_expired_error".localized().capitalizingFirstLetter()
            
        case .tooManyRequests:
            msnError = "too_many_requests_error".localized().capitalizingFirstLetter()
            
        case .authenticationNotImplemented:
            msnError = "authentication_not_Implemented_error".localized().capitalizingFirstLetter()
            
        case .refreshSession:
            msnError = "refresh_session_error".localized().capitalizingFirstLetter()
            
        case .unknown(let code):
            msnError = "unknown_error".localized() + " (\(code))."
            
        default:
            msnError = "unknown_error".localized()
        }
    }
}
