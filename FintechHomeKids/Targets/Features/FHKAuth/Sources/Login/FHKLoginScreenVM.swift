//
//  FHKLoginScreenVM.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import Observation
import FHKCore
import FHKDomain
import FLibUtils

@Observable
public final class FHKLoginScreenVM: FHKCore.ViewModel {
    var viewState: FHKLoginViewState = .init()
    
    // Properties injected
    private var fhkLoginRepository: FHKLoginRepository {
        inject.fhkLoginRepository
    }
    
    private var fhkRegisterRepository: FHKRegisterRepository {
        inject.fhkRegisterRepository
    }
    
    private var fhkAnalitycs: FHKAnalytics {
        inject.fhkAnalitycs
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
    
    public init() {}
    
    public enum Action: Equatable {
        case doLogin
        case doLoginWithBiometrics
        case showInfo(info: FHKToastInfo)
    }
    
    @MainActor
    public func action(_ action: Action) async {
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
            let loginEntity = FHKLoginParams(email: viewState.email, password: viewState.password)
            let login = try await fhkLoginRepository.login(loginEntity)
            
            guard isDataValid(loginInfo: login) else {
                return
            }
            
            async let tokenResult: () = proccessAccessToken(token: login.accessToken)
            async let pinResult: () = proccessValidationPIN(pin: login.approvePin)
            async let familyResult: () = proccessFamily(nameFamily: login.familyName)
            async let emailResult: () = proccessEmailParent(email: viewState.email)
            
            let _ = await (tokenResult, pinResult, familyResult, emailResult)
            viewState.loginState = .finish(result: .success)
        } catch let appError {
            // If the Task was cancelled when the view was closed, we exit silently.
            if appError == .cancelled { return }
            
            viewState.loginState = .finish(result: .error)
            informateError(appError)
            
            // If you want to react to a specific case from the backend:
            if case .backend(.recoveryCodeExpired, _) = appError {/* Here */}
        }
    }
    
    private func isDataValid(loginInfo: FHKLoginEntity) -> Bool {
        guard !loginInfo.accessToken.isEmpty,
              !loginInfo.approvePin.isEmpty,
              !loginInfo.familyName.isEmpty,
              !viewState.email.isEmpty else {
            Logger.error("Data Validation Login Failed")
            return false
        }
        
        return true
    }
    
    private func proccessAccessToken(token: String) async {
        guard !token.isEmpty else {
            informateError(FHKAppError.saveTokenAccessKeychainFailed)
            return
        }
        
        // We saved the Session Token PROTECTED by Face ID for the future
        guard saveSessionToken(tokenAccess: token,
                               isHasBiometry: isBiometryAvailable) else {
            informateError(FHKAppError.saveTokenAccessKeychainFailed)
            return
        }
        
        Logger.info("(1 of 4) Token session saved success")
    }
    
    private func proccessValidationPIN(pin: String) async {
        guard !pin.isEmpty else {
            informateError(FHKAppError.pinApproveFailed)
            return
        }
        
        do {
            try await fhkLoginRepository.savePinApproveTask(pin)
            Logger.info("(2 of 4) PIN saved success")
        } catch {
            informateError(FHKAppError.pinApproveFailed)
            return
        }
    }
    
    private func proccessFamily(nameFamily: String) async {
        guard !nameFamily.isEmpty else {
            informateError(FHKAppError.familyNameFailed)
            return
        }
        
        do {
            try fhkRegisterRepository.saveFamilyInfoKeychain(nameFamily)
            Logger.info("(3 of 4) Family Name saved success")
        } catch {
            informateError(FHKAppError.familyNameFailed)
            return
        }
    }
    
    private func proccessEmailParent(email: String) async  {
        do {
            try await fhkLoginRepository.saveUserIntoKeychain(email)
            Logger.info("(4 of 4) User saved success")
        } catch {
            viewState.loginState = .finish(result: .error)
            informateError(FHKAppError.saveUserMailKeychainFailed)
        }
    }
    
    @MainActor
    private func loginWithBiometrics() async {
        let prompt = getBiometryPrompt(biometryType: fhkSecurity.getBiometryType())
        
        do {
            try await fhkLoginRepository.loginWithBiometrics(prompt)
            viewState.loginState = .finish(result: .success)
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

    private func informateError(_ error: some FHKError) {
        // We only send to Firebase if the error is configured to be reported.
        if error.isShouldTrack {
            fhkAnalitycs.track(.error(.init(from: error)))
        }
        
        // We display the translated message (with a safe fallback in case the key is empty)
        let key = error.msnLocalizedKey.isEmpty ? "error_server_generic" : error.msnLocalizedKey
        viewState.msnLoginFail = key.localized
        
        // We print the full details to the console (Debug)
        Logger.error(error.logMessage)
    }
    
    private func showToast(info: FHKToastInfo) async {
        fhkToast.show(info, duration: 5.0)
    }
}
