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
    private var fhkLanguage: any FHKLanguageManagerProtocol {
        inject.fhkLanguage
    }
    
    private var fhkFirebaseRemoteConfig: any FHKRemoteConfigManagerProtocol {
        inject.fhkFirebaseRemoteConfig
    }
    
    func fetchConfig() async -> [String] {
        do {
            try await fhkFirebaseRemoteConfig.fetchConfig()
            return await fhkFirebaseRemoteConfig.enabledLanguages
        } catch {
            return []
        }
    }

    func changeLanguageApp(_ language: String) async {
        await fhkLanguage.changeLanguage(to: language)
    }
}
