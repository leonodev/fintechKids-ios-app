//
//  FHKLanguage+Live.swift
//  fintechKids
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import Observation
import FHKInjections
import FHKStorage
import FHKDomain

public extension FHKLanguage {
    
    /// Implementación de producción (.live)
    static var live: Self {
        let state = LanguageLiveState.shared
        var instance = FHKLanguage()
        
        instance.selectedLanguage = {
            state.selectedLanguage
        }
        
        instance.setSelectedLanguage = { newLanguage in
            state.selectedLanguage = newLanguage
        }
        
        instance.currentBundle = {
            state.currentBundle
        }
        
        instance.changeLanguage = { language in
            state.changeLanguage(to: language)
        }
        
        instance.languageTypeFromCode = { code in
            state.languageTypeFromCode(code)
        }
        
        return instance
    }
}

@Observable
@MainActor
private final class LanguageLiveState {
    var selectedLanguage: String = LanguageType.es.code
    var currentBundle: Bundle = .main
    
    private var storageManager: FHKStorageManager {
        inject.fhkStorage
    }
    
    // Instancia única compartida para la vida de la app
    static let shared = LanguageLiveState()
    
    private init() {
        loadLanguageSync()
    }
    
    func changeLanguage(to language: String) {
        updateBundle(for: language)
        selectedLanguage = language
        Task {
            try await storageManager.saveUserDefaults(language, forKey: UserDefaultsKeys.languageKey)
        }
    }
    
    func languageTypeFromCode(_ string: String) -> LanguageType {
        LanguageType(rawValue: string) ?? .es
    }
    
    private func loadLanguageSync() {
        Task {
            let savedLanguage = try await storageManager.readUserDefaults(
                String.self,
                forKey: UserDefaultsKeys.languageKey
            )
            let langCode = savedLanguage ?? LanguageType.es.code
            self.selectedLanguage = langCode
            self.updateBundle(for: langCode)
        }
    }
    
    private func updateBundle(for language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.currentBundle = bundle
        } else {
            self.currentBundle = .main
        }
    }
}

//@Observable
//@MainActor
//public final class FHKLanguageManager: FHKLanguageManagerProtocol {
//    public var selectedLanguage: String = LanguageType.es.code
//    public var currentBundle: Bundle = .main
//    
//    // Properties inject
//    private var storageManager: FHKStorageManager {
//        inject.fhkStorage
//    }
//    
//    init() {
//        loadLanguageSync()
//    }
//    
//    public func changeLanguage(to language: String) {
//       updateBundle(for: language)
//       selectedLanguage = language
//       Task {
//           try await storageManager.saveUserDefaults(language, forKey: UserDefaultsKeys.languageKey)
//       }
//   }
//
//    public func languageTypeFromCode(_ string: String) -> LanguageType {
//        LanguageType(rawValue: string) ?? .es
//    }  
//}
//
//// Private methods
//private extension FHKLanguageManager {
//    
//    private func loadLanguageSync() {
//        Task {
//            let savedLanguage = try await storageManager.readUserDefaults(String.self,
//                                                                          forKey: UserDefaultsKeys.languageKey)
//            updateBundle(for: savedLanguage ?? LanguageType.es.code)
//        }
//    }
//    
//    func updateBundle(for language: String) {
//        if let path = Bundle.main.path(forResource: language, ofType: "lproj"),
//           let bundle = Bundle(path: path) {
//            self.currentBundle = bundle
//        } else {
//            self.currentBundle = .main
//        }
//    }
//}
