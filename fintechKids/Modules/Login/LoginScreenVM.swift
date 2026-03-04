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
    private var repository: any FHKLoginRepositoryProtocol {
        inject.loginRepository
    }
    
    private var analitycsManager: any FHKAnalyticsProtocol {
        inject.firebaseAnalitycsManager
    }
    
    private var securityManager: any FHKSecurityProtocol {
        inject.securityManager
    }
    
    public var toastService: any FHKToastProtocol {
        inject.toastManager
    }
    
    public var modalManager: any FHKModalProtocol {
        inject.modalManager
    }
    
    // Other properties
    var hasSavedAuthToken: Bool {
        repository.hasSavedToken
    }
    
    // Others Properties
    var isBiometryAvailable: Bool {
        securityManager.getBiometryType() != .none
    }
    
    var biometryIconName: String {
        securityManager.biometryIcon
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
            
        case .doLoginWithBiometrics:
            await loginWithBiometrics()
        }
    }
    
    @MainActor
    private func login() async {
        viewState.loginState = .loading
        
        do {
            let userSession = try await repository.login(email: viewState.email,
                                                         pwd: viewState.password)
            
            viewState.loginState = .finish(nil)
            guard let tokenAccess = userSession else {
                return
            }
            
            // We saved the Session Token PROTECTED by Face ID for the future
            saveSessionToken(tokenAccess: tokenAccess, isHasBiometry: isBiometryAvailable)
        } catch let error as FHKDomainError {
            viewState.loginState = .error(error)
            informateError(error)
        } catch {
            viewState.loginState = .error(FHKAppError.loginUserFailed)
            informateError(FHKAppError.loginUserFailed)
        }
    }
    
    @MainActor
    private func loginWithBiometrics() async {
        let prompt = getBiometryPrompt(biometryType: securityManager.getBiometryType())
        
        do {
            try await repository.loginWithBiometrics(prompt: prompt)
            viewState.loginState = .finish(nil)
        } catch {
            let fhkError = error as? any FHKError ?? FHKBiometryError.userCancelAuthentication
            viewState.loginState = .error(fhkError)
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
            try repository.saveAuthToken(tokenAccess, requiresBiometry: isHasBiometry)
        } catch {
            viewState.loginState = .error(FHKSecurityError.saveTokenAccessKeychainFailed)
            informateError(FHKSecurityError.saveTokenAccessKeychainFailed)
        }
    }

    private func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            analitycsManager.track(.error(.init(from: error)))
        }
        Logger.error(error.logMessage)
    }
}
