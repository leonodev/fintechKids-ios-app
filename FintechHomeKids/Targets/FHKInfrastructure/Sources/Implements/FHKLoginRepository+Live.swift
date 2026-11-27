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
        let storage = inject.fhkStorage
        let configuration = inject.fhkConfiguration
        
        var repository = Self()
        
        repository.login = { loginParams throws(FHKAppError) in
            let responseDto: FHKLoginResponseDto = try await FHKAPI.Builder()
                .setPath(.login)
                .setBody(body: loginParams.toDto())
                .setMethod(.POST)
                .build()
                .execute()
            
            return responseDto.toDomain()
        }
        
        repository.loginWithBiometrics = { prompt throws(FHKAppError) in
            
            guard storage.isBiometryAvailable() else {
                throw FHKAppError.biometryNotAvailable
            }
            
            guard let _ = try storage.readSecureKeychain(
                String.self,
                for: KeychainKeys.accessTokenKey,
                prompt: prompt
            ) else {
                throw FHKAppError.biometryNotAvailable
            }
        }

        repository.savePinApproveTask = { pin throws(FHKAppError) in
            try storage.saveSecureKeychain(pin, for: KeychainKeys.approvePinKey)
            configuration.refreshApprovePin()
        }
        
        repository.saveUserIntoKeychain = { email throws(FHKAppError) in
            try storage.saveSecureKeychain(email, for: KeychainKeys.userKey)
            configuration.refreshParentMail()
        }
        
        repository.refreshParentMail = {
            configuration.refreshParentMail()
        }
        
        return repository
    }
}
