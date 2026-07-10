//
//  FHKRegisterRepository+Live.swift
//  fintechKids
//
//  Created by Fredy Leon on 2/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

public extension FHKRegisterRepository {
    static var live: Self {
        var repo = Self()
        
        repo.register = { registerEntity in
            try await inject.fhkSupabase.register(registerEntity: registerEntity)
        }
        
        repo.saveFamilyInfoKeychain = { familyName in
            try inject.fhkStorage.saveKeychain(familyName, for: KeychainKeys.familyNameKey)
        }
        
        return repo
    }
}
