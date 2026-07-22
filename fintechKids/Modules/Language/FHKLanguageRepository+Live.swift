//
//  LanguageRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

public extension FHKLanguageRepository {
    
    static var live: Self {
        var repository = Self()
        
        repository.fetchConfig = {
            do {
                try await inject.fhkFirebaseRemoteConfig.fetchConfig()
                return await inject.fhkFirebaseRemoteConfig.enabledLanguages()
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
