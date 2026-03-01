//
//  LoginScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import Observation
import FHKCore
import FHKAuth
import FHKInjections
import FHKStorage
import FHKDomain

@Observable
final class LoginScreenVM: FHKCore.ViewModel {
    var model: LoginModel = .init()
    
    // Properties injected
    private var securityManager: any FHKSecurityProtocol {
        inject.securityManager
    }
    
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
    }
    
    private var supabase: any FHKAuthProtocol {
        inject.supabaseManager
    }
    
    var hasSavedAuthToken: Bool {
        storageManager.exists(key: KeychainKey.authToken.rawValue)
    }
    
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
        model.loginState = .loading
        
        do {
            // Send Login User
            let userSession = try await supabase.login(email: model.email,
                                                       password: model.password)
            model.loginState = .finish(nil)
            guard let tokenAccess = userSession.accessToken else {
                return
            }
            
            // We saved the Session Token PROTECTED by Face ID for the future
            saveSessionToken(tokenAccess: tokenAccess, isHasBiometry: isBiometryAvailable)
        } catch let error as FHKDomainError {
            model.loginState = .error(error)
        } catch {
            model.loginState = .error(FHKAppError.loginUserFailed)
        }
    }
    
    @MainActor
    private func loginWithBiometrics() async {
        // Yes, we can use Face ID
        guard storageManager.isBiometryAvailable() else {
            model.loginState = .error(FHKBiometryError.notAvailable)
            return
        }
        
        do {
            // Try reading the Keychain token
            if let savedToken: String = try storageManager.readKeychain(
                String.self,
                for: KeychainKey.authToken.rawValue,
                prompt: model.getBiometryPrompt(biometryType: securityManager.getBiometryType())
            ) {
                // If FaceID accepted, we went directly into the session
                try await supabase.setSession(accessToken: savedToken)
                let isAuthenticated = await supabase.isUserAuthenticated
                model.loginState =  isAuthenticated ? .finish(nil) : .error(FHKBiometryError.notAvailable)
            }
        } catch {
            // If the user cancels, we do nothing; we just leave them on manual login.
            model.loginState = .error(FHKBiometryError.userCancelAuthentication)
        }
    }
}

private extension LoginScreenVM {
    
    func saveSessionToken(tokenAccess: String, isHasBiometry: Bool) {
        do {
            try storageManager.saveKeychain(
                tokenAccess,
                for: KeychainKey.authToken.rawValue,
                requireBiometry: isHasBiometry
            )
        } catch {
            model.loginState = .error(FHKSecurityError.saveTokenAccessKeychainFailed)
        }
    }
}
