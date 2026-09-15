//
//  FHKProfileRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import SwiftUI
import FHKDomain
import FHKCore
import FLibInjections
import FLibStorage

public extension FHKProfileRepository {
    
    static var live: Self {
        let supabase = inject.fhkAuth
        let storage = inject.fhkStorage
        let configuration = inject.fhkConfiguration
        let language = inject.fhkLanguage
        
        var repository = Self()
        
        
        repository.logout = {
            try await supabase.logout()
        }
        
        repository.deleteKeychain = { key in
            try storage.deleteKeychain(key)
        }
        
        repository.getEmailParent = {
            return configuration.parentMail()
        }
        
        repository.getLanguageCurrent = {
            let lang = try? await storage.readUserDefaults(String.self, forKey: UserDefaultsKeys.languageKey)
            return lang ?? LanguageType.en.code
        }
        
        repository.setNewLanguage = { code in
            language.changeLanguage(code)
        }
        
        repository.getFamilyName = {
            configuration.refreshFamilyName()
            return configuration.familyName()
        }
        
        return repository
        
    }
}
