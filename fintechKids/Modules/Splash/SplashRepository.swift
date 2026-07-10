//
//  SplashRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

public extension FHKSplashRepository {
    
    static var live: Self {
        let storage = inject.fhkStorage
        var repository = Self()
        
        repository.readLanguageCurrent = {
            try await storage.readUserDefaults(
                String.self,
                forKey: UserDefaultsKeys.languageKey
            )
        }
        
        return repository
    }
}
