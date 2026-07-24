//
//  FHKProfileRepository+Live.swift
//  fintechKids
//
//  Created by Fredy Leon on 8/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

public extension FHKProfileRepository {
    
    static var live: Self {
        var repository = Self()
        
        repository.logout = {}
        
        repository.deleteKeychain = { key in
            try inject.fhkStorage.deleteKeychain(key)
        }
        
        repository.getEmailParent = {
            inject.fhkConfiguration.parentMail()
        }
        
        repository.getLanguageCurrent = {
            let language = try await inject.fhkStorage.readUserDefaults(String.self, forKey: UserDefaultsKeys.languageKey)
            return language ?? LanguageType.es.code
        }
        
        repository.setNewLanguage = { lang in
            inject.fhkLanguage.changeLanguage(lang)
        }
        
        repository.getFamilyName = {
            inject.fhkConfiguration.refreshFamilyName()
            return inject.fhkConfiguration.familyName()
        }
        
        return repository
    }
}
