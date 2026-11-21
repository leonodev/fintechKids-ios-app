//
//  FHKRegisterRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import FHKDomain
import FHKCore
import FLibInjections
import FLibStorage

public extension FHKRegisterRepository {
    
    static var live: Self {
        var repo = Self()

        repo.register = { registerEntity in
            
            let responseDto: FHKRegisterResponse = try await FHKAPI.Builder()
                            .setPath(.register)
                            .setBody(body: registerEntity.toDto())
                            .setMethod(.POST)
                            .build()
                            .execute()
            
            return responseDto
        }
        
        repo.saveFamilyInfoKeychain = { familyName in
            try inject.fhkStorage.saveKeychain(familyName, for: KeychainKeys.familyNameKey)
        }
        
        return repo
    }
}
