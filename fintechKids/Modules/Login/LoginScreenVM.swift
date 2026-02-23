//
//  LoginScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import SwiftUI
import Observation
import Supabase
import FHKCore
import FHKAuth
import FHKUtils
import FHKInjections
import FHKStorage

@Observable
final class LoginScreenVM: FHKCore.ViewModel {
    private let loginActor: Login
    var model: LoginModel = .init()
    
    // Properties injected
    private var securityManager: any FHKSecurityProtocol {
        inject.securityManager
    }
    
    private var storageManager: any FHKStorageManagerProtocol {
        inject.storageManager
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
    
    init(loginActor: Login = Login(factory: DefaultAuthServiceFactory())) {
        self.loginActor = loginActor
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
            // Recover the Keychain Security Seed
            guard let seed: Data = getSeed() else {
                model.loginState = .error(FHKSecurityError.readSeedFailed)
                return
            }
            
            // Generate the hash using the password entered by the user and the retrieved seed
            guard let hashedPassword = generarHash(seed: seed) else {
                model.loginState = .error(FHKSecurityError.generateHashFailed)
                return
            }
            
            // Send Login User
            let tokenAccess = try await loginActor.loginUser(platform: .supabase,
                                                                  email: model.email,
                                                                  password: hashedPassword)
            
            // We saved the Session Token PROTECTED by Face ID for the future
            saveSessionToken(tokenAccess: tokenAccess, isHasBiometry: isBiometryAvailable)
            model.loginState = .finish(nil)
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
                try await loginActor.restoreSession(platform: .supabase, token: savedToken)
                model.loginState = .finish(nil)
            }
        } catch {
            // If the user cancels, we do nothing; we just leave them on manual login.
            model.loginState = .error(FHKBiometryError.userCancelAuthentication)
        }
    }
}

private extension LoginScreenVM {
    
    func getSeed(prompt: String? = nil) -> Data? {
        try? storageManager.readKeychain(Data.self,
                                        for: "securitySeed_\(model.email)",
                                        prompt: prompt)
    }
    
    func generarHash(seed: Data) -> String? {
        securityManager.hashPassword(model.password, securitySeed: seed)
    }
    
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
