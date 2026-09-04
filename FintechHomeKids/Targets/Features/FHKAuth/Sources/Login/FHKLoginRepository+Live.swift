//
//  FHKLoginRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import FHKDomain
import FHKCore
import FLibInjections
import FLibStorage

public extension FHKLoginRepository {
    
    static var live: Self {
        let supabase = inject.fhkAuth
        let storage = inject.fhkStorage
        let configuration = inject.fhkConfiguration
        
        var repository = Self()
        
        repository.hasSavedToken = {
            storage.exists(key: KeychainKey.authToken.rawValue)
        }
        
        repository.login = { loginEntity in
            try await supabase.login(loginEntity)
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
            
            try await supabase.setSession(savedToken)
            
            let isAuthenticated = await supabase.isUserAuthenticated()
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
