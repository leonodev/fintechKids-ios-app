//
//  LanguageRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/3/26.
//

import FHKDomain
import FHKInjections
import FHKStorage

final class LanguageRepository: FHKLanguageRepositoryProtocol {
    
    // Properties Injected
    private var languageManager: any FHKLanguageManagerProtocol {
        inject.languageManager
    }
    
    private var remoteConfigManager: any FHKRemoteConfigManagerProtocol {
        inject.firebaseRemoteConfigManager
    }
    
    func fetchConfig() async -> [String] {
        do {
            try await remoteConfigManager.fetchConfig()
            return await remoteConfigManager.enabledLanguages
        } catch {
            return []
        }
    }

    func changeLanguageApp(_ language: String) async {
        languageManager.changeLanguage(to: language)
    }
}
