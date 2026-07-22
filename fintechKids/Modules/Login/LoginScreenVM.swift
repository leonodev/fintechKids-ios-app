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
    private var fhkLoginRepository: FHKLoginRepository {
        inject.fhkLoginRepository
    }
    
    private var fhkRegisterRepository: FHKRegisterRepository {
        inject.fhkRegisterRepository
    }
    
    private var fhkFirebaseAnalitycs: FHKAnalytics {
        inject.fhkFirebaseAnalitycs
    }
    
    private var fhkSecurity: FHKSecurity {
        inject.fhkSecurity
    }
    
    public var fhkToast: FHKToast {
        inject.fhkToast
    }
    
    public var fhkModal: FHKModal {
        inject.fhkModal
    }
    
    public var fhkSession: FHKSession {
        inject.fhkSession
    }
    
    // Other properties
    var hasSavedAuthToken: Bool {
        fhkLoginRepository.hasSavedToken()
    }
    
    // Others Properties
    var isBiometryAvailable: Bool {
        fhkSecurity.getBiometryType() != .none
    }
    
    var biometryIconName: String {
        fhkSecurity.biometryIcon()
    }
    
    enum Action: Equatable {
        case doLogin
        case doLoginWithBiometrics
        case showInfo(info: FHKToastInfo)
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
            
        case .doLogin:
            await login()
            
        case .doLoginWithBiometrics:
            await loginWithBiometrics()
            
        case .showInfo(let info):
            await showToast(info: info)
        }
    }
    
    @MainActor
    private func login() async {
        viewState.loginState = .loading
        
        do {
            let loginEntity = LoginEntity(email: viewState.email, password: viewState.password)
            let userSession = try await fhkLoginRepository.login(loginEntity)

            guard let tokenAccess = userSession?.accessToken, !tokenAccess.isEmpty else {
                informateError(FHKLoginError.accessTokenInvalid)
                return
            }
            
            // We saved the Session Token PROTECTED by Face ID for the future
            guard saveSessionToken(tokenAccess: tokenAccess,
                                   isHasBiometry: isBiometryAvailable) else {
                return
            }
            
            guard let pinToApprovedTask = userSession?.infoAditional?.pinApproved, !pinToApprovedTask.isEmpty else {
                informateError(FHKLoginError.pinApproveInvalid)
                return
            }
            
            guard let familyName = userSession?.infoAditional?.familyName, !familyName.isEmpty else {
                informateError(FHKLoginError.familyNameInvalid)
                return
            }

            do {
                try fhkRegisterRepository.saveFamilyInfoKeychain(familyName)
            } catch {
                informateError(FHKLoginError.familyNameInvalid)
                return
            }
            
            do {
                try await fhkLoginRepository.savePinApproveTask(pinToApprovedTask)
            } catch {
                informateError(FHKLoginError.pinApproveInvalid)
                return
            }
            
            guard await saveUserIntoKeychain() else {
                return
            }
            
            try await fhkSession.login()
            viewState.loginState = .finish(result: .success)
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
            try await fhkLoginRepository.loginWithBiometrics(prompt)
            viewState.loginState = .finish(result: .success)
        } catch let error as FHKSupabaseError {
            viewState.loginState = .finish(result: .error)
            informateError(error)
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKAppError.biometryAuthenticationFailed)
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

    private func saveSessionToken(tokenAccess: String, isHasBiometry: Bool) -> Bool {
        do {
            try fhkLoginRepository.saveAuthToken(tokenAccess, isHasBiometry)
            return true
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKAppError.saveTokenAccessKeychainFailed)
            return false
        }
    }
    
    func saveUserIntoKeychain() async -> Bool {
        do {
            try await fhkLoginRepository.saveUserIntoKeychain(viewState.email)
            Logger.info("USER SAVED INTO KEYCHAIN SUCCESS")
            return true
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKAppError.saveUserMailKeychainFailed)
            return false
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
    
    private func showToast(info: FHKToastInfo) async {
        fhkToast.show(info, duration: 5.0)
    }
}
