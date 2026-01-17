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
    
    private var _loginState: FHKCore.State<SupabaseAuthResponse> = .none
    var loginState: FHKCore.State<SupabaseAuthResponse> {
        get { _loginState }
        set {
            _loginState = newValue
            switch newValue {
            case .loading:
                print("loading")
                
            case .none:
                print("none")
                
            case .loaded(let info):
                print("loaded")
                //updateBalanceCardView(with: info)
            case .error:
                print("error")
//                configureAlert(subtitle: "INVESTMENTS_GOALS_ERROR_BALANCE_ALERT_DESCRIPTION".translate, type: .error())
            }
        }
    }
    
    init() {
        emailPlaceholder = "email".localized()
        passwordPlaceholder = "password".localized()
        
        wellcome = "wellcome".localized().capitalizingFirstLetter()
        startSesionYourAccount = "start_sesion_your_account".localized().capitalizingFirstLetter()
        youForgotYourPassword = "you_forgot_your_password".localized().capitalizingFirstLetter()
        startSesion = "start_sesion".localized().capitalizingFirstLetter()
        youNotHaveAccount = "you_not_have_an_account".localized().capitalizingFirstLetter()
        register = "register".localized().capitalizingFirstLetter()
        msnLoading = "loading".localized().capitalizingFirstLetter()
        titleError = "title_error".localized().capitalizingFirstLetter()
        msnError = "msn_error".localized().capitalizingFirstLetter()
        titleBtnError = "title_btn_error".localized().capitalizingFirstLetter()
    }
}

extension AuthDomainError {
    
    public var userMessageError: String {
        switch self {
            
        case .invalidCredentials:
            return "invalid_credentials_error".localized().capitalizingFirstLetter()
            
        case .userNotFound:
            return "user_not_found_error".localized().capitalizingFirstLetter()
            
        case .emailNotConfirmed:
            return "email_not_confirmed_error".localized().capitalizingFirstLetter()
            
        case .otpExpired:
            return "otp_expired_error".localized().capitalizingFirstLetter()
            
        case .tooManyRequests:
            return "too_many_requests_error".localized().capitalizingFirstLetter()
          
        case .authenticationNotImplemented:
            return "authentication_not_Implemented_error".localized().capitalizingFirstLetter()
            
        case .refreshSession:
            return "refresh_session_error".localized().capitalizingFirstLetter()
            
        case .unknown(let code):
            return "unknown_error".localized() + " (\(code))."
        }
    }
}

