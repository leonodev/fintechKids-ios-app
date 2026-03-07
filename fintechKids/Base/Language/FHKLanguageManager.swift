//
//  LanguageManager.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import Observation
import FHKInjections
import FHKStorage
import FHKDomain

@Observable
public final class FHKLanguageManager: FHKLanguageManagerProtocol {
    public var selectedLanguage: String = LanguageType.es.code()
    public var currentBundle: Bundle = .main
    
    // Properties inject
    private var storageManager: any FHKStorageManagerProtocol {
        inject.fhkStorage
    }
    
    init() {
        loadLanguageSync()
    }
    
    public func changeLanguage(to language: String) {
       updateBundle(for: language)
       selectedLanguage = language
       Task {
           try await storageManager.saveUserDefaults(language, forKey: UserDefaultsKeys.languageKey)
       }
   }

    public func languageTypeFromCode(_ string: String) -> LanguageType {
        LanguageType(rawValue: string) ?? .es
    }  
}

// Private methods
private extension FHKLanguageManager {
    
    private func loadLanguageSync() {
        Task {
            let savedLanguage = try await storageManager.readUserDefaults(String.self,
                                                                          forKey: UserDefaultsKeys.languageKey)
            updateBundle(for: savedLanguage ?? LanguageType.es.code())
        }
    }
    
    func updateBundle(for language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.currentBundle = bundle
        } else {
            self.currentBundle = .main
        }
    }
}
