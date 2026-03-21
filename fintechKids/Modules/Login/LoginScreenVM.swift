//
//  LoginScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class LoginScreenVM: FHKCore.ViewModel {
    var viewState: LoginViewState = .init()
    
    // Properties injected
    private var fhkLoginRepository: any FHKLoginRepositoryProtocol {
        inject.fhkLoginRepository
    }
    
    private var fhkFirebaseAnalitycs: any FHKAnalyticsProtocol {
        inject.fhkFirebaseAnalitycs
    }
    
    private var fhkSecurity: any FHKSecurityProtocol {
        inject.fhkSecurity
    }
    
    public var fhkToast: any FHKToastProtocol {
        inject.fhkToast
    }
    
    public var fhkModal: any FHKModalProtocol {
        inject.fhkModal
    }
    
    // Other properties
    var hasSavedAuthToken: Bool {
        fhkLoginRepository.hasSavedToken
    }
    
    // Others Properties
    var isBiometryAvailable: Bool {
        fhkSecurity.getBiometryType() != .none
    }
    
    var biometryIconName: String {
        fhkSecurity.biometryIcon
    }
    
    enum Action: Equatable {
        case doLogin
        case doLoginWithBiometrics
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
            
        case .doLogin:
            await login()
            await saveUserIntoKeychain()
            
        case .doLoginWithBiometrics:
            await loginWithBiometrics()
        }
    }
    
    @MainActor
    private func login() async {
        viewState.loginState = .loading
        
        do {
            let loginEntity = LoginEntity(email: viewState.email, password: viewState.password)
            let userSession = try await fhkLoginRepository.login(loginEntity: loginEntity)
            
            viewState.loginState = .finish(result: .success)
            guard let tokenAccess = userSession else {
                return
            }
            
            // We saved the Session Token PROTECTED by Face ID for the future
            saveSessionToken(tokenAccess: tokenAccess, isHasBiometry: isBiometryAvailable)
        } catch let error as FHKSupabaseError {
            viewState.loginState = .finish(result: .error)
            informateError(error)
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKLoginError.loginUserFailed)
        }
    }
    
    @MainActor
    private func loginWithBiometrics() async {
        let prompt = getBiometryPrompt(biometryType: fhkSecurity.getBiometryType())
        
        do {
            try await fhkLoginRepository.loginWithBiometrics(prompt: prompt)
            viewState.loginState = .finish(result: .success)
        } catch let error as FHKSupabaseError {
            viewState.loginState = .finish(result: .error)
            informateError(error)
        } catch {
            let fhkError = error as? any FHKError ?? FHKAppError.biometryCancelAuthentication
            viewState.loginState = .finish(result: .error)
            informateError(fhkError)
        }
    }
    
    private func getBiometryPrompt(biometryType: BiometryType) -> String {
        switch biometryType {
        case .faceID:
            return viewState.msnFaceId
           
        case .touchID:
            return viewState.msnTouchId
   
        default:
            return viewState.msnGenericId
        }
    }

    private func saveSessionToken(tokenAccess: String, isHasBiometry: Bool) {
        do {
            try fhkLoginRepository.saveAuthToken(tokenAccess, requiresBiometry: isHasBiometry)
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKAppError.saveTokenAccessKeychainFailed)
        }
    }
    
    func saveUserIntoKeychain() async {
        do {
            try await fhkLoginRepository.saveUserIntoKeychain(email: viewState.email)
            Logger.info("USER SAVED INTO KEYCHAIN SUCCESS")
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKAppError.saveUserMailKeychainFailed)
        }
    }

    private func informateError(_ error: any FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkFirebaseAnalitycs.track(.error(.init(from: error)))
        }
        
        // We show the user the localized message (UX)
        viewState.msnLoginFail = error.messageLocalized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
}
