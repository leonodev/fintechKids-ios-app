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
    var securityManager = inject.securitymanager
    var storageManager = inject.storagemanager
    
    var hasSavedAuthToken: Bool {
        storageManager.exists(key: KeychainKey.authToken.rawValue)
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
            // Recuperar la semilla (Security Seed) del Keychain
            guard let seed: Data = try storageManager.readKeychain(Data.self,
                                                                   for: "securitySeed_\(model.email)",
                                                                   prompt: nil) else {
                
                model.loginState = .error(
                    Log(error: FHKSecurityError.userNotRegisteredIntoDevice,
                        attributes: LogAttributes(action: self.nameAction,
                                                  feature: .login)
                       )
                )
                
                Logger.error("The user did not register on this device.")
                return
            }
            
            // Generar el Hash usando la contraseña que escribió el usuario y la semilla recuperada
            guard let hashedPassword = securityManager.hashPassword(model.password, securitySeed: seed) else {
                throw FHKSecurityError.hashingFailed
            }
            
            // Send Login User
            let tokenAccessToken = try await loginActor.loginUser(platform: .supabase,
                                                                  email: model.email,
                                                                  password: hashedPassword)
            
            // guardamos el Session Token PROTEGIDO por FaceID para el futuro
            try storageManager.saveKeychain(
                tokenAccessToken,
                for: KeychainKey.authToken.rawValue,
                requireBiometry: true
            )
            
            model.loginState = .finish(nil)
        } catch let error as AuthDomainError {
            model.loginState = .error(
                Log(error: error,
                    attributes: LogAttributes(action: self.nameAction,
                                              feature: .login)
                   )
            )
        } catch {
            model.loginState = .error(
                Log(error: error,
                    attributes: LogAttributes(action: self.nameAction,
                                              feature: .login)
                   )
            )
        }
    }
    
    @MainActor
    private func loginWithBiometrics() async {
        // si Podemos usar FaceID
        guard storageManager.isBiometryAvailable() else {
            Logger.error("Biometry not available")
            return
        }
        
        do {
            // Intenta leer el token del Keychain
            if let savedToken: String = try storageManager.readKeychain(String.self,
                                                                        for: KeychainKey.authToken.rawValue,
                                                                        prompt: "Inicia sesión rápidamente con tu cara"
            ) {
                // Si FaceID aceptó, entramos directamente a la sesión
                try await loginActor.restoreSession(platform: .supabase, token: savedToken)
                model.loginState = .finish(nil)
            }
        } catch {
            // Si el usuario cancela, no hacemos nada, solo lo dejamos en el login manual
            print("Autenticación biométrica cancelada o fallida")
        }
    }
}
