//
//  FHKSplashRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import FLibInjections
import FLibStorage
import FHKDomain
import FHKCore

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
