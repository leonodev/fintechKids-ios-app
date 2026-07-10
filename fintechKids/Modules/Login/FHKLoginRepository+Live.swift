//
//  FHKLoginRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

//final class LoginRepository: FHKLoginRepositoryProtocol {
//    
//    private var fhkSupabase: any FHKAuthProtocol {
//        inject.fhkSupabase
//    }
//    
//    private var fhkStorage: any FHKStorageManagerProtocol {
//        inject.fhkStorage
//    }
//    
//    private var fhkConfiguration: any FHKConfigurationProtocol {
//        inject.fhkConfiguration
//    }
//    
//    var hasSavedToken: Bool {
//        fhkStorage.exists(key: KeychainKey.authToken.rawValue)
//    }
//
//    func login(loginEntity: LoginEntity) async throws -> FHKUserSession? {
//        let userSession = try await fhkSupabase.login(loginEntity: loginEntity)
//        return userSession
//    }
//    
//    func loginWithBiometrics(prompt: String) async throws {
//        guard fhkStorage.isBiometryAvailable() else {
//            throw FHKAppError.biometryNotAvailable
//        }
//        
//        // Try reading the Keychain token
//        guard let savedToken = try fhkStorage.readKeychain(
//                    String.self,
//                    for: KeychainKey.authToken.rawValue,
//                    prompt: prompt
//        ) else {
//            throw FHKAppError.biometryNotAvailable
//        }
//        
//        // If FaceID accepted, we went directly into the session
//        try await fhkSupabase.setSession(accessToken: savedToken)
//        let isAuthenticated = await fhkSupabase.isUserAuthenticated
//        if !isAuthenticated {
//            throw FHKAppError.biometryNotAvailable
//        }
//    }
//    
//    func saveAuthToken(_ token: String, requiresBiometry: Bool) throws {
//        try fhkStorage.saveKeychain(
//            token,
//            for: KeychainKey.authToken.rawValue,
//            requireBiometry: requiresBiometry
//        )
//    }
//    
//    func savePinApproveTask(pin: String) async throws {
//        try fhkStorage.saveKeychain(pin, for: KeychainKeys.approvePinKey)
//    }
//    
//    func saveUserIntoKeychain(email: String) async throws {
//        try fhkStorage.saveKeychain(email, for: KeychainKeys.userKey)
//        refreshParentMail()
//    }
//    
//    func refreshParentMail() {
//        fhkConfiguration.refreshParentMail()
//    }
//}

public extension FHKLoginRepository {
    
    static var live: Self {
        // Declaramos las dependencias locales una sola vez para todo el bloque
        let supabase = inject.fhkSupabase
        let storage = inject.fhkStorage
        let configuration = inject.fhkConfiguration
        
        var repository = Self()
        
        // Ahora las clausuras las usan de forma directa, corta y limpia:
        repository.hasSavedToken = {
            storage.exists(key: KeychainKey.authToken.rawValue)
        }
        
        repository.login = { loginEntity in
            try await supabase.login(loginEntity: loginEntity)
        }
        
        repository.loginWithBiometrics = { prompt in
            guard storage.isBiometryAvailable() else {
                throw FHKAppError.biometryNotAvailable
            }
            
            guard let savedToken = try storage.readKeychain(
                String.self,
                for: KeychainKey.authToken.rawValue,
                prompt: prompt
            ) else {
                throw FHKAppError.biometryNotAvailable
            }
            
            // Si FaceID lo acepta, configuramos la sesión con 'supabase'
            try await supabase.setSession(accessToken: savedToken)
            
            let isAuthenticated = await supabase.isUserAuthenticated
            if !isAuthenticated {
                throw FHKAppError.biometryNotAvailable
            }
        }
        
        repository.saveAuthToken = { token, requiresBiometry in
            try storage.saveKeychain(token, for: KeychainKey.authToken.rawValue, requireBiometry: requiresBiometry)
        }
        
        repository.savePinApproveTask = { pin in
            try storage.saveKeychain(pin, for: KeychainKeys.approvePinKey)
        }
        
        repository.saveUserIntoKeychain = { email in
            try storage.saveKeychain(email, for: KeychainKeys.userKey)
            configuration.refreshParentMail()
        }
        
        repository.refreshParentMail = {
            configuration.refreshParentMail()
        }
        
        return repository
    }
}
