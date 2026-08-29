//
//  FHKLanguageRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import FHKDomain
import FHKCore
import FLibInjections
import FLibStorage

public extension FHKLanguageRepository {
    
    static var live: Self {
        var repository = Self()
        
        repository.fetchConfig = {
            do {
                try await inject.fhkFirebaseRemoteConfig.fetchConfig()
                return inject.fhkFirebaseRemoteConfig.enabledLanguages()
            } catch {
                return []
            }
        }
        
        repository.changeLanguageApp = { language in
            await inject.fhkLanguage.changeLanguage(language)
        }
        
        return repository
    }
}
